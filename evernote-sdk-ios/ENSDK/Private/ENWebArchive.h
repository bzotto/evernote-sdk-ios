//
//  ENWebArchive.h
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 4/30/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ENWebResource.h"

extern NSString * const ENWebArchivePboardType;
extern NSString * const ENWebArchiveDataMIMEType;

@interface ENWebArchive : NSObject
+ (ENWebArchive *)webArchiveWithData:(NSData *)data;
- (id)initWithMainResource:(ENWebResource *)mainResource
              subresources:(NSArray *)subresources
          subframeArchives:(NSArray *)subframeArchives;
- (ENWebResource *)mainResource;
- (NSArray *)subresources;
- (NSArray *)subframeArchives;

- (NSData *)data;
@end
