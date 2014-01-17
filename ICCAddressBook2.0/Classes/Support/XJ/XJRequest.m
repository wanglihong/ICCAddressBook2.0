//
//  XJRequest.m
//  XJ
//
//  Created by Dennis Yang on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XJRequest.h"
#import "XJUtil.h"
#import "JSON.h"
#import "XJGlobal.h"
#import "GTMBase64.h"
#import "User.h"


static NSString * const BOUNDRY = @"0xKhTmLbOuNdArY";
static NSString * const FORM_FLE_INPUT = @"uploaded";

@implementation XJRequest

@synthesize urlAddress;
@synthesize methodType;
@synthesize params;
@synthesize fileData;
@synthesize filePath;
@synthesize httpResponse;
@synthesize delegate;


#pragma mark - XJRequest Life Circle

- (void)dealloc
{
    [urlAddress release], urlAddress = nil;
    [methodType release], methodType = nil;
    [params release], params = nil;
    [fileData release], fileData = nil;
    [httpResponse release], httpResponse = nil;
    
    [delegate release], delegate = nil;
    
    [super dealloc];
}

#pragma mark - XJRequest Private Methods

+ (NSString *)timestamp 
{
    NSDateFormatter *timeFormat = [[[NSDateFormatter alloc] init] autorelease];
    [timeFormat setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    return [timeFormat stringFromDate:[NSDate date]];
}


+ (NSString *)stringFromDictionary:(NSDictionary *)dict
{
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [dict keyEnumerator])
	{
		if (!([[dict valueForKey:key] isKindOfClass:[NSString class]]))
		{
			continue;
		}
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [[dict objectForKey:key] URLEncodedString]]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString
{
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSMutableData *)postBody
{
    NSMutableData *body = [NSMutableData data];
    
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [mutableParams setObject:[XJRequest timestamp] forKey:@"timestamp"];
    
    NSString *full = [NSString stringWithFormat:@"%@%@", [XJRequest serializeURLAddress:urlAddress params:params methodType:methodType], [XJRequest stringFromDictionary:mutableParams]];
    [mutableParams setObject:[[NSString stringWithFormat:@"%@%@", full, kXJAIPToken] MD5EncodedString] forKey:@"sign"];
    
    [XJRequest appendUTF8Body:body dataString:[XJRequest stringFromDictionary:mutableParams]];
    
    return body;
}

- (void)handleResponseData:(NSData *)data 
{
    if ([delegate respondsToSelector:@selector(request:didReceiveData:)])
    {
        [delegate request:self didReceiveData:data];
    }
	
	NSError* error = nil;
	id result = [self parseJSONData:data error:&error];
	
	if (error) 
	{
		[self failedWithError:error];
	} 
	else 
	{
        if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)])
		{
            [delegate request:self didFinishLoadingWithResult:(result == nil ? data : result)];
		}
	}
}

- (id)parseJSONData:(NSData *)data error:(NSError **)error
{
	
	NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	SBJSON *jsonParser = [[SBJSON alloc]init];
	
	NSError *parseError = nil;
	id result = [jsonParser objectWithString:dataString error:&parseError];
	
	if (parseError)
    {
        if (error != nil)
        {
            *error = [self errorWithCode:kXJErrorCodeSDK
                                userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", kXJSDKErrorCodeParseError]
                                                                     forKey:kXJSDKErrorCodeKey]];
        }
	}
    
	[dataString release];
	[jsonParser release];
	
    
	if ([result isKindOfClass:[NSDictionary class]])
	{
		if ([result objectForKey:@"error_code"] != nil && [[result objectForKey:@"error_code"] intValue] != 200)
		{
			if (error != nil) 
			{
				*error = [self errorWithCode:kXJErrorCodeInterface userInfo:result];
			}
		}
	}
	
	return result;
}

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:kXJSDKErrorDomain code:code userInfo:userInfo];
}

- (void)failedWithError:(NSError *)error 
{
	if ([delegate respondsToSelector:@selector(request:didFailWithError:)]) 
	{
		[delegate request:self didFailWithError:error];
	}
}

#pragma mark - XJRequest Public Methods

+ (XJRequest *)requestWithAccessToken:(NSString *)accessToken 
                           urlAddress:(NSString *)urlAddress 
                           methodType:(NSString *)methodType 
                               params:(NSDictionary *)params 
                             delegate:(id<XJRequestDelegate>)delegate
{
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [mutableParams setObject:accessToken forKey:@"access_token"];
    
    return [XJRequest requestWithUrlAddress:urlAddress 
                                 methodType:methodType 
                                     params:mutableParams 
                                   delegate:delegate];
}

