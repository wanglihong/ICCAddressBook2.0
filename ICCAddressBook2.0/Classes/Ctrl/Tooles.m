//
//  tooles.m
//  huoche
//
//  Created by kan xu on 11-1-22.
//  Copyright 2011 paduu. All rights reserved.
//

#import "Tooles.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "BubbleView.h"
#define MsgBox(msg) [self MsgBox:msg]

@implementation Tooles

//程序中使用的，将日期显示成  2011年4月4日 星期一
+ (NSString *) Date2StrV:(NSDate *)indate{

	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]]; //setLocale 方法将其转为中文的日期表达
	dateFormatter.dateFormat = @"yyyy '-' MM '-' dd ' ' EEEE";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

//程序中使用的，提交日期的格式
+ (NSString *) Date2Str:(NSDate *)indate{
	
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
	dateFormatter.dateFormat = @"yyyyMMdd";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;	
}

//提示窗口
+ (void)MsgBox:(NSString *)msg{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg
												   delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];	
}

//获得日期的具体信息，本程序是为获得星期，注意！返回星期是 int 型，但是和中国传统星期有差异
+ (NSDateComponents *) DateInfo:(NSDate *)indate{

	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | 
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

	comps = [calendar components:unitFlags fromDate:indate];
	
	return comps;

//	week = [comps weekday];    
//	month = [comps month];
//	day = [comps day];
//	hour = [comps hour];
//	min = [comps minute];
//	sec = [comps second];

}


//打开一个网址
+ (void) OpenUrl:(NSString *)inUrl{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:inUrl]];
}

















static Tooles *_instance = nil;

+ (Tooles *)sharedTooles {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[Tooles alloc] init];
		}
	}
	
	return _instance;
}





+ (void)pushView:(UIView*)v1 fromView:(UIView*)v2 onView:(UIView*)cv
{
    [v2 removeFromSuperview];
    [cv addSubview:v1]; 
    CATransition *t = [CATransition animation];
    t.type = kCATransitionPush;
    t.subtype = kCATransitionFromRight;
    t.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    t.duration = 0.5;
    [cv.layer addAnimation:t forKey:@"MoveInView"];
}

+ (void)revealView:(UIView*)v1 fromView:(UIView*)v2 onView:(UIView*)cv
{
    [v2 removeFromSuperview];
    [cv addSubview:v1]; 
    CATransition *t = [CATransition animation];
    t.type = kCATransitionReveal;
    t.subtype = kCATransitionFromLeft;
    t.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    t.duration = 0.5;
    [cv.layer addAnimation:t forKey:@"RevealView"];
}








//生成一个 Bubble
+ (BubbleView *)bubbleWithText:(NSString *)text 
                  byMySelf:(BOOL)byMySelf 
                picAddress:(NSString *)picAddress 
                 timeStamp:(NSString *)time
{
	// returnView :一条消息返回的整个view 
	BubbleView *returnView = [[BubbleView alloc] initWithFrame:CGRectZero];
	returnView.backgroundColor = [UIColor clearColor];
	
    // bubble :聊天泡泡背景
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource: (byMySelf ? @"chat_voice_bubble-right" : @"chat_voice_bubble-left") ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
	
	UIFont *font = [UIFont systemFontOfSize:13];
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:  UILineBreakModeWordWrap];
	
    // header :头像
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(byMySelf ? size.width+31.0f : -31.0f, size.height-3.0f, 30.0f, 30.0f)];
    //header.image = [Tooles createChatHeader:[UIImage imageNamed:@"icon_default.png"] size:CGSizeMake(30.0f, 30.0f)];
    [header setImageWithURL:[NSURL URLWithString:picAddress] 
                                placeholderImage:[UIImage imageNamed:@"icon_default.png"]];
    
    // bubbleText :消息内容
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.0f, size.width+10, size.height+10)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = UILineBreakModeWordWrap;
	bubbleText.text = text;
    
    // timeLabel :消息时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(byMySelf ? size.width-68.0f: -31.0f, -21.0f, 130.0f, 21.0f)];
    timeLabel.textAlignment = byMySelf ? UITextAlignmentRight : UITextAlignmentLeft ;
	timeLabel.backgroundColor = [UIColor clearColor];
	timeLabel.font = font;
	timeLabel.text = time;
	
	bubbleImageView.frame = CGRectMake(0.0f, 0.0f, size.width+30.0f, size.height+30.0f);
	if(byMySelf)
		returnView.frame = CGRectMake(255.0f-size.width, 0.0f, size.width+10.0f, size.height+50.0f);
	else
		returnView.frame = CGRectMake(35.0f, 0.0f, size.width+20.0f, size.height+50.0f);
	
    [returnView addSubview:header];
    [header release];
	[returnView addSubview:bubbleImageView];
	[bubbleImageView release];
	[returnView addSubview:bubbleText];
	[bubbleText release];
    [returnView addSubview:timeLabel];
    [timeLabel release];
	
	return [returnView autorelease];
}






