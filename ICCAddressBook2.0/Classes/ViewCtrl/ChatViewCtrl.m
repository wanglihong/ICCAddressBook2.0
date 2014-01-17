//
//  ChatViewCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChatViewCtrl.h"

#import "TalkViewCtrl.h"

#import "Tooles.h"

#import "DIManager.h"

#import "JSON.h"

#import "User.h"

#import "ListView.h"

#import "BubbleView.h"

@interface ChatViewCtrl ()

@end

@implementation ChatViewCtrl

@synthesize person = _person;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _chatContents = [NSMutableArray new];
    }
    return self;
}

- (id)initWithPerson:(Person *)thePerson
{
    self = [super init];
    if (self) 
    {
        _chatContents = [NSMutableArray new];
        self.person   = thePerson;
        self.title    = thePerson.chineseName;
        
        //------------------------------------------------------------------------------------------------------------
        // start: chat contents container
        //------------------------------------------------------------------------------------------------------------
        _tableView = [[ListView alloc] initWithFrame:CGRectMake(0, 0, 320, 372)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg3.png"]] autorelease];
        _tableView.contentInset = UIEdgeInsetsMake(31.0f, 0, 0, 0);
        //------------------------------------------------------------------------------------------------------------
        // end: 
        //------------------------------------------------------------------------------------------------------------
        
        //------------------------------------------------------------------------------------------------------------
        // start: keyboard bottom bar
        //------------------------------------------------------------------------------------------------------------
        _keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        UIImageView *_keyboardView_bg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
        _keyboardView_bg.image = [UIImage imageNamed:@"chat_typebg.png"];
        
        _inputField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 238, 31)];
        _inputField.borderStyle = UITextBorderStyleRoundedRect;
        _inputField.delegate = self;
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setFrame:CGRectMake(255, 7, 48, 29)];
        [_sendBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                             forState:UIControlStateNormal];
        [_sendBtn setAlpha:0.0];
        [_sendBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setFrame:CGRectMake(255, 7, 48, 29)];
        [_voiceBtn setImage:[UIImage imageNamed:@"btn_typevoice.png"] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(turnToRecorderBar) forControlEvents:UIControlEventTouchUpInside];
        
        [_keyboardView addSubview:_keyboardView_bg];
        [_keyboardView addSubview:_inputField];
        [_keyboardView addSubview:_sendBtn];
        [_keyboardView addSubview:_voiceBtn];
        //------------------------------------------------------------------------------------------------------------
        // end: 
        //------------------------------------------------------------------------------------------------------------
        
        //------------------------------------------------------------------------------------------------------------
        // start: recorder bottom bar
        //------------------------------------------------------------------------------------------------------------
        _recorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        UIButton *_recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setFrame:CGRectMake(0, 0, 320, 44)];
        [_recordBtn setImage:[UIImage imageNamed:@"btn_voice.png"] forState:UIControlStateNormal];
        [_recordBtn setImage:[UIImage imageNamed:@"btn_voice_press.png"] forState:UIControlStateHighlighted];
        [_recordBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpOutside];
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setFrame:CGRectMake(255, 7, 48, 29)];
        [_backBtn setImage:[UIImage imageNamed:@"btn_voicekey.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(turnToBottomBar) forControlEvents:UIControlEventTouchUpInside];
        
        [_recorderView addSubview:_recordBtn];
        [_recorderView addSubview:_backBtn];
        
        recoder = [[SoundRecorder alloc] initWithFrame:CGRectMake(0, 0, 320, 372)];
        recoder.delegate = self;
        //------------------------------------------------------------------------------------------------------------
        // end: 
        //------------------------------------------------------------------------------------------------------------
        
        //------------------------------------------------------------------------------------------------------------
        // start: custom bottom bar
        //------------------------------------------------------------------------------------------------------------
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, 372, 320, 44)];
        _bottomBar.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_tableView];
        [self.view addSubview:_bottomBar];
        [_bottomBar addSubview:_keyboardView];
        //------------------------------------------------------------------------------------------------------------
        // end: 
        //------------------------------------------------------------------------------------------------------------
        
        //------------------------------------------------------------------------------------------------------------
        // start: customized left navgationBar buttonItem
        //------------------------------------------------------------------------------------------------------------
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [leftBtn setBackgroundImage:[[UIImage imageNamed:@"nav_back_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                           forState:UIControlStateNormal];
        [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
        [leftBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        [leftBtn release];
        [leftBarButtonItem release];
        //------------------------------------------------------------------------------------------------------------
        // end: 
        //------------------------------------------------------------------------------------------------------------
        
        //------------------------------------------------------------------------------------------------------------
        // start: customized right navgationBar buttonItem
        //------------------------------------------------------------------------------------------------------------
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
        [rightBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                            forState:UIControlStateNormal];
        [rightBtn setTitle:@"TA的资料" forState:UIControlStateNormal];
        [rightBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        [rightBtn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        [rightBtn release];
        [rightBarButtonItem release];
        //------------------------------------------------------------------------------------------------------------
        // end: 
        //------------------------------------------------------------------------------------------------------------
        
        //------------------------------------------------------------------------------------------------------------
        // start: network status
        //------------------------------------------------------------------------------------------------------------
        _networkStatusView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -61, 320, 61)];
        _networkStatusView.image = [UIImage imageNamed:@"icon_chat_alert.png"];
        
        _statusTitleLabel = [[UILabel alloc] initWithFrame:_networkStatusView.bounds];
        _statusTitleLabel.backgroundColor = [UIColor clearColor];
        _statusTitleLabel.textAlignment = UITextAlignmentCenter;
        _statusTitleLabel.font = [UIFont systemFontOfSize:14.0];
        _statusTitleLabel.textColor = [UIColor darkTextColor];
        
        [self.view addSubview:_networkStatusView];
        [_networkStatusView addSubview:_statusTitleLabel];
        [_statusTitleLabel release];
        [_networkStatusView release];
        //------------------------------------------------------------------------------------------------------------
        // end: network status
        //------------------------------------------------------------------------------------------------------------
        
        //------------------------------------------------------------------------------------------------------------
        // start: register notification
        //------------------------------------------------------------------------------------------------------------
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendText:) 
                                                     name:@"appendText" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageDidSend:) 
                                                     name:@"success_send" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStatusChanged:) 
                                                     name:@"netWorkStatusChanged" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
                                                     name:UIKeyboardWillShowNotification object:nil];  
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) 
                                                     name:UIKeyboardWillHideNotification object:nil]; 
        // 键盘高度变化通知，ios5.0新增的    
