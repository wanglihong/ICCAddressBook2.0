//
//  Constants.h
//  laiyifen
//
//  Created by Dennis Yang on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"

#import "ChatViewCtrl.h"

@interface Constants : NSObject

+ (Constants *)sharedConstants;

+ (NSArray *)_detail_group_titles;
+ (NSArray *)_person_information_titles;
+ (NSArray *)_contact_information_titles;
+ (NSArray *)_company_information_titles;

+ (NSArray *)_setting_group_titles;
+ (NSArray *)_service_type_titles;
+ (NSArray *)_message_type_titles;
+ (NSArray *)_account_type_titles;
+ (NSArray *)_suggest_type_titles;
+ (NSArray *)_setting_groups;

+ (NSArray *)_setting_reminds;
+ (NSArray *)_setting_password;

@end
