//
//  XJWaiter.h
//  XJ
//
//  Created by Dennis Yang on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XJRequest.h"

#import "User.h"

@class XJWaiter;

@protocol XJWaiterDelegate <NSObject>

@optional

- (void)waiter:(XJWaiter *)waiter requestDidSucceedWithResult:(id)result;

- (void)waiter:(XJWaiter *)waiter requestDidFailWithError:(NSError *)error;

@end

@interface XJWaiter : NSObject <XJRequestDelegate>
{
    XJRequest               *request;
    id<XJWaiterDelegate>    delegate;
    SEL                     callback;
}

@property (nonatomic, retain) XJRequest *request;
@property (nonatomic, assign) id<XJWaiterDelegate> delegate;
@property SEL callback;

// @methodName: The interface you are trying to visit, exp, "statuses/public_timeline.json"
// @methodType: "GET" or "POST".
// @params: A dictionary that contains your request parameters.
// @postDataType: "GET" for kWBRequestPostDataTypeNone, "POST" for kWBRequestPostDataTypeNormal or kWBRequestPostDataTypeMultipart.
// @httpHeaderFields: A dictionary that contains HTTP header information.
- (void)loadRequestWithMethodName:(NSString *)methodName 
                       methodType:(NSString *)methodType 
                           params:(NSDictionary *)params;

- (void)loadRequestWithMethodName:(NSString *)methodName 
                       methodType:(NSString *)methodType 
                           params:(NSDictionary *)params
                         fileData:(NSData   *)data;

- (void)loadRequestWithMethodName:(NSString *)methodName 
                       methodType:(NSString *)methodType 
                           params:(NSDictionary *)params
                         filePath:(NSString *)filePath;

// 登录
- (void)login:(NSString *)email :(NSString *)pass;

// 退出
- (void)logout;

// 找回密码
- (void)forgetPassword:(NSString *)email;

// 获取用户列表
- (void)users;

// 添加好友
- (void)addFriend:(NSString *)friendId;

// 删除好友
- (void)delFriend:(NSString *)friendId;

// 提交deviceToken
- (void)submitDeviceToken:(NSString *)deviceToken;

// 修改密码
- (void)modifyPassword:(NSString *)old newPassword:(NSString *)new;

// 上传单个文件
- (void)upload:(NSData *)data fileName:(NSString *)name;

// 上传文件
- (void)upload:(NSString *)filePath;

@end
