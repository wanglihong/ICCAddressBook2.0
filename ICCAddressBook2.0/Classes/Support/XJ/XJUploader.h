//
//  XJUploader.h
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJUploader : NSObject {
    NSURL *serverURL;
    NSString *filePath;
    id delegate;
    SEL doneSelector;
    SEL errorSelector;
    
    BOOL uploadDidSucceed;
}

-   (id)initWithURL: (NSURL *)serverURL
           filePath: (NSString *)filePath
           delegate: (id)delegate
       doneSelector: (SEL)doneSelector
      errorSelector: (SEL)errorSelector;

-   (NSString *)filePath;

@end