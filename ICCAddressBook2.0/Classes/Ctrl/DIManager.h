//
//  DIManager.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"

#import "ChatViewCtrl.h"

@interface DIManager : NSObject

+ (AppDelegate *)_app_delegate;
+ (NSMutableArray *)_all_persons;
+ (NSMutableArray *)_opening_dialogues;
+ (ChatViewCtrl *)_dialogue_at_index:(int)index;
+ (ChatViewCtrl *)_dialogue_with_person:(Person *)person;
//+ (BOOL)_if_dialogue_exist:(Person *)person;
+ (BOOL)_if_dialogue_exist:(NSString *)personId;
+ (void)_add_dialogue_with_person:(Person *)person;

@end
