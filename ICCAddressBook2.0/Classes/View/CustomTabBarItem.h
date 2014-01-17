//
//  CustomTabBarItem.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarItem : UITabBarItem

@property (nonatomic, assign) UIImage *selectedImage;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)sltImage tag:(NSInteger)tag;

@end