#ifdef __IPHONE_5_0  
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];  
        if (version >= 5.0) 
        {   
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
                                                         name:UIKeyboardWillChangeFrameNotification object:nil];  
        }  
#endif 
        //------------------------------------------------------------------------------------------------------------
        // end: 
        //------------------------------------------------------------------------------------------------------------
        
    }
    return self;
}

- (void)dealloc
{
    [_chatContents release], _chatContents = nil;
    [_person release]; _person = nil;
    
    _inputField.delegate = nil, 
    [_inputField release];
    [_tableView release], _tableView = nil;
    [_recorderView release], _recorderView = nil;
    [_keyboardView release], _keyboardView = nil;
    [_bottomBar release], _bottomBar = nil;
    [recoder release], recoder = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 更新tabBar信息条数
    UIViewController *v = [self.tabBarController.viewControllers objectAtIndex:1];
    int badgeValue = [v.tabBarItem.badgeValue intValue] - [self.person.msgCount intValue];
    if (badgeValue <= 0) 
        v.tabBarItem.badgeValue = nil;
    else 
        v.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", badgeValue];
    
    // 当前会话未读信息条数置0
    self.person.msgCount = @"0";
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detail
{
    DetailViewCtrl *ctrl = [[[DetailViewCtrl alloc] initWithNibName:@"DetailViewCtrl" bundle:nil] autorelease];
    ctrl.person = self.person;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)update
{
    _inputField.text = @"";
    [_tableView reloadData];
    
    if (_chatContents.count > 0) 
    {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_chatContents count]-1 inSection:0] 
                          atScrollPosition:UITableViewScrollPositionBottom 
                                  animated:NO];
    }
}

