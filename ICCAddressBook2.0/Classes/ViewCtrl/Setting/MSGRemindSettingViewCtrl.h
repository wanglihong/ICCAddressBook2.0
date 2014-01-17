//
//  RemindSettingViewCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface MSGRemindSettingViewCtrl : BaseViewCtrl
{
    IBOutlet UITableView *_tableView;
    IBOutlet UISwitch *_pushSwitch, *_soundSwitch;
}

@end
