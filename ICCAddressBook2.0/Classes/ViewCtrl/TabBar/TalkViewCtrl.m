//
//  TalkViewCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TalkViewCtrl.h"

#import "ChatViewCtrl.h"

#import "ListCell.h"

#import "Person.h"

@interface TalkViewCtrl ()

@end

@implementation TalkViewCtrl

@synthesize dialogues = _dialogues;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"对话";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_sms.png"];
    }
    return self;
}

- (void)dealloc
{
    [_dialogues release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                        forState:UIControlStateNormal];
    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [rightBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBtn release];
    [rightBarButtonItem release];
    
    // 有消息来时，刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:@"update" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [super.tableView reloadData];
}

- (void)edit
{
    [super.tableView setEditing:!super.tableView.editing animated:YES];
    
    if(super.tableView.editing)
    {
        [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    else 
    {
        [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    } 
}

- (void)update
{
    [super.tableView reloadData];
}

#pragma mark - TableView dataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DIManager _opening_dialogues] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil] lastObject];
    }
    
    Person *person = ([DIManager _dialogue_at_index:indexPath.row]).person;
    
    cell.backgroundView     = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listbg.png"]] autorelease];
    cell.titleLabel.text    = person.chineseName;
    cell.distanceLabel.text = person.englishName;
    cell.contentLabel.text  = person.email;
    cell.dateLabel.text     = @"";
    
    [cell setBadgeValue:person.msgCount];
    
    NSString *imageAddress = [NSString stringWithFormat:@"%@%@", ICON_ADDRESS, person.pic160];
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageAddress] 
                   placeholderImage:[UIImage imageNamed:@"icon_default.png"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - TableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 88.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        [[DIManager _opening_dialogues] removeObjectAtIndex:indexPath.row];
        [super.tableView reloadData];
    }
}

#pragma mark - TableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChatViewCtrl *ctrl = [DIManager _dialogue_at_index:indexPath.row];
    ctrl.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

@end
