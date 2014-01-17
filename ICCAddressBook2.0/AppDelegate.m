//
//  AppDelegate.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "CustomTabBarItem.h"

#import "NearbyViewCtrl.h"
#import "TalkViewCtrl.h"
#import "FriendViewCtrl.h"
#import "SettingViewCtrl.h"

#import "ChatViewCtrl.h"
#import "JSON.h"
#import "User.h"
#import "Tooles.h"
#import "XJParser.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize dialogues = _dialogues;
@synthesize webSocket = _webSocket;
@synthesize waiter = _waiter;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [_dialogues release];
    [_webSocket release], _webSocket = nil;
    [_waiter release];
    [[NetWorkManager sharedManager] stopNotifier];
    
    [super dealloc];
}

//------------------------------------------------------------------------------------------------------------
// start: 注册推送通知
//------------------------------------------------------------------------------------------------------------
- (void)registerForRemoteNotification
{
    NSString *pushOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"pushON"];
    if (![pushOn isEqual:@"1"])
        return;
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
}

#pragma mark - Push notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
{
    NSString *responseData = [[deviceToken description] 
                              stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@""]];
    
    responseData = [responseData stringByReplacingOccurrencesOfString:@" " withString:@""];
    responseData = [responseData stringByReplacingOccurrencesOfString:@"<" withString:@""];
    responseData = [responseData stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    [[User currentUser] setDeviceToken:responseData];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error 
{
    NSLog(@">>>>---------------------------------------> %@", error);
    
    [[User currentUser] setDeviceToken:@""];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 
{
    NSLog(@">>>>---------------------------------------> %@", userInfo);
    
    if (application.applicationState == UIApplicationStateInactive) 
    {/*
        SBJsonWriter *jsonWriter = [[[SBJsonWriter alloc] init] autorelease];
        NSString *jsonString = [jsonWriter stringWithObject:userInfo];
        
        [self handleChat:jsonString];*/
    }
}
//------------------------------------------------------------------------------------------------------------
// end: 注册推送通知
//------------------------------------------------------------------------------------------------------------





//------------------------------------------------------------------------------------------------------------
// start: 初始化设置信息
//------------------------------------------------------------------------------------------------------------
- (void)openSetting
{
    NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   nil,  @"username",
                                   nil,  @"password",
                                   nil,  @"pushON"  ,       //推送是否开启
                                   nil,  @"soundON" ,       //消息声音是否开启
                                   nil,  @"alertON" ,       //静音是否开启
                                   nil,  @"alert_s" ,       //静音开始时间
                                   nil,  @"alert_e" ,       //静音结束时间
                                   nil]; 
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"soundON"];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"pushON"];
}
//------------------------------------------------------------------------------------------------------------
// end: 初始化设置信息
//------------------------------------------------------------------------------------------------------------





//------------------------------------------------------------------------------------------------------------
// start: webSocket 相关函数调用
//------------------------------------------------------------------------------------------------------------
- (void)openSocket
{
    NSURL *url = [NSURL URLWithString:COMMUNICATION];               //ws://echo.websocket.org
    self.webSocket = [[[WSWebSocket alloc] initWithURL:url protocols:nil] autorelease];
    
    [_webSocket setTextCallback:^(NSString *text) {
        [self performSelectorOnMainThread:@selector(handleChat:) withObject:text waitUntilDone:NO];
    }];
    
    [_webSocket setCloseCallback:^(NSUInteger statusCode, NSString *message) {
        [self performSelectorOnMainThread:@selector(handleCloseCallback:) withObject:message waitUntilDone:NO];
    }];
    
    [_webSocket open];
    [_webSocket sendPingWithData:[NSData dataWithBytes:"{}" length:2]];
}

- (void)handleCloseCallback:(NSString *)message
{
    
}

//------------------------------------------------------------------------------------------------------------
// end: webSocket 相关函数调用
//------------------------------------------------------------------------------------------------------------





