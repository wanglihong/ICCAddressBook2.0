//
//  ListCell.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@interface ListCell : UITableViewCell
{
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *distanceLabel;
    IBOutlet UILabel *contentLabel;
    IBOutlet UILabel *dateLabel;
}

@property (nonatomic, assign) UIImageView *imageView;
@property (nonatomic, assign) UILabel *titleLabel;
@property (nonatomic, assign) UILabel *distanceLabel;
@property (nonatomic, assign) UILabel *contentLabel;
@property (nonatomic, assign) UILabel *dateLabel;

- (void)setBadgeValue:(NSString *)badgeValue;

@end
