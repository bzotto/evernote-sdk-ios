//
//  ENWebClipActivity.h
//  WebClipTest
//
//  Created by Steve White on 4/28/14.
//  Copyright (c) 2014 Evernote Corporator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ENNote;

@interface ENWebClipNoteBuilder : NSObject
- (id)initWithUrl:(NSURL *)url;
- (id)initWithWebView:(UIWebView *)webView;
- (void)buildNote:(void(^)(ENNote *))completion;
@end
