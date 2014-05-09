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

#define COLOR_NOTEBOOK_SHARED_LABEL [UIColor colorWithRed:45.0/255 green:190.0/255 blue:96.0/255 alpha:1]
#define COLOR_NOTEBOOK_BUSINESS_LABEL [UIColor colorWithRed:77.0/255 green:129.0/255 blue:140.0/255 alpha:1]
#define kIconTintColor  [UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1]
#define kCellInsetLeft  38.0

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [self.textLabel setTextColor:[UIColor colorWithRed:25.0 / 255.0 green:25.0 / 255.0 blue:25.0 / 255.0 alpha:1.0]];
        [self.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0]];
        [self.detailTextLabel setTextColor:COLOR_NOTEBOOK_SHARED_LABEL];
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

- (ENNotebookTypeView *)businessAccessoryView {
    _notebookTypeView = [[ENNotebookTypeView alloc] initWithFrame:CGRectMake(0.0, 0.0, 26.0, 26.0)];
    _notebookTypeView.isBusiness = YES;
    return _notebookTypeView;
}

- (ENNotebookTypeView *)sharedAccessoryView {
    _notebookTypeView = [[ENNotebookTypeView alloc] initWithFrame:CGRectMake(0.0, 0.0, 26.0, 26.0)];
    _notebookTypeView.isBusiness = NO;
    return _notebookTypeView;
}

- (void)setNotebook:(ENNotebook *)notebook {
    [self.textLabel setText:notebook.name];
    if ([notebook isBusinessNotebook] || ![notebook isOwnedByUser]) {
        [self.detailTextLabel setText:notebook.ownerDisplayName];
    } else {
        [self.detailTextLabel setText:nil];
    }
    if ([notebook isBusinessNotebook]) {
        [self.detailTextLabel setTextColor:COLOR_NOTEBOOK_BUSINESS_LABEL];
        [self setAccessoryView:[self businessAccessoryView]];
    } else if ([notebook isShared]) {
        [self.detailTextLabel setTextColor:COLOR_NOTEBOOK_SHARED_LABEL];
        [self setAccessoryView:[self sharedAccessoryView]];
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
