//
//  DetailViewCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailViewCtrl.h"

#import "ChatViewCtrl.h"

#import "DIManager.h"

#import "Constants.h"

#import "Tooles.h"

#import "User.h"

@interface DetailViewCtrl ()

@end

@implementation DetailViewCtrl

@synthesize person = _person;
@synthesize groups = _groups;
@synthesize values = _values;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [_person release], _person = nil;
    [_groups release], _groups = nil;
    [_values release], _values = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.person.chineseName;
    
    self.groups= [NSArray arrayWithObjects:
                  [Constants _person_information_titles],
                  [Constants _contact_information_titles], 
                  [Constants _company_information_titles], 
                  nil];
    
    self.values= [NSArray arrayWithObjects:
                  _person.chineseName ? _person.chineseName : @"", 
                  _person.englishName ? _person.englishName : @"", 
                  _person.phone ? _person.phone : @"", 
                  _person.telephone ? _person.telephone : @"",
                  _person.email ? _person.email : @"", 
                  _person.msn ? _person.msn : @"", 
                  _person.position ? _person.position : @"", 
                  _person.team ? _person.team : @"", 
                  _person.ext ? _person.ext : @"", 
                  nil];
    
    leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [leftBtn setBackgroundImage:[[UIImage imageNamed:@"nav_back_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                       forState:UIControlStateNormal];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [leftBtn release];
    [leftBarButtonItem release];
    /*
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [rightBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                        forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [self updateRightBarButtonItem];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBtn release];
    [rightBarButtonItem release];*/
    [self updateRightBarButtonItem];
    

#define top_field_height 480
    
    _topImageField = [[[UIView alloc] initWithFrame:CGRectMake(0, -top_field_height, 320, top_field_height)] autorelease];
    _topImageField.backgroundColor = [UIColor grayColor];
    [_tableView addSubview:_topImageField];
    [_tableView setContentInset:UIEdgeInsetsMake(top_field_height, 0, 0, 0)];
    [_tableView setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg3"]] autorelease]];
    
#define horizontal_padding 4
#define vertical_padding 8
#define img_width 75
#define img_nums 1
    
    float lineHeight = vertical_padding + img_width;
    float startHeight = top_field_height - lineHeight * ceil((img_nums > 8 ? 8 : img_nums)/4.0) - (img_nums > 0 ? vertical_padding : 0);
    
    for (int i = 0; i < img_nums; i++) 
    {
        if (i >= 8) break;
        /*
        UIImage *img = [Tooles createRoundedRectImage:[UIImage imageNamed:@"icon_default.png"] 
                                                 size:CGSizeMake(img_width, img_width)];
        UIImageView *iv = [[[UIImageView alloc] initWithImage:img] autorelease];
        
        iv.frame = CGRectMake(horizontal_padding + (horizontal_padding + img_width) * (i%4), 
                              startHeight + lineHeight * floor(i/4.0) + vertical_padding, img_width, img_width);
        [_topImageField addSubview:iv];*/
        NSString *imageAddress = [NSString stringWithFormat:@"%@%@", ICON_ADDRESS, self.person.pic160];
        UIButton *b = [UIButton  buttonWithType:UIButtonTypeCustom];
        [b setTag:100];
        if (self.person.pic160.length > 0) 
        {
            [b setImage:[Tooles createRoundedRectImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageAddress]]]
                                                  size:CGSizeMake(img_width, img_width)] 
               forState:UIControlStateNormal];
        }
        else 
        {
            [b setImage:[Tooles createRoundedRectImage:[UIImage imageNamed:@"icon_default.png"] 
                                                  size:CGSizeMake(img_width, img_width)] 
               forState:UIControlStateNormal];
        }
        b.frame = CGRectMake(horizontal_padding + (horizontal_padding + img_width) * (i%4), 
                              startHeight + lineHeight * floor(i/4.0) + vertical_padding, img_width, img_width);
        [_topImageField addSubview:b];
    }
    
    [_tableView setContentInset:UIEdgeInsetsMake(top_field_height - startHeight, 0, 0, 0)];
}

