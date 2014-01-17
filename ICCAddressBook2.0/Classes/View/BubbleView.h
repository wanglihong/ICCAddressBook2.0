//
//  BubbleView.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {text_plain, audio_mpeg}Type;

@interface BubbleView : UIView <AVAudioPlayerDelegate> {
    
    NSString        *head;              // 头像
    NSString        *content;           // 内容
    NSString        *date;              // 日期
    NSData          *audio;             // 音频解码数据
    BOOL            isSelf;             // 是否我的消息
    
    UILabel         *bubbleText;
    UIImageView     *bubbleMedium;
}

@property (nonatomic, retain) NSString *head; 
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSData   *audio;
@property BOOL isSelf;

- (id)initWithHead:(NSString *)theHead 
           content:(NSString *)theContent 
              date:(NSString *)theDate 
            isSelf:(BOOL)ifIsSelf;

@end
