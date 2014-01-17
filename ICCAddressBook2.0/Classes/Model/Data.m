//
//  Data.m
//  ICCAddressBook
//
//  Created by Dennis Yang on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Data.h"

#import "DBManager.h"

@implementation Data

@synthesize records = _records;



static Data *_instance = nil;

+ (Data *)sharedData {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[Data alloc] init];
		}
	}
	
	return _instance;
}

- (id)init {
    if (self = [super init]) {
        self.records = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)clear {
    [_records removeAllObjects];
}

- (void)read {

    DBManager *manager = [[[DBManager alloc] init] autorelease];
    
    for (Person *person in [manager dataFromeTable]) {
        
        [_records addObject:person];
        
    }
}

- (void)write {
    
    DBManager *manager = [[[DBManager alloc] init] autorelease];//用于存放 要写进 plist 里的数据
    
    for (Person *person in [[Data sharedData] records]) {
        
        [manager insert:person];
    }


    
}


- (int)numberOfRecords {
    return [_records count];
}

- (void)addRecord:(Person *)person {
    //[_records addObject:person];
    DBManager *manager = [[[DBManager alloc] init] autorelease];
    [manager insert:person];
}

- (Person *)recordAtIndex:(int)index {
    return [_records objectAtIndex:index];
}

- (void)dealloc {
    [self.records release];
    [super dealloc];
}

@end