- (void)updateMSGSendState:(UIView *)chatView
{
    if (chatView.tag != 1) 
    {
        UIImageView *state = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        UIImage *image = [UIImage imageNamed:@"icon_msgfail.png"];
        state.image = image;
        state.frame = CGRectMake(-image.size.width, 10.0, image.size.width, image.size.height);
        [chatView addSubview:state];
    } 
}

- (void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)animationDuration
{
    // 控件高度 －－ 状态栏：20 导航栏：44 键盘：216 输入栏：44
    float y = 480 - 20 - 44 - height - 44;
    animate(_bottomBar, CGRectMake(0.0f, y, 320.0f, 44.0f));
    animate(_tableView, CGRectMake(0.0f, 0.0f, 320.0f, y));
    
    [self update];
}

- (void)appendText:(NSNotification *)_notification
{
    NSDictionary *dic    = [_notification object];
    NSString *from       = [dic objectForKey:@"from"];      //消息发送人
    NSString *content    = [dic objectForKey:@"data"];      //消息内容
    NSString *created    = [dic objectForKey:@"created"];   //消息时间
    NSString *type       = [dic objectForKey:@"type"];      //消息类型
    
    if ([from isEqual:self.person.personId]) 
    {
        if ([type isEqual:@"text/plain"]) 
        {/*
            UIView *chatView = [Tooles bubbleWithText:content 
                                             byMySelf:[from isEqual:[User currentUser].person.personId] 
                                           picAddress:[NSString stringWithFormat:@"%@%@", ICON_ADDRESS, self.person.pic160] 
                                            timeStamp:[Tooles getFormattedDate:created]];*/
            BubbleView *chatView = [[BubbleView alloc] initWithHead:[NSString stringWithFormat:@"%@%@", ICON_ADDRESS, self.person.pic160] 
                                                            content:content 
                                                               date:[Tooles getFormattedDate:created] 
                                                             isSelf:[from isEqual:[User currentUser].person.personId]];
            
            [_chatContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:chatView, @"view", nil]];
            [chatView release];
        }
        else 
        {/*
            BubbleView *chatView = (BubbleView *)[Tooles bubbleWithText:@")))" 
                                             byMySelf:[from isEqual:[User currentUser].person.personId] 
                                           picAddress:[NSString stringWithFormat:@"%@%@", ICON_ADDRESS, self.person.pic160] 
                                            timeStamp:[Tooles getFormattedDate:created]];*/
            BubbleView *chatView = [[BubbleView alloc] initWithHead:[NSString stringWithFormat:@"%@%@", ICON_ADDRESS, self.person.pic160] 
                                                            content:@")))" 
                                                               date:[Tooles getFormattedDate:created] 
                                                             isSelf:[from isEqual:[User currentUser].person.personId]];
            
            [_chatContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:chatView, @"view", nil]];
            [chatView release];
            
            NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            //转换到base64
            data = [GTMBase64 decodeData:data]; 
            chatView.audio = data;
        }
        
        position++;
        [self update];
    }
}

