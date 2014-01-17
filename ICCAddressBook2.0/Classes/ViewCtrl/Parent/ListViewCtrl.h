//
//  ListCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tooles.h"

#import "Person.h"

#import "ListCell.h"

#import "ChatViewCtrl.h"

#import "AppDelegate.h"

#import "Constants.h"

#import "DIManager.h"

#import "DBManager.h"

#import "DetailViewCtrl.h"

#import "XJWaiter.h"

#import "SVProgressHUD.h"

@interface ListViewCtrl : UITableViewController <UIActionSheetDelegate, XJWaiterDelegate>
{
    NSMutableArray *listData;
    XJWaiter *waiter;
}

@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) XJWaiter *waiter;

@end
