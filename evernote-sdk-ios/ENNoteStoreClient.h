//
//  ENNoteStoreClient.h
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 3/11/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ENStoreClient.h"
#import "EvernoteSDK.h"
#import "ENLinkedNotebookRef.h"

@protocol ENNoteStoreClientDelegate <NSObject>
- (NSString *)authenticationTokenForLinkedNotebookRef:(ENLinkedNotebookRef *)linkedNotebookRef;
@end

@interface ENNoteStoreClient : ENStoreClient
@property (nonatomic, weak) id<ENNoteStoreClientDelegate> noteStoreDelegate;
+ (ENNoteStoreClient *)noteStoreClientWithUrl:(NSString *)url authenticationToken:(NSString *)authenticationToken;
+ (ENNoteStoreClient *)noteStoreClientForLinkedNotebookRef:(ENLinkedNotebookRef *)linkedNotebookRef;

// N.B. This method is synchronous and can throw exceptions.
// Should be called only from within protected code blocks
- (EDAMAuthenticationResult *)authenticateToSharedNotebookWithShareKey:(NSString *)shareKey;

// Async API wrappers
- (void)listNotebooksWithSuccess:(void(^)(NSArray *notebooks))success
                         failure:(void(^)(NSError *error))failure;
- (void)getNotebookWithGuid:(EDAMGuid)guid
                    success:(void(^)(EDAMNotebook *notebook))success
                    failure:(void(^)(NSError *error))failure;
- (void)createNotebook:(EDAMNotebook *)notebook
               success:(void(^)(EDAMNotebook *notebook))success
               failure:(void(^)(NSError *error))failure;
- (void)listLinkedNotebooksWithSuccess:(void(^)(NSArray *linkedNotebooks))success
                               failure:(void(^)(NSError *error))failure;
- (void)getSharedNotebookByAuthWithSuccess:(void(^)(EDAMSharedNotebook *sharedNotebook))success
                                   failure:(void(^)(NSError *error))failure;
- (void)shareNoteWithGuid:(EDAMGuid)guid
                  success:(void(^)(NSString *noteKey))success
                  failure:(void(^)(NSError *error))failure;
- (void)createNote:(EDAMNote *)note
           success:(void(^)(EDAMNote *note))success
           failure:(void(^)(NSError *error))failure;
- (void)updateNote:(EDAMNote *)note
           success:(void(^)(EDAMNote *note))success
           failure:(void(^)(NSError *error))failure;
- (void)deleteNoteWithGuid:(EDAMGuid)guid
                   success:(void(^)(int32_t usn))success
                   failure:(void(^)(NSError *error))failure;



@end
