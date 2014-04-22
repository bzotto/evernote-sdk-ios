//
//  ENNotebookCell.h
//  evernote-sdk-ios
//
//  Created by Eric Cheng on 4/21/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENNotebook.h"

@interface ENNotebookCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (assign, nonatomic) BOOL isCurrentNotebook;
@property (strong, nonatomic) ENNotebook *notebook;
@property (strong, nonatomic) UIButton *checkButton;

@end
