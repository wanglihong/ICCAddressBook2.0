//
//  XJParser.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XJParser.h"

@implementation XJParser

+ (Person *)personWithObject:(id)obj
{
    if ([obj isKindOfClass:[NSDictionary class]]) 
    {
        NSDictionary *data = [obj objectForKey:@"data"];
        
        if (data && [data isKindOfClass:[NSDictionary class]]) 
        {
            Person *person = [[[Person alloc] init] autorelease];
            
            person.personId     = [data objectForKey:@"_id"];
            person.chineseName  = [data objectForKey:@"truename"];
            person.englishName  = [data objectForKey:@"name"];
            person.team         = [data objectForKey:@"team"];
            person.position     = [data objectForKey:@"position"];
            person.ext          = [data objectForKey:@"phone"];
            person.phone        = [data objectForKey:@"mobile"];
            person.email        = [data objectForKey:@"email"];
            person.msn          = [data objectForKey:@"msn"];
            person.telephone    = [data objectForKey:@"homephone"];
            person.friends      = [data objectForKey:@"friends"];
            
            NSDictionary *meta  = [[data objectForKey:@"icon"] objectForKey:@"metadata"];
            person.pic160       = [meta objectForKey:@"160"];
            person.pic320       = [meta objectForKey:@"320"];
            person.pic640       = [meta objectForKey:@"640"];
            
            return person;
        }
    }
    
    return nil;
}

+ (NSMutableArray *)personsWithObject:(id)obj
{
    return nil;
}

@end
