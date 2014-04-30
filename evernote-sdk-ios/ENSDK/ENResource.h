//
//  ENResource.h
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 2/25/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ENResource : NSObject
@property (nonatomic, strong) NSData * data;
@property (nonatomic, copy) NSString * mimeType;
@property (nonatomic, copy) NSString * filename;
- (id)initWithData:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename;
- (id)initWithData:(NSData *)data mimeType:(NSString *)mimeType;
- (id)initWithImage:(UIImage *)image;
@end