+ (NSString *)getFormattedDate:(NSString *)time
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]]; 
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'Z";
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@GMT+00:00", time]];
    
    //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *formattedString = [formatter stringFromDate:date];
    [formatter release];
    
    return formattedString;
}




// 把图片切成圆角
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 7, 7);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}

+ (id) createChatHeader:(UIImage*)image size:(CGSize)size
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 3, 3);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}







- (NSString *)documentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (NSString *)filePath:(NSString *)fileName
{
    NSString *path = [[self documentsPath] stringByAppendingPathComponent:fileName];
    
    return path;
}

- (void)saveImage_toLocal:(UIImage *)image withName:(NSString *)name
{
    NSString *path=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),name];
    NSData *imgData = UIImageJPEGRepresentation(image,0);    
    [imgData writeToFile:path atomically:YES];
}







+ (void)loudSpeaker:(bool)bOpen
{
    UInt32 route;
    OSStatus error;   
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    
    error = AudioSessionSetProperty (
                                     kAudioSessionProperty_AudioCategory,                       
                                     sizeof (sessionCategory),                                 
                                     &sessionCategory                                          
                                     );
    
    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
    error = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    
}






+ (int)currentTime 
{
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH"];
    NSString *timeString = [timeFormat stringFromDate:[NSDate date]];
    
    return [timeString intValue];
}






+ (NSString *)systemTime
{
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString = [timeFormat stringFromDate:[NSDate date]];
    
    return timeString;
}







+(UIImage *)rotateImage:(UIImage *)aImage

{
    
    CGImageRef imgRef = aImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    
    
    CGFloat scaleRatio = 1;
    
    
    
    CGFloat boundHeight;
    
    UIImageOrientation orient = aImage.imageOrientation;
    
    switch(orient)
    
    {
            
        case UIImageOrientationUp: //EXIF = 1
            
            transform = CGAffineTransformIdentity;
            
            break;
            
            
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            
            break;
            
            
            
        case UIImageOrientationDown: //EXIF = 3
            
            transform = CGAffineTransformMakeTranslation(width, height);
            
            transform = CGAffineTransformRotate(transform, M_PI);
            
            break;
            
            
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            
            transform = CGAffineTransformMakeTranslation(0.0, height);
            
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            
            break;
            
            
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeTranslation(height, width);
            
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            
            break;
            
            
            
        case UIImageOrientationLeft: //EXIF = 6
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeTranslation(0.0, width);
            
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            
            break;
            
            
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            
            break;
            
            
            
        case UIImageOrientationRight: //EXIF = 8
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            
            break;
            
            
            
        default:
            
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    
    
    UIGraphicsBeginImageContext(bounds.size);
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        
        CGContextTranslateCTM(context, -height, 0);
        
    }
    
    else {
        
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        
        CGContextTranslateCTM(context, 0, -height);
        
    }
    
    
    
    CGContextConcatCTM(context, transform);
    
    
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    return imageCopy;
    
}
               

@end
