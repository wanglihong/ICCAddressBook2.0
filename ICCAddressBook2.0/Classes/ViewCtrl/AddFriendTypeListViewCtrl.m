//
//  AddFriendTypeListViewCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddFriendTypeListViewCtrl.h"

@interface AddFriendTypeListViewCtrl ()

@end

@implementation AddFriendTypeListViewCtrl

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"添加好友";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    
    UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_bigicon.png"]] autorelease];
    background.frame = CGRectMake(100, 30, 140, 121);
    [self.tableView.backgroundView addSubview:background];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(200, 0, 0, 0)];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView dataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"通过帐号";
            break;
            
        case 1:
            cell.textLabel.text = @"邀请TA";
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - TableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
