//
//  LoginViewCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewCtrl.h"

#import "User.h"

#import "Person.h"

#import "XJParser.h"

#import "AppDelegate.h"

#import "NearbyViewCtrl.h"

@interface LoginViewCtrl ()

@end

@implementation LoginViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    loginView.alpha = 0.0;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    emailField.text = username;
    passField .text = password;
    
    [self performSelector:@selector(showLoginBox) withObject:nil afterDelay:1.0];
}

- (void)showLoginBox
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showKeyboard)];
    
    loginView.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (void)showKeyboard
{
    [emailField becomeFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    loginView.frame = CGRectMake(loginView.frame.origin.x, loginView.frame.origin.y - 80, 
                                 loginView.frame.size.width, loginView.frame.size.height);
    
    [UIView commitAnimations];
}

//------------------------------------------------------------------------------------------------------------
// start: 登录
//------------------------------------------------------------------------------------------------------------
- (IBAction)login
{
    if ([emailField.text isEqual:@""] || emailField.text.length <= 0) 
    {
        [Tooles MsgBox:@"请输入邮箱帐号"];
        return;
    }
    
    if ([passField.text isEqual:@""] || passField.text.length <= 0) 
    {
        [Tooles MsgBox:@"请输入邮箱密码"]; 
        return;
    }
    
    waiter.callback = @selector(loginResult:);
    [waiter login:emailField.text :passField.text];
    
    // 设置超时处理
    [self performSelector:@selector(handleTimeout) withObject:nil afterDelay:60.0];
    
    // 显示登录提示框
    [SVProgressHUD showWithStatus:@"正在登录..."];
    
    // 隐藏键盘
    //[emailField resignFirstResponder];
    //[passField  resignFirstResponder];
}

- (void)loginResult:(id)result
{
    // 缓存当前登录用户的信息
    Person *person = [XJParser personWithObject:result];
    [[User currentUser] setPerson:person];
    
    // 登录结果
    int success = [[(NSDictionary *)result objectForKey:@"success"] intValue];
    
    if (success == 1) 
    {
        [SVProgressHUD showSuccessWithStatus:@"登录成功！"];
        
        // 保存登录帐号及密码
        [[NSUserDefaults standardUserDefaults] setValue:emailField.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setValue:passField.text  forKey:@"password"];
        
        // 通知父视图 登录成功
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    }
    
    else 
    {
        [SVProgressHUD showErrorWithStatus:[result objectForKey:@"msg"]];
    }
}

- (void)handleTimeout
{
    if ([SVProgressHUD isVisible]) 
    {
        [SVProgressHUD showErrorWithStatus:@"登录超时！"];
    }
}
//------------------------------------------------------------------------------------------------------------
// end: 登录
//------------------------------------------------------------------------------------------------------------





//------------------------------------------------------------------------------------------------------------
// start: 忘记密码
//------------------------------------------------------------------------------------------------------------
- (IBAction)forgetPassword
{
    if ([emailField.text isEqual:@""] || emailField.text.length <= 0) 
    {
        [Tooles MsgBox:@"请输入邮箱帐号"];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否发送密码至您填写的电子邮箱？" 
                                                   delegate:self cancelButtonTitle:@"是" 
                                          otherButtonTitles:@"否", nil];
    [alert show];
    [alert release];
}

- (void)forgetPasswordWithResult:(id)result
{
    int success = [[(NSDictionary *)result objectForKey:@"success"] intValue];
    
    if (success == 1) 
    {
        [SVProgressHUD showSuccessWithStatus:@"密码已发送至您的邮箱！"];
    }
    
    else 
    {
        [SVProgressHUD showErrorWithStatus:[result objectForKey:@"msg"]];
    }
}
//------------------------------------------------------------------------------------------------------------
// end: 忘记密码
//------------------------------------------------------------------------------------------------------------


#pragma makr - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            waiter.callback = @selector(forgetPasswordWithResult:);
            [waiter forgetPassword:emailField.text];
            
            [SVProgressHUD showWithStatus:@"正在发送..."];
        }
            break;
            
        default:
            break;
    }
}

@end
