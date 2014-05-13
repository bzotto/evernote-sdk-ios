//
//  ENLinkedNotebookRef.h
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 3/13/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EDAMTypes.h"

// This object contains the minimum information required to authenticate to a shared notebook.
// It is intentionally narrower than a full EDAMLinkedNotebook, allowing these general bits of information
// to be persisted independently of a full EDAMLinkedNotebook.
@interface ENLinkedNotebookRef : NSObject <NSCoding>
@property (nonatomic, strong) NSString * guid;
@property (nonatomic, strong) NSString * noteStoreUrl;
@property (nonatomic, strong) NSString * shardId;
@property (nonatomic, strong) NSString * sharedNotebookGlobalId;
+ (ENLinkedNotebookRef *)linkedNotebookRefFromLinkedNotebook:(EDAMLinkedNotebook *)linkedNotebook;
@end
