//
//  BaseViewCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface BaseViewCtrl ()

@end

@implementation BaseViewCtrl

@synthesize waiter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    waiter.delegate = nil;
    [waiter release], waiter = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (waiter == nil) 
    {
        waiter = [[XJWaiter alloc] init];
        waiter.delegate = self;
    }
}

@end
