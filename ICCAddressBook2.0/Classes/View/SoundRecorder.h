//
//  SoundRecorder.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol SoundRecorderDelegate <NSObject>

- (void)soundRecordDidFinishWithFile:(NSString *)filePath;

@end

@interface SoundRecorder : UIView <AVAudioPlayerDelegate,AVAudioRecorderDelegate,AVAudioSessionDelegate> {
    AVAudioSession  *audioSession;
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer   *audioPlayer;
    NSString        *documentsPath;
    NSString        *audioFileName;
    NSString        *audioFilePath;
    NSString        *__mp3FileName;
    NSString        *__mp3FilePath;
    NSURL           *pathURL;
    NSTimer         *levelTimer;
    
    id<SoundRecorderDelegate> delegate;
    BOOL recording;
    BOOL playing;
}

@property (nonatomic, assign) id<SoundRecorderDelegate> delegate;

- (void)startRecord;
- (void)stopRecord;
- (void)startPlay;
- (void)stopPlay;

@end
