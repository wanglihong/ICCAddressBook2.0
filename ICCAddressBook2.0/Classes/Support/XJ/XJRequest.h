//
//  XJRequest.h
//  XJ
//
//  Created by Dennis Yang on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XJRequest;

@protocol XJRequestDelegate <NSObject>

@optional

- (void)request:(XJRequest *)request didReceiveResponse:(NSURLResponse *)response;

- (void)request:(XJRequest *)request didReceiveData:(NSData *)data;

- (void)request:(XJRequest *)request didFailWithError:(NSError *)error;

- (void)request:(XJRequest *)request didFinishLoadingWithResult:(id)result;

@end

@interface XJRequest : NSObject
{
    NSString                *urlAddress;
    NSString                *methodType;
    NSDictionary            *params;
    NSData                  *fileData;
    NSString                *filePath;
    
    NSURLConnection         *connection;
    NSHTTPURLResponse       *httpResponse;
    NSMutableData           *responseData;
    
    id<XJRequestDelegate>   delegate;
}

@property (nonatomic, retain) NSString *urlAddress;
@property (nonatomic, retain) NSString *methodType;
@property (nonatomic, retain) NSDictionary *params;
@property (nonatomic, retain) NSData *fileData;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSHTTPURLResponse *httpResponse;
@property (nonatomic, retain) id<XJRequestDelegate> delegate;

+ (XJRequest *)requestWithAccessToken:(NSString *)accessToken 
                           urlAddress:(NSString *)urlAddress 
                           methodType:(NSString *)methodType 
                               params:(NSDictionary *)params 
                             delegate:(id<XJRequestDelegate>)delegate;

+ (XJRequest *)requestWithUrlAddress:(NSString *)urlAddress 
                          methodType:(NSString *)methodType 
                              params:(NSDictionary *)params 
                            delegate:(id<XJRequestDelegate>)delegate;

+ (XJRequest *)requestWithUrlAddress:(NSString *)urlAddress 
                          methodType:(NSString *)methodType 
                              params:(NSDictionary *)params
                            fileData:(NSData   *)data 
                            delegate:(id<XJRequestDelegate>)delegate;

+ (XJRequest *)requestWithUrlAddress:(NSString *)urlAddress 
                          methodType:(NSString *)methodType 
                              params:(NSDictionary *)params
                            filePath:(NSString *)filePath 
                            delegate:(id<XJRequestDelegate>)delegate;

+ (NSString *)serializeURLAddress:(NSString *)baseURLAddress params:(NSDictionary *)params methodType:(NSString *)methodType;

- (void)connect;
- (void)disconnect;
- (void)upload;
- (void)uploadSoundFile;

@end
