//
//  AppDelegate.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WSWebSocket.h"

#import "XJWaiter.h"

#import "NetWorkManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate, XJWaiterDelegate, NetWorkManagerDelegate>
{
    UIBackgroundTaskIdentifier	bgTask;
}

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) UITabBarController *tabBarController;

@property (retain, nonatomic) NSMutableArray *dialogues;

@property (retain, nonatomic) WSWebSocket *webSocket;

@property (retain, nonatomic) XJWaiter *waiter;

- (void)openSocket;

@end