- (void)updateRightBarButtonItem
{
    if ([[User currentUser].person.friends containsObject:self.person.personId]) 
    {
        [rightBtn setTitle:@"     取消收藏" forState:UIControlStateNormal];
        [rightBtn removeTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(delFriend) forControlEvents:UIControlEventTouchUpInside];
    } 
    
    else 
    {
        [rightBtn setTitle:@"     加入收藏" forState:UIControlStateNormal];
        [rightBtn removeTarget:self action:@selector(delFriend) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addFriend
{
    // 添加好友
    waiter.callback = @selector(addFriendSuccessWithResult:);
    [waiter addFriend:self.person.personId];
    
    [SVProgressHUD showWithStatus:@"正在添加..."];
}

- (void)delFriend
{
    // 添加好友
    waiter.callback = @selector(delFriendSuccessWithResult:);
    [waiter delFriend:self.person.personId];
    
    [SVProgressHUD showWithStatus:@"正在取消..."];
}

- (void)addFriendSuccessWithResult:(id)result
{
    NSLog(@"%@", result);
    
    int success = [[(NSDictionary *)result objectForKey:@"success"] intValue];
    
    if (success == 1) 
    {
        [SVProgressHUD showSuccessWithStatus:@"添加成功！"];
        
        // 在当前好友列表中添加此好友id
        [[User currentUser].person.friends addObject:self.person.personId];
        
        // 更新列表
        [_tableView reloadData];
        
        // 更新按钮状态
        [self updateRightBarButtonItem];
    }
    
    else 
    {
        [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"msg"]];
    }
}

- (void)delFriendSuccessWithResult:(id)result
{
    NSLog(@"%@", result);
    
    int success = [[(NSDictionary *)result objectForKey:@"success"] intValue];
    
    if (success == 1) 
    {
        [SVProgressHUD showSuccessWithStatus:@"取消成功！"];
        
        // 在当前好友列表中删除此好友id
        [[User currentUser].person.friends removeObject:self.person.personId];
        
        // 更新列表
        [_tableView reloadData];
        
        // 更新按钮状态
        [self updateRightBarButtonItem];
    }
    
    else 
    {
        [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"msg"]];
    }
}

#pragma mark - Bottombar action

- (IBAction)phoneCall
{
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"您确定要打他(她)电话吗？" 
                                                        delegate:self 
                                               cancelButtonTitle:@"等会儿再打" 
                                          destructiveButtonTitle:@"是的，现在就打" 
                                               otherButtonTitles:nil] 
                            autorelease];
    [sheet showInView:self.view];
}

- (IBAction)sendMessage
{
    if ([MFMessageComposeViewController canSendText]) 
    {
		MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.recipients = [NSArray arrayWithObject:self.person.phone];
		picker.messageComposeDelegate = self;
		picker.body = @"hello";
		
		[self presentModalViewController:picker animated:YES];
		[picker release];
		
	}
}

- (IBAction)goChat
{
    ChatViewCtrl *ctrl;
    
    if (![DIManager _if_dialogue_exist:self.person.personId]) 
    {
        ctrl = [[[ChatViewCtrl alloc] initWithPerson:self.person] autorelease];
        ctrl.hidesBottomBarWhenPushed = YES;
        
        [[DIManager _opening_dialogues] addObject:ctrl];
    }
    
    else 
    {
        ctrl = [DIManager _dialogue_with_person:self.person];
    }
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if (buttonIndex == 0) 
    {
		NSString *telString = [NSString stringWithFormat:@"tel://%@", self.person.phone];
        
        NSURL *telURL = [NSURL URLWithString:telString];
        
        [[UIApplication sharedApplication] openURL:telURL];
	}
}

#pragma mark MFMessageComposeViewController delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result 
{
    switch (result) 
    {
        case MessageComposeResultCancelled:
            if (DEBUG) NSLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
            if (DEBUG) NSLog(@"Result: Sent");
            break;
        case MessageComposeResultFailed:
            if (DEBUG) NSLog(@"Result: Failed");
            break;
        default:
            break;
    }
	[self dismissModalViewControllerAnimated:YES];	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.groups objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSArray *group = [self.groups objectAtIndex:indexPath.section];
    
    cell.textLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    cell.textLabel.text  = [group objectAtIndex:indexPath.row];
    
    UILabel *label       = (UILabel *)[cell viewWithTag:99];
    if (!label) 
    {
        label                = [[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 44)] autorelease];
        label.backgroundColor= [UIColor clearColor];
        label.textColor      = MidnightBlue;
        label.textAlignment  = UITextAlignmentRight;
        label.font           = [UIFont fontWithName:@"Helvetica" size:16.0];
        label.tag            = 99;
        [cell addSubview:label];
    }
    
    switch (indexPath.section) {
        case 0:
            label.text = [self.values objectAtIndex:indexPath.row];
            break;
            
        case 1:
            label.text = [self.values objectAtIndex:indexPath.row + 2];    //2:第一个section的row的数量
            break;
            
        case 2:
            label.text = [self.values objectAtIndex:indexPath.row + 2 + 4];//4:第二个section的row的数量
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor darkGrayColor];
	label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
	label.text = [[Constants _detail_group_titles] objectAtIndex:section];
    
    return label;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
	return 30.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
