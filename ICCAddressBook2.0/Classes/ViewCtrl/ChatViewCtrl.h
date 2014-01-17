//
//  ChatViewCtrl.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewCtrl.h"

#import "Person.h"

#import "SoundRecorder.h"

#import "GTMBase64.h"

@interface ChatViewCtrl : BaseViewCtrl <UITableViewDelegate, UITableViewDataSource, 
UITextFieldDelegate, AVAudioPlayerDelegate, SoundRecorderDelegate>
{
    IBOutlet UITableView *_tableView;
    IBOutlet UIView      *_bottomBar;
    
    //---------------键盘工具栏--------------------------
    IBOutlet UIView      *_keyboardView;
    IBOutlet UITextField *_inputField;
    IBOutlet UIButton    *_sendBtn;
    IBOutlet UIButton    *_voiceBtn;
    
    //---------------语音工具栏--------------------------
    IBOutlet UIView      *_recorderView;
    IBOutlet UIButton    *_backBtn;
    IBOutlet SoundRecorder *recoder;
    
    //---------------网络状态栏--------------------------
    IBOutlet UIImageView *_networkStatusView;
    IBOutlet UILabel     *_statusTitleLabel;
    
    
    NSMutableArray       *_chatContents;
    int                  position;
}

@property (nonatomic, retain) Person *person;

- (id)initWithPerson:(Person *)thePerson;

@end
