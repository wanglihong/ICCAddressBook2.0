//
//  ListCell.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListCell.h"

#import "UIBadgeView.h"

@implementation ListCell

@synthesize imageView;
@synthesize titleLabel;
@synthesize distanceLabel;
@synthesize contentLabel;
@synthesize dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    for (UIBadgeView *bv in [self subviews]) 
    {
        if ([bv isKindOfClass:[UIBadgeView class]]) {
            [bv removeFromSuperview];
        }
    }
    
    if ([badgeValue intValue] <= 0) {
        return;
    }
    
    UIBadgeView *bv;
    bv = [[UIBadgeView alloc] initWithFrame:CGRectMake(67, -4, 30, 20)];
	bv.badgeString = badgeValue;
	bv.badgeColor = [UIColor redColor];
    
	[self.imageView addSubview:bv];
	[bv release];
}

@end
