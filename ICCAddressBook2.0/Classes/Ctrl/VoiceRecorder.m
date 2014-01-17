//
//  VoiceRecorder.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VoiceRecorder.h"

@implementation VoiceRecorder

- (id)init
{
    if (self = [super init]) 
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory 
                                  withIntermediateDirectories:NO 
                                                   attributes:nil 
                                                        error:nil];
        
        audioSession= [AVAudioSession sharedInstance];
        audioSession.delegate = self;
        
        NSString *fileName = @"record.wav";
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        NSURL *url = [NSURL fileURLWithPath:fullPath];
        
        NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithFloat:44100.0],             AVSampleRateKey,
                                [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                [NSNumber numberWithInt:1],                     AVNumberOfChannelsKey,
                                [NSNumber numberWithInt:16],                    AVLinearPCMBitDepthKey,
                                [NSNumber numberWithBool:NO],                   AVLinearPCMIsBigEndianKey,
                                [NSNumber numberWithBool:NO],                   AVLinearPCMIsFloatKey,
                                nil];   
        
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
        
        NSError *error;
        audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
        audioRecorder.delegate = self;
        
        voicePath = [fullPath retain];
    }
    
    return self;
}

- (void)levelTimerCallback:(NSTimer *)timer
{
    [audioRecorder updateMeters];
    NSLog(@"1 %f 2%f", [audioRecorder averagePowerForChannel:0], [audioRecorder peakPowerForChannel:0]);
}

- (void)startDoRecord
{
    [audioSession setActive: YES error: nil];
    
    if (audioRecorder) 
    {        
        [audioRecorder prepareToRecord];
        [audioRecorder setMeteringEnabled:YES];
        [audioRecorder peakPowerForChannel:0];
        
        levelTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 
                                                      target:self 
                                                    selector:@selector(levelTimerCallback:) 
                                                    userInfo:nil 
                                                     repeats:YES];
        [audioRecorder record];
    }
}

- (void)stopDoRecord
{
    [audioRecorder stop];
}

- (void)startPlayRecord
{
    NSData *data=[NSData dataWithContentsOfFile:voicePath options:0 error:nil];
    
    NSError *error;
    audioPlayer= [[AVAudioPlayer alloc] initWithData:data error:&error];
    audioPlayer.volume = 0.5;
    audioPlayer.meteringEnabled=YES;
    audioPlayer.numberOfLoops= 0;
    audioPlayer.delegate=self;
    
    if(audioPlayer != nil)
    {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
        [audioPlayer play];
    }
}

- (void)stopPlayRecord
{
    
}

- (void)removeVoice
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:voicePath error:&error];
    
    [audioPlayer stop];
    [audioPlayer release];
    
    [audioRecorder stop];
}

@end
