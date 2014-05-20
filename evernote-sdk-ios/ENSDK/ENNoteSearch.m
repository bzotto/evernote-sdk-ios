//
//  ENNoteSearch.m
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 5/15/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "ENNoteSearch.h"
#import "ENSession.h"

@interface ENNoteSearch ()
@property (nonatomic, strong) NSString * searchString;
@end

@implementation ENNoteSearch
+ (ENNoteSearch *)noteSearchWithSearchString:(NSString *)searchString
{
    return [[ENNoteSearch alloc] initWithSearchString:searchString];
}

+ (ENNoteSearch *)noteSearchCreatedByThisApplication
{
    NSString * search = [NSString stringWithFormat:@"sourceApplication:%@", [[ENSession sharedSession] sourceApplication]];
    return [[ENNoteSearch alloc] initWithSearchString:search];
}

- (id)initWithSearchString:(NSString *)searchString
{
    self = [super init];
    if (self) {
        self.searchString = [searchString copy];
    }
    return self;
}
@end
