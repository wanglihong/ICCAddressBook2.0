//
//  Constants.m
//  laiyifen
//
//  Created by Dennis Yang on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

@implementation Constants

static Constants *_instance = nil;

+ (Constants *)sharedConstants {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[Constants alloc] init];
		}
	}
	
	return _instance;
}

// person informations

+ (NSArray *)_detail_group_titles {
    
    return [NSArray arrayWithObjects:@"    个人信息", @"    联系方式", @"    公司信息", nil];
}

+ (NSArray *)_person_information_titles {
    
    return [NSArray arrayWithObjects:@"中文名", @"英文名", nil];
}

+ (NSArray *)_contact_information_titles {
    
    return [NSArray arrayWithObjects:@"手机号码", @"宅电", @"Email", @"MSN", nil];
}

+ (NSArray *)_company_information_titles {
    
    return [NSArray arrayWithObjects:@"职位", @"所属部门", @"分机号码", nil];
}

// setting options

+ (NSArray *)_setting_group_titles {
    
    return [NSArray arrayWithObjects:@"    消息设置", @"    帐号管理", @"    ", nil];
}

+ (NSArray *)_service_type_titles {
    
    return [NSArray arrayWithObjects:@"隐身模式", @"定位服务", nil];
}

+ (NSArray *)_message_type_titles {
    
    return [NSArray arrayWithObjects:@"提醒设置", @"静音时段", nil];
}

+ (NSArray *)_account_type_titles {
    
    return [NSArray arrayWithObjects:@"个人信息", @"密码设置", nil];
}

+ (NSArray *)_suggest_type_titles {
    
    return [NSArray arrayWithObjects:@"意见反馈", @"评价", @"用户帮助", nil];
}

+ (NSArray *)_other_titles {
    
    return [NSArray arrayWithObjects:@"退出", nil];
}

+ (NSArray *)_setting_groups {
    
    return [NSArray arrayWithObjects:[Constants _message_type_titles], [Constants _account_type_titles], [Constants _other_titles], nil];
}

+ (NSArray *)_setting_reminds {
    
    return [NSArray arrayWithObjects:@"提醒", @"声音",  nil];
}

+ (NSArray *)_setting_password {
    
    return [NSArray arrayWithObjects:@"旧密码", @"新密码", @"重复密码",  nil];
}

@end
