//
//  CustomTabBarItem.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBarItem.h"

@implementation CustomTabBarItem

@synthesize selectedImage;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)sltImage tag:(NSInteger)tag
{
    if (self = [super initWithTitle:title image:image tag:tag]) 
    {
        self.selectedImage = sltImage;
    }
    
    return self;
}

@end
