//
//  XJWaiter.m
//  XJ
//
//  Created by Dennis Yang on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XJWaiter.h"

#import "XJGlobal.h"

@interface XJWaiter (Private)

@end

@implementation XJWaiter

@synthesize request;
@synthesize delegate;
@synthesize callback;

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter dealloc] --
 *
 *      Destructor.
 *
 * Results:
 *      None
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)dealloc
{
    [request release], request = nil;
    
    delegate = nil;
    callback = nil;
    
    [super dealloc];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(private) loadRequestWithMethodName: methodType: params:] --
 *
 *      Create a HTML request.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)loadRequestWithMethodName:(NSString *)methodName 
                       methodType:(NSString *)methodType 
                           params:(NSDictionary *)params
{
    [request disconnect];
    
    self.request = [XJRequest requestWithUrlAddress:[NSString stringWithFormat:@"%@%@", kXJAPIDomain, methodName] 
                                         methodType:methodType 
                                             params:params 
                                           delegate:self];
    
    [request connect];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(private) loadRequestWithMethodName: methodType: fileData:] --
 *
 *      Create a HTML request.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)loadRequestWithMethodName:(NSString *)methodName 
                       methodType:(NSString *)methodType 
                           params:(NSDictionary *)params
                         fileData:(NSData   *)data
{
    [request disconnect];
    
    self.request = [XJRequest requestWithUrlAddress:[NSString stringWithFormat:@"%@%@", kXJAPIDomain, methodName] 
                                         methodType:methodType 
                                             params:params
                                           fileData:data 
                                           delegate:self];
    
    [request upload];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(private) loadRequestWithMethodName: methodType: filePath:] --
 *
 *      Create a HTML request.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)loadRequestWithMethodName:(NSString *)methodName 
                       methodType:(NSString *)methodType 
                           params:(NSDictionary *)params
                         filePath:(NSString *)filePath
{
    [request disconnect];
    
    self.request = [XJRequest requestWithUrlAddress:[NSString stringWithFormat:@"%@%@", kXJAPIDomain, methodName] 
                                         methodType:methodType 
                                             params:params
                                           filePath:filePath 
                                           delegate:self];
    
    [request uploadSoundFile];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) login: :] --
 *
 *      User to log in the system.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)login:(NSString *)email :(NSString *)pass
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:email ? email : @"" forKey:@"email"];
    [params setObject:pass ? pass : @"" forKey:@"password"];
    
    [self loadRequestWithMethodName:@"/login" 
                         methodType:@"POST" 
                             params:params];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) logout] --
 *
 *      User to log out the system.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)logout
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self loadRequestWithMethodName:@"/logout" 
                         methodType:@"POST" 
                             params:params];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) users] --
 *
 *      Get the password if you forget it.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)forgetPassword:(NSString *)email
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:email forKey:@"email"];
    
    [self loadRequestWithMethodName:@"/forgetpassword" 
                         methodType:@"POST" 
                             params:params];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) users] --
 *
 *      Get the addressBook list.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)users
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self loadRequestWithMethodName:@"/users" 
                         methodType:@"GET" 
                             params:params];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) addFriend:] --
 *
 *      Add a friend.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)addFriend:(NSString *)friendId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self loadRequestWithMethodName:[NSString stringWithFormat:@"/friend/%@", friendId] 
                         methodType:@"PUT" 
                             params:params];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) delFriend:] --
 *
 *      Delete a friend.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)delFriend:(NSString *)friendId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self loadRequestWithMethodName:[NSString stringWithFormat:@"/friend/%@", friendId] 
                         methodType:@"DELETE" 
                             params:params];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) submitDeviceToken:] --
 *
 *      Submint the device token , so we can receive the push messages.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)submitDeviceToken:(NSString *)deviceToken
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //[params setObject:deviceToken forKey:@"token"];
    [params setValue:deviceToken forKey:@"token"];
    
    [self loadRequestWithMethodName:@"/token" 
                         methodType:@"POST" 
                             params:params];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) modifyPassword: newPassword:] --
 *
 *      Modify the user's password.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)modifyPassword:(NSString *)old newPassword:(NSString *)new
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:old forKey:@"password"];
    [params setObject:new forKey:@"passwordNew"];
    
    [self loadRequestWithMethodName:@"/password" 
                         methodType:@"POST" 
                             params:params];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) upload: fileName:] --
 *
 *      Upload a file.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)upload:(NSData *)data fileName:(NSString *)name
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:name forKey:@"image"];
    
    [self loadRequestWithMethodName:@"/upload" 
                         methodType:@"POST" 
                             params:params 
                           fileData:data];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) upload:] --
 *
 *      Upload a file.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)upload:(NSString *)filePath
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self loadRequestWithMethodName:@"/upload" 
                         methodType:@"POST" 
                             params:params 
                           filePath:filePath];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) upload:] --
 *
 *      Upload some files.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */
/*
- (void)upload:(NSDictionary *)files
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:files];
    
    [self loadRequestWithMethodName:@"/upload" 
                         methodType:@"POST" 
                             params:params 
                           fileData:nil];
}
*/
#pragma mark - XJRequest Delegate Methods

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) request: didReceiveResponse:] --
 *
 *      Called as we get responses from the server.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)request:(XJRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) request: didReceiveData:] --
 *
 *      Called when received data from server.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)request:(XJRequest *)request didReceiveData:(NSData *)data
{
    
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) request: didReceiveData:] --
 *
 *      Called when request failed.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)request:(XJRequest *)request didFailWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(waiter:requestDidFailWithError:)]) 
    {
        [delegate waiter:self requestDidFailWithError:error];
    }
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[XJWaiter(Public) request: didReceiveData:] --
 *
 *      Called when request successed and received the data from server.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)request:(XJRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([delegate respondsToSelector:@selector(waiter:requestDidSucceedWithResult:)]) 
    {
        [delegate waiter:self requestDidSucceedWithResult:result];
    }
    
    [delegate performSelector:callback withObject:result withObject:nil];
}

@end
