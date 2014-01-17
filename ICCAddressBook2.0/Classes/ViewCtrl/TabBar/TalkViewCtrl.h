//
//  TalkViewCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListViewCtrl.h"

@interface TalkViewCtrl : ListViewCtrl
{
    UIButton *rightBtn;
}

@property (nonatomic, retain) NSMutableArray *dialogues;

@end