// 消息发送 收到服务的返回信息后，对消息标记
- (void)messageDidSend:(NSNotification *)_notification
{
    NSDictionary *dic    = [_notification object];
    NSString *no         = [dic objectForKey:@"no"];      //第x条消息发送的状态（是否成功）
    
    
    if ([_chatContents count] <= [no intValue]) 
        return;
    
    NSDictionary *chatInfo = [_chatContents objectAtIndex:[no intValue]];
    UIView *chatView = [chatInfo objectForKey:@"view"];
    chatView.tag = 1;   //标记此条信息状态为 发送成功
    
    UIImageView *state = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    UIImage *image = [UIImage imageNamed:@"icon_msgsent.png"];
    state.image = image;
    state.frame = CGRectMake(-image.size.width, 10.0, image.size.width, image.size.height);
    [chatView addSubview:state];
}

// 网络状态发生变化时做相关处理
- (void)netWorkStatusChanged:(NSNotification *)_notification
{
    NSString *statues = [_notification object];
    _statusTitleLabel.text = [statues isEqual:@"0"] ? @"已链接" : @"已断开链接";
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    _networkStatusView.frame = CGRectMake(0, [statues isEqual:@"0"] ? -61 : 0, 320, 61);
    
    [UIView commitAnimations];
}

// 开始录音
- (void)startRecord
{
    NSLog(@"startRecord");
    
    [self.view addSubview:recoder];
    [recoder startRecord];
}

// 结束录音
- (void)endRecord
{
    NSLog(@"endRecord");
    
    [recoder removeFromSuperview];
    [recoder stopRecord];
    //[recoder startPlay];
}

- (void)waiter:(XJWaiter *)waiter requestDidSucceedWithResult:(id)result
{
    NSLog(@"________%@", result);
}

- (void)waiter:(XJWaiter *)waiter requestDidFailWithError:(NSError *)error
{
    NSLog(@"________%@", [error description]);
}

// 录音完成后调用此方法
- (void)soundRecordDidFinishWithFile:(NSString *)filePath
{
    NSLog(@"sound file path: %@", filePath);
    
    NSData *soundData = [NSData dataWithContentsOfFile:filePath];
    
    NSAssert(soundData, @"file not exist!");
    
    // 对音频数据编码(转成base64)
    NSData *data = [GTMBase64 encodeData:soundData];
    NSLog(@"_______base64 data length:%d", [data length]);
    NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]; 
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                _person.personId,                   @"to",      //消息接收人
                                @"audio/mpeg",                      @"type",    //文本类型
                                base64String,                       @"data",    //消息内容
                                [User currentUser].person.personId, @"from",    //消息发送人
                                [NSString stringWithFormat:@"%d", position], @"no", //消息索引位置
                                nil];
    
    if (1) 
    {
        // 发送消息时，给声音提示
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"ms_send" ofType:@"caf"];
        if (audioPath) 
        {
            AVAudioPlayer *auPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
                                       [NSURL fileURLWithPath:audioPath] error:nil];
            //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
            [auPlayer setDelegate:self];
            [auPlayer play];
            
            NSString *soundOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"soundAlert"];
            [Tooles loudSpeaker:[soundOn isEqual:@"1"]];
        }
        /*
        BubbleView *chatView = (BubbleView *)[Tooles bubbleWithText:@"(((" 
                                         byMySelf:YES 
                                       picAddress:[NSString stringWithFormat:@"%@%@", ICON_ADDRESS, [User currentUser].person.pic160] 
                                        timeStamp:[Tooles systemTime]];*/
        BubbleView *chatView = [[BubbleView alloc] initWithHead:[NSString stringWithFormat:@"%@%@", ICON_ADDRESS, [User currentUser].person.pic160] 
                                                        content:@"(((" 
                                                           date:[Tooles systemTime] 
                                                         isSelf:YES];
        chatView.audio = soundData;
        [_chatContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:chatView, @"view", nil]];
        [chatView release];
        
        position++;
        [self update];
        [self performSelector:@selector(updateMSGSendState:) withObject:chatView afterDelay:30.0];
    }
    
    SBJsonWriter *jsonWriter = [[[SBJsonWriter alloc] init] autorelease];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    
    [([DIManager _app_delegate]).webSocket sendText:jsonString];
}

