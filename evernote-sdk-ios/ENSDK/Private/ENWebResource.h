//
//  ENWebResource.h
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 4/30/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENWebResource : NSObject
+ (ENWebResource *)webResourceWithDictionary:(NSDictionary *)dictionary;
- (id)initWithData:(NSData *)data
               URL:(NSURL *)URL
          MIMEType:(NSString *)MIMEType
  textEncodingName:(NSString *)textEncodingName
         frameName:(NSString *)frameName;
- (NSData *)data;
- (NSURL *)URL;
- (NSString *)MIMEType;
- (NSString *)textEncodingName;
- (NSString *)frameName;
@end
