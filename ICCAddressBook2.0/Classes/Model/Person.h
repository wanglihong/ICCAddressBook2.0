//
//  Person.h
//  ICCAddressBook
//
//  Created by Dennis Yang on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, retain) NSString *personId;
@property (nonatomic, retain) NSString *chineseName;
@property (nonatomic, retain) NSString *englishName;
@property (nonatomic, retain) NSString *team;
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) NSString *ext;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *msn;
@property (nonatomic, retain) NSString *telephone;
@property (nonatomic, retain) NSString *pic160;
@property (nonatomic, retain) NSString *pic320;
@property (nonatomic, retain) NSString *pic640;

@property (nonatomic, retain) NSString *isFriend;
@property (nonatomic, retain) NSString *beFriendDate;
@property (nonatomic, retain) NSString *msgCount;
@property (nonatomic, retain) NSMutableArray  *friends;

@end
