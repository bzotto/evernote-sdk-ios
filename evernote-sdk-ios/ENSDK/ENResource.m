//
//  ENResource.m
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 2/25/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "ENSDKPrivate.h"
#import "NSData+EvernoteSDK.h"

@interface ENResource ()
@property (nonatomic, copy) NSString * sourceUrl;
@property (nonatomic, strong) NSString * guid;
@property (nonatomic, strong) NSData * dataHash;
@end

@implementation ENResource
- (id)initWithData:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename
{
    self = [super init];
    if (self) {
        self.data = data;
        self.mimeType = mimeType;
        self.filename = filename;

        if (!self.data) {
            return nil;
        }
    }
    return self;
}

- (id)initWithData:(NSData *)data mimeType:(NSString *)mimeType
{
    return [self initWithData:data mimeType:mimeType filename:nil];
}

- (id)initWithImage:(UIImage *)image
{
    // Encode both ways and use the smaller of the two. Ties goes to (lossless) PNG.
    NSData * pngData = UIImagePNGRepresentation(image);
    NSData * jpegData = UIImageJPEGRepresentation(image, 0.7);
    if (jpegData.length < pngData.length) {
        pngData = nil;
        return [self initWithData:jpegData mimeType:[EDAMLimitsConstants EDAM_MIME_TYPE_JPEG]];
    } else {
        jpegData = nil;
        return [self initWithData:pngData mimeType:[EDAMLimitsConstants EDAM_MIME_TYPE_PNG]];
    }
}

- (void)setData:(NSData *)data
{
    if (data && data.length >= INT32_MAX) {
        ENSDKLogError(@"Data length for resource is greater than int32.");
        data = nil;
    }

    self.dataHash = nil;
    _data = data;
}

- (NSData *)dataHash
{
    // Compute and cache the hash value.
    if (!_dataHash && self.data.length > 0) {
        _dataHash = [self.data enmd5];
    }
    return _dataHash;
}

- (EDAMResource *)EDAMResource
{
    if (!self.data) {
        return nil;
    }
    
    EDAMResource * resource = [[EDAMResource alloc] init];
    resource.guid = self.guid;
    if (!resource.guid && self.data) {
        resource.data = [[EDAMData alloc] init];
        resource.data.bodyHash = self.dataHash;
        resource.data.size = @(self.data.length);
        resource.data.body = self.data;
    }
    resource.mime = self.mimeType;
    EDAMResourceAttributes * attributes = [[EDAMResourceAttributes alloc] init];
    if (self.filename) {
        attributes.fileName = self.filename;
    }
    if (self.sourceUrl) {
        attributes.sourceURL = self.sourceUrl;
    }
    resource.attributes = attributes;

    return resource;
}
@end
