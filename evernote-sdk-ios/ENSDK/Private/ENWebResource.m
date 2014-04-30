//
//  ENWebResource.m
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 4/30/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "ENWebResource.h"

static NSString * const ENWebResourceDictionaryDataKey = @"WebResourceData";
static NSString * const ENWebResourceDictionaryURLKey = @"WebResourceURL";
static NSString * const ENWebResourceDictionaryMIMETypeKey = @"WebResourceMIMEType";
static NSString * const ENWebResourceDictionaryTextEncodingNameKey = @"WebResourceTextEncodingName";
static NSString * const ENWebResourceDictionaryFrameNameKey = @"WebResourceFrameName";

@interface ENWebResource ()
@property (nonatomic, strong) NSData * data;
@property (nonatomic, strong) NSURL * URL;
@property (nonatomic, copy) NSString * MIMEType;
@property (nonatomic, copy) NSString * textEncodingName;
@property (nonatomic, copy) NSString * frameName;
@end

@implementation ENWebResource
+ (ENWebResource *)webResourceWithDictionary:(NSDictionary *)dictionary
{
    return [[ENWebResource alloc] initWithData:dictionary[ENWebResourceDictionaryDataKey]
                                           URL:[NSURL URLWithString:dictionary[ENWebResourceDictionaryURLKey]]
                                      MIMEType:dictionary[ENWebResourceDictionaryMIMETypeKey]
                              textEncodingName:dictionary[ENWebResourceDictionaryTextEncodingNameKey]
                                     frameName:dictionary[ENWebResourceDictionaryFrameNameKey]];
}

- (id)initWithData:(NSData *)data URL:(NSURL *)URL MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName frameName:(NSString *)frameName
{
    self = [super init];
    if (self) {
        self.data = data;
        self.URL = URL;
        self.MIMEType = MIMEType;
        self.textEncodingName = textEncodingName;
        self.frameName = frameName;
    }
    return self;
}
@end
