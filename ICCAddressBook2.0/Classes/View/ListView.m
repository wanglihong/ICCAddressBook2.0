//
//  ListView.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListView.h"

@implementation ListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (CGRectContainsPoint(CGRectMake(0,0,320,self.bounds.size.height), point)) {
        
        return self.superview;
        
    }
    
    return [super hitTest:point withEvent:event];
    
}
*/
@end
