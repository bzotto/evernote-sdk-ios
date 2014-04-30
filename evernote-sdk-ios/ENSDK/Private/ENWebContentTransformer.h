//
//  ENWebContentTransformer.h
//  WebClipTest
//
//  Created by Steve White on 4/28/14.
//  Copyright (c) 2014 Evernote Corporator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENWebContentTransformer : NSValueTransformer

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *mimeType;
@property (strong, nonatomic) NSURL *baseURL;

@end