//------------------------------------------------------------------------------------------------------------
// start: 消息处理
//------------------------------------------------------------------------------------------------------------
- (void)handleChat:(NSString *)chat
{
    // 将消息结构体转换成字典
    SBJSON *json = [[[SBJSON alloc] init] autorelease];
    NSDictionary *dic = (NSDictionary *)[json objectWithString:chat];
    NSLog(@"%@", dic);
    // 消息发送人的id
    NSString *personId = [dic objectForKey:@"from"];
    BOOL soundON = [[[NSUserDefaults standardUserDefaults] objectForKey:@"soundON"] isEqual:@"1"];
    
    // 收到消息时，给声音提示（如果是自己发的消息则不播放声音:personId）
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"ms_get" ofType:@"caf"];
    
    // 资源路径正确、且不是自己发送的消息、且设置中声音是打开的，则播放收到消息的声音
    if (audioPath && personId && soundON) 
    {
        // 是否静音
        BOOL if_silence = NO;
        
        // 静音设置 YES:静音开启
        BOOL alertOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alertON"] isEqual:@"1"];
        if (alertOn) 
        {
            int alert_s  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alert_s"] intValue];
            int alert_e  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alert_e"] intValue];
            NSLog(@"%d,%d,%d", alert_s, alert_e, [Tooles currentTime]);
            if (alert_s > alert_e) 
            {
                if ([Tooles currentTime] > alert_s || [Tooles currentTime] < alert_e) 
                    if_silence = YES;
            }
            else if (alert_s < alert_e) 
            {
                if ([Tooles currentTime] > alert_s && [Tooles currentTime] < alert_e) 
                    if_silence = YES;
            }
        }
        
        // if_silence = YES 在静音设置时间范围内，关闭声音
        if (!if_silence) 
        {
            AVAudioPlayer *auPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
                                       [NSURL fileURLWithPath:audioPath] error:nil];
            [auPlayer setDelegate:self];
            [auPlayer play];
            
            NSString *soundOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"soundAlert"];
            NSLog(@"___silence,%@", soundOn);
            [Tooles loudSpeaker:![soundOn isEqual:@"1"]];   //1:来消息时无声音
        }
        
    }
    
    
    // 从好友列表中匹配出此id的联系人
    Person *matchedPerson = nil;
    for (Person *person in [User currentUser].persons) 
    {
        if ([person.personId isEqual:personId]) 
        {
            matchedPerson = person;
            
            if (![DIManager _if_dialogue_exist:personId]) 
            {
                ChatViewCtrl *ctrl = [[[ChatViewCtrl alloc] initWithPerson:person] autorelease];
                ctrl.hidesBottomBarWhenPushed = YES;
                
                [[DIManager _opening_dialogues] addObject:ctrl];
            }
            
            // 显示信息条数，来消息时如果正在聊天则不增加未读消息数量
            ChatViewCtrl *ctrl = [DIManager _dialogue_with_person:matchedPerson];
            if (!ctrl.view.superview) 
            {
                matchedPerson.msgCount = [NSString stringWithFormat:@"%d", [person.msgCount intValue] + 1];
            }
            break;
        }
    }
    
    // 如果对话列表中不存在消息接收人，则创建一个
    if (![DIManager _if_dialogue_exist:personId] && matchedPerson != nil) 
    {
        ChatViewCtrl *ctrl;
        ctrl = [[ChatViewCtrl alloc] initWithPerson:matchedPerson];
        ctrl.hidesBottomBarWhenPushed = YES;
        
        [[DIManager _opening_dialogues] addObject:ctrl];
    }
    
    
    if (matchedPerson != nil) 
    {
        // 指派消息给相应的"对话"
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appendText" object:dic];
        
        // 显示信息条数，来消息时如果正在聊天则不增加未读消息数量
        ChatViewCtrl *ctrl = [DIManager _dialogue_with_person:matchedPerson];
        if (!ctrl.view.superview) 
        {
            // 通知对话列表更新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:dic];
            
            UIViewController *v = [self.tabBarController.viewControllers objectAtIndex:1];
            int badgeValue = [v.tabBarItem.badgeValue intValue];
            v.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", badgeValue + 1];
            ctrl.person.msgCount = v.tabBarItem.badgeValue;
        }
    }
    
    // 发送消息 的确认消息（没有id字段）
    if (!personId) 
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"success_send" object:dic];
    }
}

#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	[player release];
}
//------------------------------------------------------------------------------------------------------------
// end: 消息处理
//------------------------------------------------------------------------------------------------------------





//------------------------------------------------------------------------------------------------------------
// start: 主界面元素
//------------------------------------------------------------------------------------------------------------
- (NSArray *)tabBarControllers
{
    NearbyViewCtrl  *nearby      = [[[NearbyViewCtrl         alloc] initWithNibName:@"NearbyViewCtrl" bundle:nil] autorelease];
    TalkViewCtrl    *talk        = [[[TalkViewCtrl           alloc] initWithStyle:UITableViewStylePlain]          autorelease];
    FriendViewCtrl  *friend      = [[[FriendViewCtrl         alloc] initWithStyle:UITableViewStylePlain]          autorelease];
    SettingViewCtrl *setting     = [[[SettingViewCtrl        alloc] initWithStyle:UITableViewStyleGrouped]        autorelease];
    
    UINavigationController *nav1 = [[[UINavigationController alloc] initWithRootViewController:nearby]            autorelease];
    UINavigationController *nav2 = [[[UINavigationController alloc] initWithRootViewController:talk]              autorelease];
    UINavigationController *nav3 = [[[UINavigationController alloc] initWithRootViewController:friend]            autorelease];
    UINavigationController *nav4 = [[[UINavigationController alloc] initWithRootViewController:setting]           autorelease];
    
    return [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nil];
}
//------------------------------------------------------------------------------------------------------------
// end: 主界面元素
//------------------------------------------------------------------------------------------------------------





//------------------------------------------------------------------------------------------------------------
// start: 监测网络状态
//------------------------------------------------------------------------------------------------------------
- (void) netWorkStatusWillChange:(NetworkStatus)status
{
	if (status == NotReachable) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"netWorkStatusChanged" object:@"1"];
	} else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"netWorkStatusChanged" object:@"0"];
        [self openSocket];
    }
}
//------------------------------------------------------------------------------------------------------------
// end: 监测网络状态
//------------------------------------------------------------------------------------------------------------





//------------------------------------------------------------------------------------------------------------
// start: 应用程序生命周期(程序启动、进入前台、进入后台.....)
//------------------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [self tabBarControllers];
    self.dialogues = [NSMutableArray arrayWithCapacity:0];
    
    // 注册推送通知
    [self registerForRemoteNotification];
    
    // 初始化设置信息
    [self openSetting];
    
    // 初始化网络请求服务器
    if (_waiter == nil) 
    {
        _waiter = [[XJWaiter alloc] init];
        _waiter.delegate = self;
    }
    
    // 初始化网络状态观察器
    [[NetWorkManager sharedManager] setDelegate:self];
    [[NetWorkManager sharedManager] startNetWorkeWatch];
    
    [self.window setRootViewController:_tabBarController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 关闭会话
    [_webSocket close];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    
    // 开启会话
    [self openSocket];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}
//------------------------------------------------------------------------------------------------------------
// end: 应用程序生命周期
//------------------------------------------------------------------------------------------------------------

@end
