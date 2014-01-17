//
//  NearbyViewCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NearbyViewCtrl.h"

#import "LoginViewCtrl.h"

#import "XJWaiter.h"

#import "User.h"

@interface NearbyViewCtrl ()

@end

@implementation NearbyViewCtrl

@synthesize listData = _listData;
@synthesize tableView = _tableView;
@synthesize flowView = _flowView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"通讯录";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_contacts.png"];
    }
    return self;
}

- (void)dealloc
{
    [_listData release];
    [_tableView release], _tableView = nil;
    [_flowView release], _flowView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	/*
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 38, 30)];
    [rightBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                        forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"button_grid.png"] forState:UIControlStateNormal];
    [rightBtn.imageView setFrame:CGRectMake(11, 7, 17, 17)];
    [rightBtn addTarget:self action:@selector(toggleListType) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBtn release];
    [rightBarButtonItem release];
    
    
    leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [leftBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                        forState:UIControlStateNormal];
    [leftBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [leftBtn addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [leftBtn release];
    [leftBarButtonItem release];
    */
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg3"]] autorelease]];
    
    /*
    self.flowView = [[[LLWaterFlowView alloc] initWithFrame:CGRectMake(0, 0, 320, 372)] autorelease];
	self.flowView.flowdelegate = nil;
	self.flowView.backgroundColor = [UIColor whiteColor];
	*/
    
    LoginViewCtrl *ctrl = [[[LoginViewCtrl alloc] initWithNibName:@"LoginViewCtrl" bundle:nil] autorelease];
    [self presentModalViewController:ctrl animated:NO];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFail) name:@"loginFail" object:nil];
    
    
    UISearchBar *_searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, -44, 320, 44)] autorelease];
    [_searchBar setBackgroundImage:[UIImage imageNamed:@"bg3.png"]];
    [_searchBar setPlaceholder:@"输入中文名或英文名"];
    [_searchBar setDelegate:self];
    [self.tableView addSubview:_searchBar];
    [self.tableView setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];
}

- (void)loginSuccessed
{
    // 关闭登录窗口
    [self dismissModalViewControllerAnimated:YES];
    
    // 登录成功后从服务器请求最新的数据
    [self performSelector:@selector(getUsers) withObject:nil afterDelay:1.25f];
}

- (void)loginFail
{
    // 登录失败，启用离线模式
    self.listData = [[DBManager defaultManager] dataFromeTable];
    
    if (self.listData.count > 0) 
    {
        self.flowView.flowdelegate = self;
        [self.flowView  reloadData];
        [self.tableView reloadData];
    }
}

- (void)getUsers
{
    waiter.callback = @selector(getUsersWithResult:);
    [waiter users];
    
    // 获取通讯录列表，显示提示框
    [SVProgressHUD showWithStatus:@"获取列表..."];
}

- (void)getUsersWithResult:(id)result
{
    int success = [[(NSDictionary *)result objectForKey:@"success"] intValue];
    
    if (success == 1) 
    {
        [SVProgressHUD dismiss];
        
        // 进行数据存储
        NSArray *persons = [result objectForKey:@"data"];
        if ([persons isKindOfClass:[NSArray class]]) 
        {
            // 清空数据库
            [[DBManager defaultManager] clear];
            
            // 一条一条插入数据
            for (int i = 0; i < [persons count]; i++) 
            {
                NSDictionary *dic = [persons objectAtIndex:i];
                Person *person = [Person new];
                
                person.personId     = [dic objectForKey:@"_id"];
                person.chineseName  = [dic objectForKey:@"truename"];
                person.englishName  = [dic objectForKey:@"name"];
                person.team         = [dic objectForKey:@"team"];
                person.position     = [dic objectForKey:@"position"];
                person.ext          = [dic objectForKey:@"phone"];
                person.phone        = [dic objectForKey:@"mobile"];
                person.email        = [dic objectForKey:@"email"];
                person.msn          = [dic objectForKey:@"msn"];
                person.telephone    = [dic objectForKey:@"homephone"];
                
                NSDictionary *meta  = [[dic objectForKey:@"icon"] objectForKey:@"metadata"];
                person.pic160       = [meta objectForKey:@"160"];
                person.pic320       = [meta objectForKey:@"320"];
                person.pic640       = [meta objectForKey:@"640"];
                
                [[DBManager defaultManager] insert:person];
                [person release];
            }
            
            // 从数据库读取数据
            self.listData = [[DBManager defaultManager] dataFromeTable];
            [User currentUser].persons = self.listData;
        }
        
        // 更新列表数据
        if (self.listData.count > 0) [self.tableView reloadData];
        
        // 加载通讯录数据成功后, 向服务器提交deviceToken
        [self performSelectorOnMainThread:@selector(submitDeviceToken) withObject:nil waitUntilDone:NO];
        
        // 加载通讯录数据成功后, 建立会话链接
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] openSocket];
    }
    
    else 
    {
        [SVProgressHUD showErrorWithStatus:[result objectForKey:@"msg"]];
        return;
    }
    
}

- (void)submitDeviceToken
{
    waiter.callback = @selector(submitDeviceTokenWithResult:);
    [waiter submitDeviceToken:[[User currentUser] deviceToken]];
}

- (void)submitDeviceTokenWithResult:(id)result
{
    NSLog(@">>>>---------------------------------------> %@", result);
}

- (void)recoverLocalData 
{
    self.listData = [[DBManager defaultManager] dataFromeTable];
    
    if (self.listData.count > 0) 
    {
        self.flowView.flowdelegate = self;
        [self.tableView reloadData];
    }
}

