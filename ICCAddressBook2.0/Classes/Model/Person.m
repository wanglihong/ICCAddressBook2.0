//
//  Person.m
//  ICCAddressBook
//
//  Created by Dennis Yang on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize personId = _personId;
@synthesize chineseName = _chineseName;
@synthesize englishName = _englishName;
@synthesize team = _team;
@synthesize position = _position;
@synthesize ext= _ext;
@synthesize phone = _phone;
@synthesize email = _email;
@synthesize msn = _msn;
@synthesize telephone = _telephone;
@synthesize pic160 = _pic160;
@synthesize pic320 = _pic320;
@synthesize pic640 = _pic640;

@synthesize isFriend = _isFriend;
@synthesize beFriendDate = _beFriendDate;
@synthesize msgCount = _msgCount;
@synthesize friends  = _friends;

- (void)dealloc {

    [_personId release];
    [_chineseName release];
    [_englishName release];
    [_team release];
    [_position release];
    [_ext release];
    [_phone release];
    [_email release];
    [_msn release];
    [_telephone release];
    [_pic160 release];
    [_pic320 release];
    [_pic640 release];
    
    [_isFriend release];
    [_beFriendDate release];
    [_msgCount release];
    [_friends release];
    
    [super dealloc];
}

@end
