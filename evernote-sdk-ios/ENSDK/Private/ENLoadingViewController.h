//
//  ENLoadingViewController.h
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 5/1/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ENLoadingViewController;

@protocol ENLoadingViewControllerDelegate <NSObject>
- (void)loadingViewControllerDidCancel:(ENLoadingViewController *)viewController;
@end

@interface ENLoadingViewController : UIViewController
@property (nonatomic, weak) id<ENLoadingViewControllerDelegate> delegate;
@end
