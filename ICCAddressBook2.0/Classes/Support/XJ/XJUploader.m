//
//  XJUploader.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XJUploader.h"
#import "User.h"

static NSString * const BOUNDRY = @"0xKhTmLbOuNdArY";
static NSString * const FORM_FLE_INPUT = @"uploaded";

#define ASSERT(x) NSAssert(x, @"")

@interface XJUploader (Private)

- (void)upload;
- (NSURLRequest *)postRequestWithURL: (NSURL *)url
                             boundry: (NSString *)boundry
                                data: (NSData *)data;
- (NSData *)compress: (NSData *)data;
- (void)uploadSucceeded: (BOOL)success;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end

@implementation XJUploader

/*
 *-----------------------------------------------------------------------------
 *
 * -[Uploader initWithURL:filePath:delegate:doneSelector:errorSelector:] --
 *
 *      Initializer. Kicks off the upload. Note that upload will happen on a
 *      separate thread.
 *
 * Results:
 *      An instance of Uploader.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (id)initWithURL: (NSURL *)aServerURL   // IN
         filePath: (NSString *)aFilePath // IN
         delegate: (id)aDelegate         // IN
     doneSelector: (SEL)aDoneSelector    // IN
    errorSelector: (SEL)anErrorSelector  // IN
{
    if ((self = [super init])) {
        ASSERT(aServerURL);
        ASSERT(aFilePath);
        ASSERT(aDelegate);
        ASSERT(aDoneSelector);
        ASSERT(anErrorSelector);
        
        serverURL = [aServerURL retain];
        filePath = [aFilePath retain];
        delegate = [aDelegate retain];
        doneSelector = aDoneSelector;
        errorSelector = anErrorSelector;
        
        [self upload];
    }
    return self;
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[Uploader dealloc] --
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
    [serverURL release];
    serverURL = nil;
    [filePath release];
    filePath = nil;
    [delegate release];
    delegate = nil;
    doneSelector = NULL;
    errorSelector = NULL;
    
    [super dealloc];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[Uploader filePath] --
 *
 *      Gets the path of the file this object is uploading.
 *
 * Results:
 *      Path to the upload file.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (NSString *)filePath
{
    return filePath;
}

@end // Uploader

@implementation XJUploader (Private)

/*
 *-----------------------------------------------------------------------------
 *
 * -[Uploader(Private) upload] --
 *
 *      Uploads the given file. The file is compressed before beign uploaded.
 *      The data is uploaded using an HTTP POST command.
 *
 * Results:
 *      None
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)upload
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    ASSERT(data);
    if (!data) {
        [self uploadSucceeded:NO];
        return;
    }
    if ([data length] == 0) {
        // There's no data, treat this the same as no file.
        [self uploadSucceeded:YES];
        return;
    }
    
    //  NSData *compressedData = [self compress:data];
    //  ASSERT(compressedData &amp;&amp; [compressedData length] != 0);
    //  if (!compressedData || [compressedData length] == 0) {
    //      [self uploadSucceeded:NO];
    //      return;
    //  }
    
    NSURLRequest *urlRequest = [self postRequestWithURL:serverURL
                                                boundry:BOUNDRY
                                                   data:data];
    if (!urlRequest) {
        [self uploadSucceeded:NO];
        return;
    }
    
    NSURLConnection * connection =
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    if (!connection) {
        [self uploadSucceeded:NO];
    }
    
    // Now wait for the URL connection to call us back.
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[Uploader(Private) postRequestWithURL:boundry:data:] --
 *
 *      Creates a HTML POST request.
 *
 * Results:
 *      The HTML POST request.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (NSURLRequest *)postRequestWithURL: (NSURL *)url        // IN
                             boundry: (NSString *)boundry // IN
                                data: (NSData *)data      // IN
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:[[User currentUser] cookie] forHTTPHeaderField:@"Cookie"];
    [urlRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postData = [NSMutableData dataWithCapacity:[data length] + 512];
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.bin\"\r\n\r\n", FORM_FLE_INPUT] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:data];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest setHTTPBody:postData];
    
    return urlRequest;
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[Uploader(Private) compress:] --
 *
 *      Uses zlib to compress the given data.
 *
 * Results:
 *      The compressed data as a NSData object.
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (NSData *)compress: (NSData *)data // IN
{/*
    if (!data || [data length] == 0)
        return nil;
    
    // zlib compress doc says destSize must be 1% + 12 bytes greater than source.
    ulong destSize = [data length] * 1.001 + 12;
    NSMutableData *destData = [NSMutableData dataWithLength:destSize];
    
    int error = compress([destData mutableBytes],
                         &amp;destSize,
                         [data bytes],
                         [data length]);
    if (error != Z_OK) {
        NSLog(@"%s: self:0x%p, zlib error on compress:%d\n",__func__, self, error);
        return nil;
    }
    
    [destData setLength:destSize];
    return destData;*/
    return nil;
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[Uploader(Private) uploadSucceeded:] --
 *
 *      Used to notify the delegate that the upload did or did not succeed.
 *
 * Results:
 *      None
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)uploadSucceeded: (BOOL)success // IN
{
    [delegate performSelector:success ? doneSelector : errorSelector
                   withObject:self];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[Uploader(Private) connectionDidFinishLoading:] --
 *
 *      Called when the upload is complete. We judge the success of the upload
 *      based on the reply we get from the server.
 *
 * Results:
 *      None
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)connectionDidFinishLoading:(NSURLConnection *)connection // IN
{
    NSLog(@"%s: self:0x%p\n", __func__, self);
    [connection release];
    [self uploadSucceeded:uploadDidSucceed];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[Uploader(Private) connection:didFailWithError:] --
 *
 *      Called when the upload failed (probably due to a lack of network
 *      connection).
 *
 * Results:
 *      None
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)connection:(NSURLConnection *)connection // IN
  didFailWithError:(NSError *)error              // IN
{
    NSLog(@"%s: self:0x%p, connection error:%s\n",
          __func__, self, [[error description] UTF8String]);
    [connection release];
    [self uploadSucceeded:NO];
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[Uploader(Private) connection:didReceiveResponse:] --
 *
 *      Called as we get responses from the server.
 *
 * Results:
 *      None
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

-(void)       connection:(NSURLConnection *)connection // IN
      didReceiveResponse:(NSURLResponse *)response     // IN
{
    NSLog(@"%s: self:0x%p\n", __func__, self);
}

/*
 *-----------------------------------------------------------------------------
 *
 * -[Uploader(Private) connection:didReceiveData:] --
 *
 *      Called when we have data from the server. We expect the server to reply
 *      with a "YES" if the upload succeeded or "NO" if it did not.
 *
 * Results:
 *      None
 *
 * Side effects:
 *      None
 *
 *-----------------------------------------------------------------------------
 */

- (void)connection:(NSURLConnection *)connection // IN
    didReceiveData:(NSData *)data                // IN
{
    NSLog(@"%s: self:0x%p\n", __func__, self);
    
    NSString *reply = [[[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding]
                       autorelease];
    NSLog(@"%s: data: %s\n", __func__, [reply UTF8String]);
    
    if ([reply hasPrefix:@"YES"]) {
        uploadDidSucceed = YES;
    }
}

@end
