//
//  ENSDKResourceLoader.m
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 4/25/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "ENSDKResourceLoader.h"
#import "ENSDKPrivate.h"

@implementation ENSDKResourceLoader
+ (NSString *)pathToResourceNamed:(NSString *)name extension:(NSString *)extension
{
    NSBundle * bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ENSDKResources" ofType:@"bundle"]];
    NSString * path = [bundle pathForResource:name ofType:extension];
    if (!path) {
        ENSDKLogError(@"Failed to load resource from ENSDKResources.bundle. Is it included in your app?");
    }
    return path;
}
@end