+ (XJRequest *)requestWithUrlAddress:(NSString *)urlAddress 
                          methodType:(NSString *)methodType 
                              params:(NSDictionary *)params 
                            delegate:(id<XJRequestDelegate>)delegate
{
    XJRequest *request = [[[XJRequest alloc] init] autorelease];
    
    request.urlAddress = urlAddress;
    request.methodType = methodType;
    request.params = params;
    request.delegate = delegate;
    
    return request;
}

+ (XJRequest *)requestWithUrlAddress:(NSString *)urlAddress 
                          methodType:(NSString *)methodType 
                              params:(NSDictionary *)params
                            fileData:(NSData   *)data 
                            delegate:(id<XJRequestDelegate>)delegate
{
    XJRequest *request = [[[XJRequest alloc] init] autorelease];
    
    request.urlAddress = urlAddress;
    request.methodType = methodType;
    request.params = params;
    request.fileData = data;
    request.delegate = delegate;
    
    return request;
}

+ (XJRequest *)requestWithUrlAddress:(NSString *)urlAddress 
                          methodType:(NSString *)methodType 
                              params:(NSDictionary *)params
                            filePath:(NSString *)filePath 
                            delegate:(id<XJRequestDelegate>)delegate
{
    XJRequest *request = [[[XJRequest alloc] init] autorelease];
    
    request.urlAddress = urlAddress;
    request.methodType = methodType;
    request.params = params;
    request.filePath = filePath;
    request.delegate = delegate;
    
    return request;
}

+ (NSString *)serializeURLAddress:(NSString *)baseURLAddress params:(NSDictionary *)params methodType:(NSString *)methodType
{
    if (![methodType isEqualToString:@"GET"]) 
    {
        return baseURLAddress;
    }
    
    NSURL *parsedURL = [NSURL URLWithString:baseURLAddress];
	NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString *query = [XJRequest stringFromDictionary:params];
	
	return [NSString stringWithFormat:@"%@%@%@", baseURLAddress, queryPrefix, query];
}

- (void)connect
{
    NSString *urlString = [XJRequest serializeURLAddress:urlAddress params:params methodType:methodType];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] 
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                                       timeoutInterval:60.0];
    [request addValue:[[User currentUser] cookie] forHTTPHeaderField:@"Cookie"];
    [request setHTTPMethod:methodType];
    
    if (![methodType isEqualToString:@"GET"])
    {
        [request setHTTPBody:[self postBody]];
    }
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)upload
{
    NSString *urlString = [XJRequest serializeURLAddress:urlAddress params:params methodType:methodType];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:[[User currentUser] cookie] forHTTPHeaderField:@"Cookie"];
    [urlRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDRY] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postData = [NSMutableData dataWithCapacity:[fileData length] + 512];
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.bin\"\r\n\r\n", FORM_FLE_INPUT] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:fileData];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest setHTTPBody:postData];
    
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
}

- (void)uploadSoundFile
{
    NSString *urlString = [XJRequest serializeURLAddress:urlAddress params:params methodType:methodType];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:[[User currentUser] cookie] forHTTPHeaderField:@"Cookie"];
    [urlRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDRY] forHTTPHeaderField:@"Content-Type"];
    
    NSData *soundData = [NSData dataWithContentsOfFile:filePath];
    NSData *data = [GTMBase64 encodeData:soundData];
    //[urlRequest setHTTPBody:data];
    
    NSMutableData *postData = [NSMutableData dataWithCapacity:[fileData length] + 512];
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.bin\"\r\n\r\n", FORM_FLE_INPUT] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:data];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest setHTTPBody:postData];
    
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
}

- (void)disconnect
{
    [responseData release];
	responseData = nil;
    
    [connection cancel];
    [connection release], connection = nil;
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	responseData = [[NSMutableData alloc] init];
    self.httpResponse = (NSHTTPURLResponse *)response;
    
    NSDictionary *fields = [httpResponse allHeaderFields];
    NSString *cookie = [fields valueForKey:@"Set-Cookie"];
    
    if (cookie) {
        [[User currentUser] setCookie:[[cookie componentsSeparatedByString:@";"] objectAtIndex:0]] ;
    } if ([delegate respondsToSelector:@selector(request:didReceiveResponse:)]) {
		[delegate request:self didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse*)cachedResponse 
{
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
	[self handleResponseData:responseData];
    [self disconnect];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
	[self failedWithError:error];
	[self disconnect];
    
    NSString *dataString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"connection failed:%@", dataString);
}

@end
