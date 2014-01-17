//
//  BaseViewCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XJWaiter.h"

#import "Tooles.h"

#import "SVProgressHUD.h"

@interface BaseViewCtrl : UIViewController <XJWaiterDelegate>
{
    XJWaiter *waiter;
}

@property (nonatomic, retain) XJWaiter *waiter;

@end
