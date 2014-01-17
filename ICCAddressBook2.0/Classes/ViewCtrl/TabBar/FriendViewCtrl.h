//
//  HomeCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListViewCtrl.h"

@interface FriendViewCtrl : ListViewCtrl <UIActionSheetDelegate>
{
    UIButton *followBtn, *fansBtn;
}

@end
