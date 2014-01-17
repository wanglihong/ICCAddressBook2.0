//
//  HomeCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FriendViewCtrl.h"

#import "ChatViewCtrl.h"

#import "AddFriendTypeListViewCtrl.h"

#import "ListCell.h"

#import "Person.h"

#import "User.h"

@interface FriendViewCtrl ()

@end

@implementation FriendViewCtrl

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"收藏";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_space.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    followBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 88, 30)];
    [followBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_left_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                         forState:UIControlStateNormal];
    [followBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_left_bg2.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                         forState:UIControlStateSelected];
    [followBtn setTitle:@"关注(1)" forState:UIControlStateNormal];
    [followBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [followBtn addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    fansBtn = [[UIButton alloc] initWithFrame:CGRectMake(88, 0, 88, 30)];
    [fansBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_right_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                       forState:UIControlStateNormal];
    [fansBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_right_bg2.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                       forState:UIControlStateSelected];
    [fansBtn setTitle:@"粉丝(1)" forState:UIControlStateNormal];
    [fansBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [fansBtn addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIImageView *btnLine = [[UIImageView alloc] initWithFrame:CGRectMake(88, 0, 1, 30)];
    [btnLine setImage:[UIImage imageNamed:@"nav_btn_line.png"]];
    
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 176, 30)];
    [titleView addSubview:followBtn], [followBtn release];
    [titleView addSubview:fansBtn], [fansBtn release];
    [titleView addSubview:btnLine], [btnLine release];
    
    
    
    self.navigationItem.titleView = titleView;
    [titleView release];
    [followBtn setSelected:YES];
    */
    
    
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [leftBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                       forState:UIControlStateNormal];
    [leftBtn setTitle:@"排序" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [leftBtn addTarget:self action:@selector(sort) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.rightBarButtonItem = leftBarButtonItem;
    [leftBtn release];
    [leftBarButtonItem release];
    
    
    /*
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 30)];
    [rightBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                        forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
    [rightBtn.imageView setFrame:CGRectMake(0, 0, 16, 16)];
    [rightBtn addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBtn release];
    [rightBarButtonItem release];
    */
    
    
    /*
    Person *person = [[[Person alloc] init] autorelease];
    person.chineseName = @"客服001";
    person.englishName = @"001";
    person.email = @"396341338@qq.com";
    person.msn = @"avril";
    person.ext = @"110";
    person.phone = @"119";
    person.position = @"Eng";
    person.team = @"ICC";
    person.telephone = @"220";
    [self.listData addObject:person];*/
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 从数据库中列出好友
    [self.listData removeAllObjects];
    for (NSString *personId in [User currentUser].person.friends)
    {
        [self.listData addObject:[[DBManager defaultManager] select:personId]];
    }
    
    // 更新好友列表
    [self.tableView reloadData];
}

- (void)segmentedControlValueChanged:(UIButton *)btn 
{
    followBtn.selected = !followBtn.selected;
    fansBtn.selected = !fansBtn.selected;
}

- (void)sort
{
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"更改排序方式" 
                                                        delegate:self 
                                               cancelButtonTitle:@"取消" 
                                          destructiveButtonTitle:nil 
                                               otherButtonTitles:@"按英文名", @"按添加顺序", nil] 
                            autorelease];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)addFriend
{
    AddFriendTypeListViewCtrl *ctrl = [[AddFriendTypeListViewCtrl alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if (buttonIndex == 0) 
    {
        // 列出所有人的英文名
		NSMutableArray *names = [NSMutableArray arrayWithCapacity:self.listData.count];
        for (Person *person in self.listData) 
        {
            [names addObject:person.englishName];
        }
        
        // 对所有英文名 按升序排列
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        NSMutableArray *sortedNames = (NSMutableArray *)[names sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd, nil]];
        
        // 按英文名排列的顺序重新排列人物列表
        NSMutableArray *sortedPersons = [NSMutableArray arrayWithCapacity:self.listData.count];
        for (NSString *name in sortedNames) 
        {
            for (Person *person in self.listData) 
            {
                if ([person.englishName isEqual:name]) 
                {
                    [sortedPersons addObject:person];
                    continue;
                }
            }
        }
        
        // 更新列表
        self.listData = sortedPersons;
        [self.tableView reloadData];
	}
    
    else if (buttonIndex == 1)
    {
        // 从数据库中列出好友
        [self.listData removeAllObjects];
        for (NSString *personId in [User currentUser].person.friends)
        {
            [self.listData addObject:[[DBManager defaultManager] select:personId]];
        }
        
        // 更新好友列表
        [self.tableView reloadData];
    }
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
    
    Person *person = (Person *)[self.listData objectAtIndex:indexPath.row];
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

@end
