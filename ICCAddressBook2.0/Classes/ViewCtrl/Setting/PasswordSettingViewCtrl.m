//
//  PasswordSettingViewCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PasswordSettingViewCtrl.h"

#import "Constants.h"

@interface PasswordSettingViewCtrl ()

@end

@implementation PasswordSettingViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"修改密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [_tableView setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg3"]] autorelease]];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [leftBtn setBackgroundImage:[[UIImage imageNamed:@"nav_back_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                       forState:UIControlStateNormal];
    [leftBtn setTitle:@" 系统设置" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [leftBtn release];
    [leftBarButtonItem release];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightBtn setBackgroundImage:[[UIImage imageNamed:@"nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14] 
                        forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBtn release];
    [rightBarButtonItem release];
    
    [_old_pwd_field becomeFirstResponder];
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)down
{
    if        ([_old_pwd_field.text isEqual:@""] || _old_pwd_field.text.length <= 0) {
        [Tooles MsgBox:@"请输入旧密码"];
        return;
    } else if ([_new_pwd_field.text isEqual:@""] || _new_pwd_field.text.length <= 0) {
        [Tooles MsgBox:@"请输入新密码"]; 
        return;
    } else if ([_cfm_pwd_field.text isEqual:@""] || _cfm_pwd_field.text.length <= 0) {
        [Tooles MsgBox:@"请确认新密码"]; 
        return;
    } else if (![_cfm_pwd_field.text isEqual:_new_pwd_field.text]) {
        [Tooles MsgBox:@"新密码不一致"]; 
        return;
    } else {
        
    }
    
    
    waiter.callback = @selector(modifyPasswordWithResult:);
    [waiter modifyPassword:_old_pwd_field.text newPassword:_new_pwd_field.text];
    
    [SVProgressHUD showWithStatus:@"正在提交..."];
}

- (void)modifyPasswordWithResult:(id)result
{
    NSLog(@"%@", result);
    
    int success = [[(NSDictionary *)result objectForKey:@"success"] intValue];
    
    if (success == 1) 
    {
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功！"];
    }
    
    else 
    {
        [SVProgressHUD showErrorWithStatus:[result objectForKey:@"msg"]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.textLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    cell.textLabel.text  = [[Constants _setting_password] objectAtIndex:indexPath.row];
    
    return cell;
}

@end
