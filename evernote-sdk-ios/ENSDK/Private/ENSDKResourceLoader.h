//
//  ENSDKResourceLoader.h
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 4/25/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENSDKResourceLoader : NSObject
+ (NSString *)pathToResourceNamed:(NSString *)name extension:(NSString *)extension;
@end
