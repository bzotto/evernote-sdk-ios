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

#import "ENSaveToEvernoteActivity.h"
#import "ENSaveToEvernoteViewController.h"
#import "ENSDK.h"

@interface ENSaveToEvernoteActivity () <ENSendToEvernoteViewControllerDelegate>
@property (nonatomic, strong) ENNote * preparedNote;
@property (nonatomic, strong) NSArray * notebooks;
@end

@implementation ENSaveToEvernoteActivity
+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}

- (NSString *)activityType
{
    return @"com.evernote.sdk.activity";
}

- (NSString *)activityTitle
{
    return NSLocalizedString(@"Save to Evernote", @"Save to Evernote");
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"ENSDKResources.bundle/ENActivityIcon"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    // A prepared ENNote is allowed if it's the only item given.
    if (activityItems.count == 1 && [activityItems[0] isKindOfClass:[ENNote class]]) {
        return YES;
    }

    for (id item in activityItems) {
        if ([item isKindOfClass:[NSString class]] ||
            [item isKindOfClass:[UIImage class]] ||
            [item isKindOfClass:[ENResource class]]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSMutableArray * strings = [NSMutableArray array];
    NSMutableArray * images = [NSMutableArray array];
    NSMutableArray * resources = [NSMutableArray array];
    
    if (activityItems.count == 1 && [activityItems[0] isKindOfClass:[ENNote class]]) {
        self.preparedNote = activityItems[0];
        return;
    }
    
    for (id item in activityItems) {
        if ([item isKindOfClass:[NSString class]]) {
            [strings addObject:item];
        } else if ([item isKindOfClass:[UIImage class]]) {
            [images addObject:item];
        } else if ([item isKindOfClass:[ENResource class]]) {
            [resources addObject:item];
        }
    }
    
    NSMutableString * content = [NSMutableString string];
    for (NSUInteger i = 0; i < strings.count; i++) {
        if (i > 0) {
            [content appendString:@"\n"];
        }
        [content appendString:strings[i]];
    }
    
    ENNote * note = [[ENNote alloc] init];
    note.content = [ENNoteContent noteContentWithString:content];
    
    // Add prebaked resources
    for (ENResource * resource in resources) {
        [note addResource:resource];
    }
    
    // Turn images into resources
    for (UIImage * image in images) {
        ENResource * imageResource = [[ENResource alloc] initWithImage:image];
        [note addResource:imageResource];
    }
    
    self.preparedNote = note;
}

- (UIViewController *)activityViewController
{
    ENSaveToEvernoteViewController * s2a = [[ENSaveToEvernoteViewController alloc] init];
    s2a.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:s2a];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    return nav;
}

#pragma mark - ENSendToEvernoteViewControllerDelegate

- (ENNote *)noteForViewController:(ENSaveToEvernoteViewController *)viewController
{
    return self.preparedNote;
}

- (NSString *)defaultNoteTitleForViewController:(ENSaveToEvernoteViewController *)viewController
{
    return self.noteTitle;
}

- (void)viewController:(ENSaveToEvernoteViewController *)viewController didFinishWithSuccess:(BOOL)success
{
    [self activityDidFinish:success];
}
@end
