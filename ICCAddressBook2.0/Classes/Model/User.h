//
//  User.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"

@interface User : NSObject
{
    // 用户个人信息
    Person          *person;
    
    // 当前用户的好友
    NSMutableArray  *persons;
    
    // 当前请求的cookie
    NSString        *cookie;
    
    // 当前设备deviceToken
    NSString        *deviceToken;
    
    // 当前用户的登录帐号及密码
    NSString        *username, *password;
}

@property (nonatomic, retain) Person *person;
@property (nonatomic, retain) NSString *username, *password;
@property (nonatomic, retain) NSMutableArray *persons;
@property (nonatomic, retain) NSString *cookie;
@property (nonatomic, retain) NSString *deviceToken;

+ (User *)currentUser;

@end
