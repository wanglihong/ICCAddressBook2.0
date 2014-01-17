//
//  VoiceRecorder.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface VoiceRecorder : NSObject <AVAudioPlayerDelegate, AVAudioRecorderDelegate, AVAudioSessionDelegate>
{
    AVAudioSession  *audioSession;
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer   *audioPlayer;
    
    NSTimer         *levelTimer;
    NSString        *voicePath;
}

@end
