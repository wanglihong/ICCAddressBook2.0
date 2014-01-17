//
//  tooles.h
//  huoche
//
//  Created by kan xu on 11-1-22.
//  Copyright 2011 paduu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Tooles : NSObject

+ (NSString *)Date2StrV:(NSDate *)indate;
+ (NSString *)Date2Str:(NSDate *)indate;
+ (void)MsgBox:(NSString *)msg;

+ (NSDateComponents *)DateInfo:(NSDate *)indate;

+ (void)OpenUrl:(NSString *)inUrl;

+ (id)sharedTooles;

+ (void)pushView:(UIView*)v1 fromView:(UIView*)v2 onView:(UIView*)cv;

+ (void)revealView:(UIView*)v1 fromView:(UIView*)v2 onView:(UIView*)cv;

+ (UIView *)bubbleWithText:(NSString *)text 
                  byMySelf:(BOOL)byMySelf 
                picAddress:(NSString *)picAddress 
                 timeStamp:(NSString *)time;

+ (NSString *)getFormattedDate:(NSString *)time;

+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size;
+ (id) createChatHeader:(UIImage*)image size:(CGSize)size;

- (NSString *)documentsPath;
- (NSString *)filePath:(NSString *)fileName;

+ (void)loudSpeaker:(bool)bOpen;
+ (int)currentTime;
+ (NSString *)systemTime;

+ (UIImage *)rotateImage:(UIImage *)aImage;

@end
