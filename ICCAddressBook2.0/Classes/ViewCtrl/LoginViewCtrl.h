//
//  LoginViewCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewCtrl.h"

@interface LoginViewCtrl : BaseViewCtrl <UIAlertViewDelegate>
{
    IBOutlet UITextField *emailField, *passField;
    IBOutlet UIView *loginView;
}

@end
