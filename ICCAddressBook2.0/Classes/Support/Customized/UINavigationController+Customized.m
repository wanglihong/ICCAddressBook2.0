//
//  UINavigationController+Customized.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UINavigationController+Customized.h"

@implementation UINavigationController (Customized)

- (void)viewDidLoad
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) 
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:0];
    }
    
    [self.navigationBar setTintColor:SteelBlue3];
}

@end
