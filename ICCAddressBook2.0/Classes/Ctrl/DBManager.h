//
//  DBManager.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "Person.h"

@interface DBManager : NSObject
{
    sqlite3 *_database;
}

@property (nonatomic) sqlite3 *database;

+ (DBManager *)defaultManager;

- (NSMutableArray *)dataFromeTable;
- (Person *)select:(NSString *)personId;
- (BOOL)insert:(Person *)person;
- (BOOL)clear;

@end

