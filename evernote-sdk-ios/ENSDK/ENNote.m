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

#import "ENSDKPrivate.h"
#import "NSString+ENScrubbing.h"
#import "ENWebClipNoteBuilder.h"

#pragma mark - ENNote

@interface ENNote ()
{
    NSMutableArray * _resources;
}
@property (nonatomic, copy) NSString * sourceUrl;
@property (nonatomic, copy) NSString * cachedENMLContent;
@property (nonatomic, strong) EDAMNote * serviceNote;
@end

@implementation ENNote
- (id)init
{
    self = [super init];
    if (self) {
        _resources = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithServiceNote:(EDAMNote *)note
{
    self = [super init];
    if (self) {
        // Copy the fields that can be edited at this level.
        _title = note.title;
        _content = [ENNoteContent noteContentWithENML:note.content];
        _isReminder = (note.attributes.reminderOrder != nil);
        _sourceUrl = note.attributes.sourceURL;
        _tagNames = note.tagNames;  // This is usually nil, unfortunately, on notes that come from the service.
        
        // Resources to ENResources
        _resources = [[NSMutableArray alloc] init];
        for (EDAMResource * serviceResource in note.resources) {
            ENResource * resource = [ENResource resourceWithServiceResource:serviceResource];
            if (resource) {
                [_resources addObject:resource];
            }
        }

        // Keep a copy of the service note around with all of its extra properties
        // in case we have to convert back to an EDAMNote later.
        self.serviceNote = [note copy];
        
        // Get rid of these references here; they take up memory and we can let them be potentially cleaned up.
        self.serviceNote.content = nil;
        self.serviceNote.resources = nil;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = [title en_scrubUsingRegex:[EDAMLimitsConstants EDAM_NOTE_TITLE_REGEX]
                         withMinLength:[EDAMLimitsConstants EDAM_NOTE_TITLE_LEN_MIN]
                             maxLength:[EDAMLimitsConstants EDAM_NOTE_TITLE_LEN_MAX]];
}

- (void)setContent:(ENNoteContent *)content
{
    [self invalidateCachedENML];
    _content = content;
}

- (void)setTagNames:(NSArray *)tagNames
{
    NSMutableArray * tags = [NSMutableArray array];
    for (NSString * tagName in tagNames) {
        NSString * scrubbedTag = [tagName en_scrubUsingRegex:[EDAMLimitsConstants EDAM_TAG_NAME_REGEX]
                                               withMinLength:[EDAMLimitsConstants EDAM_TAG_NAME_LEN_MIN]
                                                   maxLength:[EDAMLimitsConstants EDAM_TAG_NAME_LEN_MAX]];
        if (scrubbedTag) {
            [tags addObject:scrubbedTag];
        }
    }
    _tagNames = (tags.count > 0) ? tags : nil;
}

- (NSArray *)resources
{
    return _resources;
}

- (void)addResource:(ENResource *)resource
{
    if (resource) {
        if (_resources.count >= (NSUInteger)[EDAMLimitsConstants EDAM_NOTE_RESOURCES_MAX]) {
            ENSDKLogInfo(@"Too many resources already on note. Ignoring %@. Note %@.", resource, self);
        } else {
            [self invalidateCachedENML];
            [_resources addObject:resource];
        }
    }
}

- (void)removeAllResources
{
    [_resources removeAllObjects];
    [self invalidateCachedENML];
}

+ (void)populateNoteFromWebView:(UIWebView *)webView completion:(ENNotePopulateFromWebViewCompletionHandler)completion
{
    if (!completion) {
        ENSDKLogError(@"+populateNoteFromWebView requires a valid completion block");
        return;
    }
    if (!webView) {
        ENSDKLogError(@"+populateNoteFromWebView requires a valid webview");
        completion(nil);
        return;
    }
    
    ENWebClipNoteBuilder * builder = [[ENWebClipNoteBuilder alloc] initWithWebView:webView];
    // The note builder's completion handler has the same signature and behavior as our own, so pass it directly through.
    [builder buildNote:completion];
}

#pragma mark - Protected methods

- (void)invalidateCachedENML
{
    self.cachedENMLContent = nil;
}

- (NSString *)enmlContent
{
    if (!self.cachedENMLContent) {
        self.cachedENMLContent = [self.content enmlWithResources:self.resources];
    }
    return self.cachedENMLContent;
}

- (void)setResources:(NSArray *)resources
{
    _resources = [NSMutableArray arrayWithArray:resources];
}

- (EDAMNote *)EDAMNote
{
    // Turn the ENNote into an EDAMNote. Use the cached EDAMNote as a starting point if we have one.
    EDAMNote * note = nil;
    if (self.serviceNote) {
        note = [self.serviceNote copy];
        // Don't preserve these.
        note.guid = nil;
        note.updateSequenceNum = nil;
    } else {
        note = [[EDAMNote alloc] init];
    }
    
    note.content = [self enmlContent];
    if (!note.content) {
        ENNoteContent * emptyContent = [ENNoteContent noteContentWithString:@""];
        note.content = [emptyContent enmlWithResources:self.resources];
    }
    // Invalidate the derivative content fields.
    note.contentHash = nil;
    note.contentLength = nil;
    
    note.title = self.title;
    if (!note.title) {
        // Only use a dummy title if we couldn't get a real one inside limits.
        note.title = @"Untitled Note";
    }
    
    note.notebookGuid = self.notebook.guid;
    
    // Setup note attributes. Use app bundle name for source application unless the app wants to override.
    if (!note.attributes) {
        note.attributes = [[EDAMNoteAttributes alloc] init];
    }
    NSString * sourceApplication = [[ENSession sharedSession] sourceApplication];

    // Write sourceApplication and source on all notes.
    note.attributes.sourceApplication = sourceApplication;
    // By convention for all iOS based apps.
    note.attributes.source = @"mobile.ios";

    // If reminder is flagged on, set reminderOrder to the current UNIX timestamp by convention.
    // (Preserve existing reminderOrder if present)
    if (!self.isReminder) {
        note.attributes.reminderOrder = nil;
    } else {
        if (!note.attributes.reminderOrder) {
            note.attributes.reminderOrder = @([[NSDate date] timeIntervalSince1970] * 1000.0);
        }
    }
    
    if (self.sourceUrl) {
        note.attributes.sourceURL = self.sourceUrl;
    }
    
    // Move tags over if present.
    if (self.tagNames) {
        note.tagNames = [self.tagNames mutableCopy];
    }
    
    // Turn any ENResources on the note into EDAMResources.
    NSMutableArray * resources = [NSMutableArray array];
    for (ENResource * localResource in self.resources) {
        EDAMResource * resource = [localResource EDAMResource];
        if (resource) {
            [resources addObject:resource];
        }
    }
    
    // Always set the resources array, even if empty. If we end up using this EDAMNote to
    // update an existing note, we always desire the intention of removing any existing resources.
    [note setResources:resources];
    
    return note;
}

- (BOOL)validateForLimits
{
    if (self.enmlContent.length < (NSUInteger)[EDAMLimitsConstants EDAM_NOTE_CONTENT_LEN_MIN] ||
        self.enmlContent.length > (NSUInteger)[EDAMLimitsConstants EDAM_NOTE_CONTENT_LEN_MAX]) {
        ENSDKLogInfo(@"Note fails validation for content length: %@", self);
        return NO;
    }
    
    NSUInteger maxResourceSize = [EDAMLimitsConstants EDAM_RESOURCE_SIZE_MAX_FREE];
    if ([[ENSession sharedSession] isPremiumUser]) {
        maxResourceSize = [EDAMLimitsConstants EDAM_RESOURCE_SIZE_MAX_PREMIUM];
    }
    
    for (ENResource * resource in self.resources) {
        if (resource.data.length > maxResourceSize) {
            ENSDKLogInfo(@"Note fails validation for resource length: %@", self);
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - For private subclasses to override

- (NSString *)generateENMLContent
{
    // This is a no-op in the base class. Subclasses use this entry point to generate ENML from
    // whatever they natively understand.
    return self.enmlContent;
}
@end
