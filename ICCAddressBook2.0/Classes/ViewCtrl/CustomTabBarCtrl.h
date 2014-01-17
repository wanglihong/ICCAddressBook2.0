//
//  CustomTabBarCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarCtrl : UITabBarController 
{
	NSMutableArray  *buttons;
	int             currentSelectedIndex;
	UIImageView     *slideBg;
	UIView          *customTabBarView;
	UIImageView     *backgroundImageView;
}

@property (nonatomic, assign) int currentSelectedIndex;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) UIView *customTabBarView;

- (void)hideRealTabBar;
- (void)showCustomTabBar;
- (void)selectedTab:(UIButton *)button;

@end
