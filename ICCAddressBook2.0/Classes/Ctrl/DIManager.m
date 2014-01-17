//
//  DIManager.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//  DIManager: Dialogue Manager (对话管理器)

#import "DIManager.h"

@implementation DIManager

+ (AppDelegate *)_app_delegate {
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (NSMutableArray *)_all_persons {
    return nil;
}

+ (NSMutableArray *)_opening_dialogues {
    
    return [DIManager _app_delegate].dialogues;
}

+ (ChatViewCtrl *)_dialogue_at_index:(int)index {
    
    return (ChatViewCtrl *)[[DIManager _opening_dialogues] objectAtIndex:index];
}

+ (ChatViewCtrl *)_dialogue_with_person:(Person *)person {
    
    NSUInteger index;
    for (ChatViewCtrl *ctrl in [DIManager _opening_dialogues]) {
        if ([ctrl.person.personId isEqual:person.personId]) {
            index = [[DIManager _opening_dialogues] indexOfObject:ctrl];
        }
    }
    
    return [DIManager _dialogue_at_index:index];
}

+ (BOOL)_if_dialogue_exist:(NSString *)personId {
    
    for (ChatViewCtrl *ctrl in [DIManager _opening_dialogues]) {
        if ([ctrl.person.personId isEqual:personId]) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)_add_dialogue_with_person:(Person *)person {
    
    ChatViewCtrl *ctrl = [[[ChatViewCtrl alloc] initWithNibName:@"ChatViewCtrl" bundle:nil] autorelease];
    ctrl.person = person;
    [[DIManager _opening_dialogues] addObject:ctrl];
}

@end
