//
//  ENWebArchive.m
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 4/30/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "ENWebArchive.h"

NSString * const ENWebArchivePboardType = @"Apple Web Archive pasteboard type";

static NSString * const ENWebArchiveDictionaryMainResourceKey = @"WebMainResource";
static NSString * const ENWebArchiveDictionarySubresourcesKey = @"WebSubresources";
static NSString * const ENWebArchiveDictionarySubframeArchivesKey = @"WebSubframeArchives";

@interface ENWebArchive ()
@property (nonatomic, strong) ENWebResource * mainResource;
@property (nonatomic, strong) NSArray * subresources;
@property (nonatomic, strong) NSArray * subframeArchives;
@end

@implementation ENWebArchive
+ (ENWebArchive *)webArchiveWithData:(NSData *)data
{
    NSError * error = nil;
    NSDictionary * dictionary = [NSPropertyListSerialization propertyListWithData:data
                                                                          options:NSPropertyListImmutable
                                                                           format:NULL
                                                                            error:&error];
    if (!dictionary) {
        NSLog(@"Error deserializing web archive from data: %@", error);
        return nil;
    }

    return [ENWebArchive webArchiveWithDictionary:dictionary];
}

+ (ENWebArchive *)webArchiveWithDictionary:(NSDictionary *)dictionary
{
    NSDictionary * mainResourceDict = dictionary[ENWebArchiveDictionaryMainResourceKey];
    NSArray * subresourcesArray = dictionary[ENWebArchiveDictionarySubresourcesKey];
    NSArray * subframeArchivesArray = dictionary[ENWebArchiveDictionarySubframeArchivesKey];
    
    NSMutableArray * subresources = [[NSMutableArray alloc] init];
    for (NSDictionary * subresourceDict in subresourcesArray) {
        [subresources addObject:[ENWebResource webResourceWithDictionary:subresourceDict]];
    }
    NSMutableArray * subframeArchives = [[NSMutableArray alloc] init];
    for (NSDictionary * subframeArchiveDict in subframeArchivesArray) {
        [subframeArchives addObject:[ENWebArchive webArchiveWithDictionary:subframeArchiveDict]];
    }
    return [[ENWebArchive alloc] initWithMainResource:[ENWebResource webResourceWithDictionary:mainResourceDict]
                                         subresources:subresources
                                     subframeArchives:subframeArchives];
}

- (id)initWithMainResource:(ENWebResource *)mainResource
              subresources:(NSArray *)subresources
          subframeArchives:(NSArray *)subframeArchives
{
    self = [super init];
    if (self) {
        self.mainResource = mainResource;
        self.subresources = subresources;
        self.subframeArchives = subframeArchives;
    }
    return self;
}
@end