- (IBAction)send
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                _person.personId,                   @"to",      //消息接收人
                                @"text/plain",                      @"type",    //文本类型
                                _inputField.text,                   @"data",    //消息内容
                                [User currentUser].person.personId, @"from",    //消息发送人
                                [NSString stringWithFormat:@"%d", position], @"no", //消息索引位置
                                nil];
    
    if (_inputField.text) 
    {
        // 发送消息时，给声音提示
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"ms_send" ofType:@"caf"];
        if (audioPath) 
        {
            AVAudioPlayer *auPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:
                                       [NSURL fileURLWithPath:audioPath] error:nil] autorelease];
            //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
            [auPlayer setDelegate:self];
            [auPlayer play];
            
            NSString *soundOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"soundAlert"];
            [Tooles loudSpeaker:[soundOn isEqual:@"1"]];
        }
        
        UIView *chatView = [Tooles bubbleWithText:[NSString stringWithFormat:@"%@", _inputField.text] 
                                         byMySelf:YES 
                                       picAddress:[NSString stringWithFormat:@"%@%@", ICON_ADDRESS, [User currentUser].person.pic160] 
                                        timeStamp:[Tooles systemTime]];
        
        [_chatContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:chatView, @"view", nil]];
        
        position++;
        [self update];
        [self performSelector:@selector(updateMSGSendState:) withObject:chatView afterDelay:10.0];
    }
    
    SBJsonWriter *jsonWriter = [[[SBJsonWriter alloc] init] autorelease];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    
    [([DIManager _app_delegate]).webSocket sendText:jsonString];
}

- (IBAction)turnToRecorderBar
{
    [Tooles pushView:_recorderView fromView:_keyboardView onView:_bottomBar];
}

- (IBAction)turnToBottomBar
{
    [Tooles revealView:_keyboardView fromView:_recorderView onView:_bottomBar];
}

- (IBAction)screenTouched
{
    [_inputField resignFirstResponder];
}

void animate(UIView *view, CGRect frame) 
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    view.frame = frame;
    
    [UIView commitAnimations];
}

#pragma mark - TextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - TableView dataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [_chatContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *chatInfo = [_chatContents objectAtIndex:[indexPath row]];
	for(UIView *subview in [cell.contentView subviews]) {
		[subview removeFromSuperview];
    }
	[cell.contentView addSubview:[chatInfo objectForKey:@"view"]];
    
    return cell;
}

#pragma mark - TableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UIView *chatView = [[_chatContents objectAtIndex:[indexPath row]] objectForKey:@"view"];
	return chatView.frame.size.height + 10.0f;
}

#pragma mark -  
#pragma mark Responding to keyboard events  

- (void)keyboardWillShow:(NSNotification *)notification {  
    
    /*  
     Reduce the size of the text view so that it's not obscured by the keyboard.  
     Animate the resize so that it's in sync with the appearance of the keyboard.  
     */  
    
    NSDictionary *userInfo = [notification userInfo];  
    
    // Get the origin of the keyboard when it's displayed.  
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];  
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.  
    CGRect keyboardRect = [aValue CGRectValue];  
    
    // Get the duration of the animation.  
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];  
    NSTimeInterval animationDuration;  
    [animationDurationValue getValue:&animationDuration];  
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.  
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
    [_sendBtn setAlpha:1.0];
    [_voiceBtn setAlpha:0.0];
}  


- (void)keyboardWillHide:(NSNotification *)notification {  
    
    NSDictionary* userInfo = [notification userInfo];  
    
    /*  
     Restore the size of the text view (fill self's view).  
     Animate the resize so that it's in sync with the disappearance of the keyboard.  
     */  
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];  
    NSTimeInterval animationDuration;  
    [animationDurationValue getValue:&animationDuration];  
    
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
    [_sendBtn setAlpha:0.0];
    [_voiceBtn setAlpha:1.0];
}

@end
