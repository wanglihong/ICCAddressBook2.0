//
//  PersonInforViewCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewCtrl.h"

#import "Person.h"

@interface PersonInfoSettingViewCtrl : BaseViewCtrl <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    IBOutlet UITableView *_tableView;
    UIView *_topImageField;
    
    UIButton *leftBtn;
    UIButton *rightBtn;
    
    BOOL editting;
    
    UIImage *pickedImage;
}

@property (nonatomic, retain) Person *person;
@property (nonatomic, retain) NSArray *groups;
@property (nonatomic, retain) NSArray *values;
@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic, retain) UIImage *pickedImage;

@end
