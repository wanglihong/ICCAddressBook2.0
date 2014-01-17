//
//  PasswordSettingViewCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface PasswordSettingViewCtrl : BaseViewCtrl
{
    IBOutlet UITableView *_tableView;
    IBOutlet UITextField *_old_pwd_field;
    IBOutlet UITextField *_new_pwd_field;
    IBOutlet UITextField *_cfm_pwd_field;
}

@end
