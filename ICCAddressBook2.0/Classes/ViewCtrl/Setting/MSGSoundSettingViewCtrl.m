//
//  SetGetMsgSoundViewCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MSGSoundSettingViewCtrl.h"

#import "Constants.h"

@interface MSGSoundSettingViewCtrl ()

@end

@implementation MSGSoundSettingViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"静音设置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // 设置界面背景
    [_tableView setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg3"]] autorelease]];
    
    // 安装时默认设置静音时间为 22:00~8:00
    NSString *_time_start_value = [[_time_start_label.text componentsSeparatedByString:@":"] objectAtIndex:0];
    NSString *_time_end_value = [[_time_end_label.text componentsSeparatedByString:@":"] objectAtIndex:0];
    [_time_picker selectRow:[_time_start_value intValue] inComponent:0 animated:NO];
    [_time_picker selectRow:[_time_end_value intValue] - 1 inComponent:1 animated:NO];
    
    // 如果已设置静音时间，则默认显示设置中的静音时间段
    NSString *alert_s = [[NSUserDefaults standardUserDefaults] objectForKey:@"alert_s"];
    NSString *alert_e = [[NSUserDefaults standardUserDefaults] objectForKey:@"alert_e"];
    if (alert_s && alert_e) 
    {
        _time_start_label.text = [NSString stringWithFormat:@"%@%@:00", [alert_s intValue] < 10 ? @"0" : @"", alert_s];
        _time_end_label.text = [NSString stringWithFormat:@"%@%@:00", [alert_e intValue] < 10 ? @"0" : @"", alert_e];
        [_time_picker selectRow:[alert_s intValue] inComponent:0 animated:NO];
        [_time_picker selectRow:[alert_e intValue] - 1 inComponent:1 animated:NO];
    }
    
    // 静音开启状态(on or off)
    NSString *alertOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"alertON"];
    [_soundSwitch setOn:[alertOn isEqual:@"1"] ? YES : NO];
    [self switchValueChanged:_soundSwitch];
    
    // 导航栏右菜单功能键
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

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)switchValueChanged:(UISwitch *)_switch
{
    switch (_switch.on) 
    {
        case YES:
        {
            [_time_start_label setHidden:NO];
            [_time_to_label setHidden:NO];
            [_time_end_label setHidden:NO];
            [_time_picker setHidden:NO];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"alertON"];
        }
            break;
            
        case NO:
        {
            [_time_start_label setHidden:YES];
            [_time_to_label setHidden:YES];
            [_time_end_label setHidden:YES];
            [_time_picker setHidden:YES];
            
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"alertON"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - TableView dataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    cell.textLabel.text  = @"静音设置";
    
    return cell;
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 24;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *title;
    
	switch (component) {
        case 0:
            title = [NSString stringWithFormat:@"%@%d:00", row < 10 ? @"0" : @"", row];
            break;
            
        case 1:
            title = [NSString stringWithFormat:@"%@%d:00", row <  9 ? @"0" : @"", row + 1];
            break;
            
        default:
            break;
    }
	
	return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            _time_start_label.text = [NSString stringWithFormat:@"%d:00", row];
        }
            break;
            
        case 1:
        {
            _time_end_label.text   = [NSString stringWithFormat:@"%d:00", row + 1];
        }
            break;
            
        default:
            break;
    }
    
    NSString *_time_start_value = [[_time_start_label.text componentsSeparatedByString:@":"] objectAtIndex:0];
    NSString *_time_end_value = [[_time_end_label.text componentsSeparatedByString:@":"] objectAtIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setValue:_time_start_value forKey:@"alert_s"];
    [[NSUserDefaults standardUserDefaults] setValue:_time_end_value forKey:@"alert_e"];
}

@end
