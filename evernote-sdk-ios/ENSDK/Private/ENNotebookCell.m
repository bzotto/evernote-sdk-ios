//
//  ENNotebookCell.m
//  evernote-sdk-ios
//
//  Created by Eric Cheng on 4/21/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "ENNotebookCell.h"
#import "ENTheme.h"

@implementation ENNotebookCell

#define kIconTintColor  [UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1]
#define kCellInsetLeft  38.0

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [self.textLabel setTextColor:[UIColor colorWithRed:25.0 / 255.0 green:25.0 / 255.0 blue:25.0 / 255.0 alpha:1.0]];
        [self.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0]];
        [self.detailTextLabel setTextColor:[UIColor colorWithRed:93.0 / 255.0 green:93.0 / 255.0 blue:93.0 / 255.0 alpha:1.0]];
        [self setSeparatorInset:UIEdgeInsetsMake(0.0, kCellInsetLeft, 0.0, 0.0)];
        self.checkButton = [[UIButton alloc] init];
        [self.contentView addSubview:self.checkButton];
        [self.checkButton setImage:[[UIImage imageNamed:@"ENSDKResources.bundle/ENCheckIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.checkButton sizeToFit];
        [self.checkButton setTintColor:[ENTheme defaultTintColor]];
        [self.checkButton setCenter:CGPointMake(0.6 * kCellInsetLeft, CGRectGetMidY(self.bounds) + 1.0)];
        [self.checkButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [self.checkButton setHidden:YES];
    }
    return self;
}

- (UIImageView *)businessImageAccessoryView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ENSDKResources.bundle/ENBusinessIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [imageView setTintColor:kIconTintColor];
    return imageView;
}

- (UIImageView *)sharedImageAccessoryView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ENSDKResources.bundle/ENMultiplePeopleIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [imageView setTintColor:kIconTintColor];
    return imageView;
}

- (void)setNotebook:(ENNotebook *)notebook {
    [self.textLabel setText:notebook.name];
    if ([notebook isBusinessNotebook] || ![notebook isOwnedByUser]) {
        [self.detailTextLabel setText:notebook.ownerDisplayName];
    } else {
        [self.detailTextLabel setText:nil];
    }
    if ([notebook isBusinessNotebook]) {
        [self setAccessoryView:[self businessImageAccessoryView]];
    } else if ([notebook isShared]) {
        [self setAccessoryView:[self sharedImageAccessoryView]];
    } else {
        [self setAccessoryView:nil];
    }
}

- (void)setIsCurrentNotebook:(BOOL)isCurrentNotebook {
    if (_isCurrentNotebook == isCurrentNotebook) return;
    _isCurrentNotebook = isCurrentNotebook;
    [self.checkButton setHidden:!_isCurrentNotebook];
}

@end
