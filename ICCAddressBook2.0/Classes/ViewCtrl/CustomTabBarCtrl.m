//
//  CustomTabBarCtrl.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBarCtrl.h"

#import "UIBadgeView.h"

#import "CustomTabBarItem.h"

@interface CustomTabBarCtrl ()

@end

@implementation CustomTabBarCtrl

@synthesize currentSelectedIndex;
@synthesize buttons;
@synthesize customTabBarView;

static BOOL FIRSTTIME = YES;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (FIRSTTIME) 
    {
        [self hideRealTabBar];
        FIRSTTIME = NO;
    }
}

- (void)hideRealTabBar
{
	for(UIView *view in self.view.subviews)
    {
		if([view isKindOfClass:[UITabBar class]])
        {
			//view.hidden = YES;
            [view removeFromSuperview];
			break;
		}
	}
    
    [self showCustomTabBar];
}

- (void)showCustomTabBar
{
	//获取tabbar的frame
	backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
	customTabBarView = [[UIView alloc] initWithFrame:self.tabBar.frame];
    
	//设置tabbar背景
	//backgroundImageView.image = [UIImage imageNamed:@"banner.png"];
	[customTabBarView addSubview:backgroundImageView];
	[backgroundImageView release];
	customTabBarView.backgroundColor = [UIColor blackColor];
	
	
	//创建按钮
	int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
	double _width = 320 / viewCount;
	double _height = self.tabBar.frame.size.height;
	for (int i = 0; i < viewCount; i++) 
    {
		UIViewController *v = [self.viewControllers objectAtIndex:i];
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(i*_width, 0, _width, _height);
		[btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];
		btn.tag = i;
		[btn setImage:v.tabBarItem.image forState:UIControlStateNormal];
        
		[self.buttons addObject:btn];
        
		//添加Badge
		if (v.tabBarItem.badgeValue) {
			UIBadgeView *badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(_width/2, 0, 30, 20)];
			badgeView.badgeString = v.tabBarItem.badgeValue;
			badgeView.badgeColor = [UIColor orangeColor];
			[btn addSubview:badgeView];
			[badgeView release];
		}
        
		[customTabBarView addSubview:btn];
	}
    
	[self.view addSubview:customTabBarView];
	[customTabBarView addSubview:slideBg];
	[customTabBarView release];
    self.currentSelectedIndex = [self.buttons count];
    [self selectedTab:[self.buttons objectAtIndex:0]];
	[self performSelector:@selector(slideTabBg:) withObject:[self.buttons objectAtIndex:0]];
}

- (void)selectedTab:(UIButton *)button
{
    if (self.currentSelectedIndex == button.tag) {
		[[self.viewControllers objectAtIndex:button.tag] popToRootViewControllerAnimated:YES];
		return;
	}
	self.currentSelectedIndex = button.tag;
	self.selectedIndex = self.currentSelectedIndex;
	[self performSelector:@selector(slideTabBg:) withObject:button];
    
    for (UIButton *btn in self.buttons) 
    {
        UIViewController *v = [self.viewControllers objectAtIndex:btn.tag];
        
        if (btn != button) 
        {
            [btn setImage:v.tabBarItem.image forState:UIControlStateNormal];
        }
        else 
        {
            [btn setImage:((CustomTabBarItem *)v.tabBarItem).selectedImage forState:UIControlStateNormal];
        }
    }
}

//切换滑块位置
- (void)slideTabBg:(UIButton *)btn
{
	[UIView beginAnimations:nil context:nil];  
	[UIView setAnimationDuration:0.20];  
	[UIView setAnimationDelegate:self];
    
	slideBg.frame = btn.frame;
    
	[UIView commitAnimations];
}

- (void) dealloc
{
	[customTabBarView release];
	[slideBg release];
	[buttons release];
	[backgroundImageView release];
    
	[super dealloc];
}

@end
