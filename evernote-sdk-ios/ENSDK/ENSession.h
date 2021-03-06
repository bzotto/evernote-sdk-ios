/*
 * Copyright (c) 2014 by Evernote Corporation, All rights reserved.
 *
 * Use of the source code and binary libraries included in this package
 * is permitted under the following terms:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ENSDK.h"
#import "ENSDKLogging.h"

FOUNDATION_EXPORT NSString * const ENSessionHostSandbox;

FOUNDATION_EXPORT NSString * const ENSessionDidAuthenticateNotification;
FOUNDATION_EXPORT NSString * const ENSessionDidUnauthenticateNotification;

typedef void (^ENSessionAuthenticateCompletionHandler)(NSError * authenticateError);
typedef void (^ENSessionListNotebooksCompletionHandler)(NSArray * notebooks, NSError * listNotebooksError);
typedef void (^ENSessionUploadNoteProgressHandler)(CGFloat progress);
typedef void (^ENSessionUploadNoteCompletionHandler)(ENNoteRef * noteRef, NSError * uploadNoteError);
typedef void (^ENSessionShareNoteCompletionHandler)(NSString * url, NSError * shareNoteError);
typedef void (^ENSessionDeleteNoteCompletionHandler)(NSError * deleteNoteError);
typedef void (^ENSessionFindNotesCompletionHandler)(NSArray * findNotesResults, NSError * findNotesError);
typedef void (^ENSessionDownloadNoteCompletionHandler)(ENNote * note, NSError * downloadNoteError);
typedef void (^ENSessionDownloadNoteThumbnailCompletionHandler)(UIImage * thumbnail, NSError * downloadNoteThumbnailError);

typedef NS_ENUM(NSInteger, ENSessionUploadPolicy) {
    ENSessionUploadPolicyCreate,
    ENSessionUploadPolicyReplace,
    ENSessionUploadPolicyReplaceOrCreate
};

typedef NS_OPTIONS(NSUInteger, ENSessionSearchScope) {
    ENSessionSearchScopeNone                = 0,      // only useful if specifying a notebook instead.
    ENSessionSearchScopePersonal            = 1 << 0,
    ENSessionSearchScopePersonalLinked      = 1 << 1,
    ENSessionSearchScopeBusiness            = 1 << 2
};
extern NSUInteger ENSessionSearchScopeDefault; // => ENSessionSearchScopePersonal
extern NSUInteger ENSessionSearchScopeAll;     // ! Performance warning. !

typedef NS_OPTIONS(NSUInteger, ENSessionSortOrder) {
    ENSessionSortOrderTitle                 = 1 << 0,
    ENSessionSortOrderRecentlyCreated       = 1 << 1,
    ENSessionSortOrderRecentlyUpdated       = 1 << 2,
    ENSessionSortOrderRelevance             = 1 << 3,  // only valid when using a single search scope
    
    ENSessionSortOrderNormal                = 0 << 16, // default
    ENSessionSortOrderReverse               = 1 << 16
};
extern NSUInteger ENSessionSortOrderDefault; // => ENSessionSortOrderTitle

// Result record for findNotes call.
@interface ENSessionFindNotesResult : NSObject
@property (nonatomic, strong) ENNoteRef * noteRef;
@property (nonatomic, strong) ENNotebook * notebook;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSDate * created;
@property (nonatomic, strong) NSDate * updated;
@end

@interface ENSession : NSObject
@property (nonatomic, strong) id<ENSDKLogging> logger;
@property (nonatomic, copy) NSString * sourceApplication;  

@property (nonatomic, readonly) BOOL isAuthenticated;
@property (nonatomic, readonly) BOOL isAuthenticationInProgress;

@property (nonatomic, readonly) BOOL isPremiumUser;
@property (nonatomic, readonly) BOOL isBusinessUser;
@property (nonatomic, readonly) NSString * userDisplayName;
@property (nonatomic, readonly) NSString * businessDisplayName;

// One of the two methods below MUST be called, BEFORE the shared session is accessed.
// In your AppDelegate startup code is appropriate. There's no reason to change these
// values at runtime once the Evernote functionality has been used, and in fact doing so
// will have no effect.
+ (void)setSharedSessionConsumerKey:(NSString *)key
                     consumerSecret:(NSString *)secret
                       optionalHost:(NSString *)host;

+ (void)setSharedSessionDeveloperToken:(NSString *)token
                          noteStoreUrl:(NSString *)url;

+ (ENSession *)sharedSession;

//
// Authentication functions.
//

- (void)authenticateWithViewController:(UIViewController *)viewController
                            completion:(ENSessionAuthenticateCompletionHandler)completion;
- (void)unauthenticate;

// To be called from your AppDelegate's -application:openURL:sourceApplication:annotation:
- (BOOL)handleOpenURL:(NSURL *)url;

//
// Evernote functions.
//

- (void)listNotebooksWithHandler:(ENSessionListNotebooksCompletionHandler)completion;

// Easy convenience method for creating new notes.
- (void)uploadNote:(ENNote *)note
          notebook:(ENNotebook *)notebook
        completion:(ENSessionUploadNoteCompletionHandler)completion;

// Use the full method if you want to track progress, overwrite existing notes, etc.
- (void)uploadNote:(ENNote *)note
            policy:(ENSessionUploadPolicy)policy
        toNotebook:(ENNotebook *)notebook
     orReplaceNote:(ENNoteRef *)noteToReplace
          progress:(ENSessionUploadNoteProgressHandler)progress
        completion:(ENSessionUploadNoteCompletionHandler)completion;

- (void)shareNote:(ENNoteRef *)noteRef
       completion:(ENSessionShareNoteCompletionHandler)completion;

- (void)deleteNote:(ENNoteRef *)noteRef
        completion:(ENSessionDeleteNoteCompletionHandler)completion;

- (void)findNotesWithSearch:(ENNoteSearch *)noteSearch
                 inNotebook:(ENNotebook *)notebook
                    orScope:(ENSessionSearchScope)scope
                  sortOrder:(ENSessionSortOrder)sortOrder
                 completion:(ENSessionFindNotesCompletionHandler)completion;

- (void)downloadNote:(ENNoteRef *)noteRef
          completion:(ENSessionDownloadNoteCompletionHandler)completion;

- (void)downloadThumbnailForNote:(ENNoteRef *)noteRef
                    maxDimension:(NSUInteger)maxDimension
                      completion:(ENSessionDownloadNoteThumbnailCompletionHandler)completion;

@end
