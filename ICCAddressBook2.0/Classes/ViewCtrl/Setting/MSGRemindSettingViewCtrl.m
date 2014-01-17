//
//  RemindSettingViewCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MSGRemindSettingViewCtrl.h"

#import "Constants.h"

@interface MSGRemindSettingViewCtrl ()

@end

@implementation MSGRemindSettingViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"提醒设置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_tableView setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg3"]] autorelease]];
    
    NSString *soundOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"soundON"];
    [_soundSwitch setOn:[soundOn isEqual:@"1"] ? YES : NO];
    
    NSString *pushOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"pushON"];
    [_pushSwitch setOn:[pushOn isEqual:@"1"] ? YES : NO];
    
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
}

- (IBAction)switchValueChanged:(UISwitch *)_switch
{
    if (_pushSwitch == _switch) 
    {
        [[NSUserDefaults standardUserDefaults] setValue:_switch.on ? @"1" : nil forKey:@"pushON"];
    }
    else if (_soundSwitch == _switch) 
    {
        [[NSUserDefaults standardUserDefaults] setValue:_switch.on ? @"1" : nil forKey:@"soundON"];
    }
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1/*2*/;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    cell.textLabel.text  = [[Constants _setting_reminds] objectAtIndex:indexPath.section];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
	return section == 0 ? 0 : 88;
}

@end
