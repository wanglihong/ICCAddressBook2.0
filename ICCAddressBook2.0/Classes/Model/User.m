//
//  User.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize person;
@synthesize username, password;
@synthesize persons;
@synthesize cookie;
@synthesize deviceToken;

- (void)dealloc
{
    [person release];
    [username release];
    [password release];
    [persons release];
    [cookie release];
    [deviceToken release];
    
    [super dealloc];
}

static User *_instance = nil;

+ (User *)currentUser {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[User alloc] init];
		}
	}
	
	return _instance;
}

@end
