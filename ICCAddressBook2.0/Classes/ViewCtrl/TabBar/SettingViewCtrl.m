//
//  SettingViewCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewCtrl.h"

#import "MSGRemindSettingViewCtrl.h"

#import "MSGSoundSettingViewCtrl.h"

#import "PersonInfoSettingViewCtrl.h"

#import "PasswordSettingViewCtrl.h"

#import "Constants.h"

#import "User.h"

typedef enum {
    message, 
    accounts, 
    logout
} sectionOfSetting;

@interface SettingViewCtrl ()

@end

@implementation SettingViewCtrl

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"系统设置";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_setting.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
}

- (void)logout
{
    waiter.callback = @selector(logout:);
    [waiter logout];
    
    [SVProgressHUD showWithStatus:@"正在退出..."];
}

- (void)logout:(id)result
{
    int success = [[(NSDictionary *)result objectForKey:@"success"] intValue];
    
    if (success == 1) 
    {
        [SVProgressHUD dismiss];
        exit(0);
    }
    
    else 
    {
        [SVProgressHUD showErrorWithStatus:[result objectForKey:@"msg"]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[Constants _setting_groups] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[Constants _setting_groups] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSArray *group = [[Constants _setting_groups] objectAtIndex:indexPath.section];
    
    cell.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    cell.textLabel.text  = [group objectAtIndex:indexPath.row];
    
    if (indexPath.section == logout) 
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *logoutBtn = (UIButton *)[cell viewWithTag:7];
        if (!logoutBtn) 
        {
            logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [logoutBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14]  
                                 forState:UIControlStateNormal];
            [logoutBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
            [logoutBtn setFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height + 1)];
            [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:logoutBtn];
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor darkGrayColor];
	label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
	label.text = [[Constants _setting_group_titles] objectAtIndex:section];
    
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
    
    
    switch (indexPath.section) 
    {
        case message:
        {
            if (indexPath.row == 0) 
            {
                MSGRemindSettingViewCtrl *ctrl = [[[MSGRemindSettingViewCtrl alloc] initWithNibName:@"RemindSetting" bundle:nil] autorelease];
                ctrl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ctrl animated:YES];
            }
            else if (indexPath.row == 1) 
            {
                MSGSoundSettingViewCtrl *ctrl = [[[MSGSoundSettingViewCtrl alloc] initWithNibName:@"SoundsSetting" bundle:nil] autorelease];
                ctrl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ctrl animated:YES];
            }
        }
            break;
            
        case accounts:
        {
            if (indexPath.row == 0) 
            {
                PersonInfoSettingViewCtrl *ctrl = [[[PersonInfoSettingViewCtrl alloc] initWithNibName:@"PersonInfoSetting" bundle:nil] autorelease];
                ctrl.person = [User currentUser].person;
                ctrl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ctrl animated:YES];
            }
            else if (indexPath.row == 1)
            {
                PasswordSettingViewCtrl *ctrl = [[[PasswordSettingViewCtrl alloc] initWithNibName:@"PasswordSetting" bundle:nil] autorelease];
                ctrl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ctrl animated:YES];
            }
        }
            break;
            
        default:
        {
            
        }
            break;
    }
}

@end