- (void)filter
{
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"筛选" 
                                                        delegate:self 
                                               cancelButtonTitle:@"取消" 
                                          destructiveButtonTitle:nil 
                                               otherButtonTitles:@"全部", @"按部门划分", nil] 
                            autorelease];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)flipView:(UIView*)v1 withView:(UIView*)v2 fromLeft:(BOOL)fromLeft
{
    [v1 removeFromSuperview];
    [self.view addSubview:v2];
    
    [UIView beginAnimations:nil context:nil];
    if(fromLeft){
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    }
    else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    }
    [UIView setAnimationDuration:0.75];
    [UIView commitAnimations];
}

- (void)toggleListType
{
    if (_flowView.superview) 
    {
        // 瀑布流列表停止接收事件
        self.flowView.flowdelegate = nil;
        
        // 切换到普通列表
        [self flipView:self.flowView withView:self.tableView fromLeft:YES];
        
        // 更新切换按钮图片
        [rightBtn setImage:[UIImage imageNamed:@"button_grid.png"] forState:UIControlStateNormal];
    } 
    
    else 
    {
        // 瀑布墙列表刷新
        self.flowView.flowdelegate = self;
        
        // 切换到瀑布墙
        [self flipView:self.tableView withView:self.flowView fromLeft:NO];
        
        // 更新切换按钮图片
        [rightBtn setImage:[UIImage imageNamed:@"button_list.png"] forState:UIControlStateNormal];
    }
}

- (void)chatWithPerson:(Person *)person
{
    ChatViewCtrl *ctrl;
    
    if (![DIManager _if_dialogue_exist:person.personId]) 
    {
        ctrl = [[[ChatViewCtrl alloc] initWithPerson:person] autorelease];
        ctrl.hidesBottomBarWhenPushed = YES;
        
        [[DIManager _opening_dialogues] addObject:ctrl];
    }
    
    else 
    {
        ctrl = [DIManager _dialogue_with_person:person];
    }
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - TableView dataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil] lastObject];
    }
    
    Person *person = (Person *)[self.listData objectAtIndex:indexPath.row];
    
    cell.backgroundView     = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listbg.png"]] autorelease];
    cell.titleLabel.text    = person.chineseName;
    cell.distanceLabel.text = person.englishName;
    cell.contentLabel.text  = person.email;
    cell.dateLabel.text     = @"";
    
    NSString *imageAddress = [NSString stringWithFormat:@"%@%@", ICON_ADDRESS, person.pic160];
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageAddress] 
                   placeholderImage:[UIImage imageNamed:@"icon_default.png"]];
    
    return cell;
}

#pragma mark - TableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 88.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self chatWithPerson:[self.listData objectAtIndex:indexPath.row]];
}

#pragma mark - LLWaterFlowView delegate methods

- (NSUInteger)numberOfColumnsInFlowView:(LLWaterFlowView *)flowView
{
	return 4;
}

- (NSInteger)flowView:(LLWaterFlowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    return floor(self.listData.count/4);
}

- (LLWaterFlowCell *)flowView:(LLWaterFlowView *)flowView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellTag_Airport_weather";
	LLWaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[LLWaterFlowCell alloc] initWithIdentifier:CellIdentifier] autorelease];
		
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:iv];
		iv.layer.borderColor = [[UIColor whiteColor] CGColor];
		iv.layer.borderWidth = 4;
		[iv release];
		iv.tag = 101;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = Black;
		[cell addSubview:label];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont boldSystemFontOfSize:11];
		label.textColor = [UIColor whiteColor];
		[label release];
		label.tag = 102;
	}
	
	else 
	{
		//NSLog(@"此条是从重用列表中获取的。。。。。");
	}
    
	Person *person = (Person *)[self.listData objectAtIndex:indexPath.row * 4 + indexPath.section];
	
	UIImageView *iv  = (UIImageView *)[cell viewWithTag:101];
	iv.frame = CGRectMake(0, 0, 84, 84);
	iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_default.png"]];
	
	UILabel *label = (UILabel *)[cell viewWithTag:102];
	label.frame = CGRectMake(4, 60, 76, 20);
	label.text = person.chineseName;
	
	return cell;
}

- (CGFloat)flowView:(LLWaterFlowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

- (void)flowView:(LLWaterFlowView *)flowView didSelectAtIndexPath:(NSIndexPath *)indexPath
{
    [self chatWithPerson:[self.listData objectAtIndex:indexPath.row * 4 + indexPath.section]];
}

#pragma mark - 
#pragma mark Search bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar 
{
    
    for (UIView *view in [searchBar subviews]) { 
        
        if ([view conformsToProtocol:@protocol(UITextInputTraits)]) {    
            @try {
                // set style of keyboard
                //[(UITextField *)view setKeyboardAppearance:UIKeyboardAppearanceAlert];
                
                // always force return key to be enabled
                [(UITextField *)view setEnablesReturnKeyAutomatically:NO];
            }
            @catch (NSException * e) {        
                // ignore exception
            }
        }
    }
    
    
    UITextField *searchField = [[searchBar subviews] lastObject];
    [searchField setReturnKeyType:UIReturnKeyDone];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText 
{
    
    if (searchBar.text.length == 0) 
    {
        [self recoverLocalData];
        return;
    }
    
    [self.listData removeAllObjects];
    
    for (Person *person in [[DBManager defaultManager] dataFromeTable]) {
        
        if ([person.chineseName rangeOfString:searchText].length > 0 
            || [person.englishName rangeOfString:searchText].length > 0) {
            
            [self.listData addObject:person];
        }
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar 
{
    
    [searchBar resignFirstResponder];
    
}

@end
