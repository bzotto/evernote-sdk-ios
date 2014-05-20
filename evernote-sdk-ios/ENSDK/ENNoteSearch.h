//
//  ENNoteSearch.h
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 5/15/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENNoteSearch : NSObject
@property (nonatomic, readonly) NSString * searchString;
+ (ENNoteSearch *)noteSearchWithSearchString:(NSString *)searchString;
+ (ENNoteSearch *)noteSearchCreatedByThisApplication;
- (id)initWithSearchString:(NSString *)searchString;
@end
