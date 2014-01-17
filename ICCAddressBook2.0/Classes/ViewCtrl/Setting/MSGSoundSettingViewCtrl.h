//
//  SetGetMsgSoundViewCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface MSGSoundSettingViewCtrl : BaseViewCtrl
{
    IBOutlet UITableView *_tableView;
    IBOutlet UISwitch *_soundSwitch;
    
    IBOutlet UILabel *_time_start_label;
    IBOutlet UILabel *_time_to_label;
    IBOutlet UILabel *_time_end_label;
    IBOutlet UIPickerView *_time_picker;
}

- (IBAction)switchValueChanged:(UISwitch *)_switch;

@end
