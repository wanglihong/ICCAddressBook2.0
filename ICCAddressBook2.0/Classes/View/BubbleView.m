//
//  BubbleView.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BubbleView.h"

#import "UIImageView+WebCache.h"

#import "Tooles.h"

@implementation BubbleView

@synthesize head;
@synthesize content;
@synthesize date;
@synthesize audio;
@synthesize isSelf;


- (id)initWithHead:(NSString *)theHead 
           content:(NSString *)theContent 
              date:(NSString *)theDate 
            isSelf:(BOOL)ifIsSelf
{
    self = [super initWithFrame:CGRectZero];
    if (self) 
    {
        self.head = theHead;
        self.content = theContent;
        self.date = theDate;
        self.isSelf = ifIsSelf;
        
        UIFont *font = [UIFont systemFontOfSize:13];
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
        
        NSString *bubblePath = [[NSBundle mainBundle] pathForResource:isSelf ? @"chat_voice_bubble-right" : @"chat_voice_bubble-left" ofType:@"png"];
        UIImage *bubbleImage = [UIImage imageWithContentsOfFile:bubblePath];
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubbleImage stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        bubbleImageView.frame = CGRectMake(0.0f, 0.0f, size.width+30.0f, size.height+30.0f);
        [self addSubview:bubbleImageView];
        [bubbleImageView release];
        
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(isSelf ? size.width+31.0f : -31.0f, size.height-3.0f, 30.0f, 30.0f)];
        [headImageView setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"icon_default.png"]];
        [self addSubview:headImageView];
        [headImageView release];
        
        bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.0f, size.width+10, size.height+10)];
        bubbleText.backgroundColor = [UIColor clearColor];
        bubbleText.font = font;
        bubbleText.numberOfLines = 0;
        bubbleText.lineBreakMode = UILineBreakModeWordWrap;
        bubbleText.text = content;
        [self addSubview:bubbleText];
        [bubbleText release];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(isSelf ? size.width-68.0f: -31.0f, -21.0f, 130.0f, 21.0f)];
        timeLabel.textAlignment = isSelf ? UITextAlignmentRight : UITextAlignmentLeft ;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = font;
        timeLabel.text = date;
        [self addSubview:timeLabel];
        [timeLabel release];
        
        bubbleMedium = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 12.0f, 19.0f)];
        bubbleMedium.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"voice_low"], 
                                        [UIImage imageNamed:@"voice_medium"], [UIImage imageNamed:@"voice_max"], nil];
        bubbleMedium.animationDuration = 1.0f;
        
        if(isSelf)
            self.frame = CGRectMake(255.0f-size.width, 0.0f, size.width+10.0f, size.height+50.0f);
        else
            self.frame = CGRectMake(35.0f, 0.0f, size.width+20.0f, size.height+50.0f);
    }
    return self;
}

- (void)dealloc
{
    [head release];
    [content release];
    [date release];
    [audio release];
    [bubbleMedium release];
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"play sound");
    
    if (audio) {
        bubbleText.alpha = 0;
        [self addSubview:bubbleMedium];
        [bubbleMedium startAnimating];
        
        NSError *error;
        AVAudioPlayer *audioPlayer= [[AVAudioPlayer alloc] initWithData:audio error:&error];
        [audioPlayer setDelegate:self];
        [audioPlayer play];
        [Tooles loudSpeaker:YES];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player 
                       successfully:(BOOL)flag
{
    bubbleText.alpha = 1;
    [bubbleMedium stopAnimating];
    [bubbleMedium removeFromSuperview];
    
    [player stop];
    [player release];
}

@end
