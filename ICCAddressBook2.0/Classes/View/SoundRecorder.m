//
//  SoundRecorder.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SoundRecorder.h"

#import "lame.h"

@implementation SoundRecorder

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UIImageView *recordView = [[UIImageView alloc] initWithFrame:CGRectMake(107, 120, 105, 120)];
        recordView.image = [UIImage imageNamed:@"icon_recording.png"];
        [self addSubview:recordView];
        [recordView release];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = [paths objectAtIndex:0];
        
        audioSession = [AVAudioSession sharedInstance];
        audioSession.delegate = self;
        
        audioFileName = @"record.caf";
        audioFilePath = [[documentsPath stringByAppendingPathComponent:audioFileName] retain];
        __mp3FileName = @"record.mp3";
        __mp3FilePath = [[documentsPath stringByAppendingPathComponent:__mp3FileName] retain];
        
        pathURL = [NSURL fileURLWithPath:audioFilePath];
        
        NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:AVAudioQualityMin],AVEncoderAudioQualityKey,
                                [NSNumber numberWithInt:16],AVEncoderBitRateKey,
                                [NSNumber numberWithInt: 2],AVNumberOfChannelsKey,
                                [NSNumber numberWithFloat:44100.0],AVSampleRateKey,
                                nil];
        
        [audioSession setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
        
		NSError *error;
        audioRecorder = [[AVAudioRecorder alloc] initWithURL:pathURL settings:settings error:&error];
        audioRecorder.delegate = self;
    }
    return self;
}

- (void)startRecord
{
    if (!recording) 
    {
        [audioSession setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
        [audioSession setActive: YES error: nil];
		if (audioRecorder) {        
			[audioRecorder prepareToRecord];        
			audioRecorder.meteringEnabled = YES;        
            [audioRecorder peakPowerForChannel:0];
            levelTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self 
                                                        selector:@selector(levelTimerCallback:) 
                                                        userInfo:nil repeats:YES];
			[audioRecorder record];
        }
    } 
    
    recording = YES;
}

- (void)stopRecord
{
    if (recording)
    {
        [audioRecorder stop];
        
        [self toMp3];
        
        if ([delegate respondsToSelector:@selector(soundRecordDidFinishWithFile:)]) 
            [delegate soundRecordDidFinishWithFile:__mp3FilePath];
    }
    
    recording = NO;
}

- (void)startPlay
{
    if (!playing) 
    {
        NSData *data=[NSData dataWithContentsOfFile:audioFilePath options:0 error:nil];
        
        NSError *error;
        audioPlayer= [[AVAudioPlayer alloc] initWithData:data error:&error];
        audioPlayer.volume = 0.5;
        audioPlayer.meteringEnabled=YES;
        audioPlayer.numberOfLoops= 0;
        audioPlayer.delegate=self;
        
        if(audioPlayer== nil)
            NSLog(@"Error");
        else
        {
            [audioSession setCategory: AVAudioSessionCategorySoloAmbient error: nil];
            [audioPlayer play];
        }
    }
    
    playing = YES;
}

- (void)stopPlay
{
    if (playing)
    {
        [audioPlayer stop];
        [audioPlayer release];
    }
    
    playing = NO;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder 
                           successfully:(BOOL)flag
{
    [audioSession setActive: NO error: nil];
    if (levelTimer) [levelTimer invalidate];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player 
                       successfully:(BOOL)flag
{
    [audioPlayer stop];
    [audioPlayer release];
    playing = NO;
}

- (void)levelTimerCallback:(NSTimer *)timer
{
    [audioRecorder updateMeters];
    NSLog(@"1 %f 2%f",[audioRecorder averagePowerForChannel:0],[audioRecorder peakPowerForChannel:0]);
}

- (void)toMp3
{
    @try
    {
        int read, write;
        
        FILE *pcm = fopen([audioFilePath cStringUsingEncoding:1], "rb");//被转换的文件
        FILE *mp3 = fopen([__mp3FilePath cStringUsingEncoding:1], "wb");//转换后文件的存放位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    
    @catch (NSException *exception)
    {
        NSLog(@"%@",[exception description]);
    }
    
    @finally
    {
        
    }
}

@end
