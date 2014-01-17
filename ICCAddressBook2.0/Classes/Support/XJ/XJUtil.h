//
//  XJUtil.h
//  XJ
//
//  Created by Dennis Yang on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//Functions for Encoding Data.
@interface NSData (XJEncode)
- (NSString *)MD5EncodedString;
@end

//Functions for Encoding String.
@interface NSString (XJEncode)
- (NSString *)MD5EncodedString;
- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;
@end
