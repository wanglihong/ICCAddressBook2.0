//
//  ListCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListViewCtrl.h"

@interface ListViewCtrl ()

@end

@implementation ListViewCtrl

@synthesize listData;
@synthesize waiter;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.listData = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [listData release];
    [waiter release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg3"]] autorelease]];
    
    if (waiter == nil) 
    {
        waiter = [[XJWaiter alloc] init];
        waiter.delegate = self;
    }
}

@end
