//
//  XJGlobal.h
//  XJ
//
//  Created by Dennis Yang on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef XJ_XJGlobal_h
#define XJ_XJGlobal_h

#endif


#define kXJSDKErrorDomain           @"XJSDKErrorDomain"
#define kXJSDKErrorCodeKey          @"XJSDKErrorCodeKey"

#define kXJAPIDomain                @"http://www.umaman.com:8080"
#define kXJAIPToken                 @"ldakfuk78w3llao0a"


typedef enum
{
	kXJErrorCodeInterface	= 100,
	kXJErrorCodeSDK         = 101,
}XJErrorCode;

typedef enum
{
	kXJSDKErrorCodeParseError       = 200,
	kXJSDKErrorCodeRequestError     = 201,
	kXJSDKErrorCodeAccessError      = 202,
	kXJSDKErrorCodeAuthorizeError	= 203,
}XJSDKErrorCode;
