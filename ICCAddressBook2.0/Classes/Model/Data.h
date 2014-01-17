//
//  Data.h
//  ICCAddressBook
//
//  Created by Dennis Yang on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Data : NSObject

@property (nonatomic, retain) NSMutableArray *records;

+ (Data *)sharedData;

- (void)clear;

- (void)read;

- (void)write;

- (int)numberOfRecords;

- (void)addRecord:(Person *)person;

- (Person *)recordAtIndex:(int)index;

@end
