//
//  DetailViewCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

#import "BaseViewCtrl.h"

#import "Person.h"

@interface DetailViewCtrl : BaseViewCtrl <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>
{
    IBOutlet UITableView *_tableView;
    UIView *_topImageField;
    
    UIButton *leftBtn;
    IBOutlet UIButton *rightBtn;
}

@property (nonatomic, retain) Person *person;
@property (nonatomic, retain) NSArray *groups;
@property (nonatomic, retain) NSArray *values;

@end
