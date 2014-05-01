//
//  ENLoadingViewController.m
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 5/1/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "ENLoadingViewController.h"

@interface ENLoadingViewController ()
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@end

@implementation ENLoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView * view = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator setHidesWhenStopped:YES];
    self.activityIndicator.frame = CGRectMake((self.navigationController.view.frame.size.width - (self.activityIndicator.frame.size.width/2))/2,
                                              (self.navigationController.view.frame.size.height - (self.activityIndicator.frame.size.height/2) - 44)/2,
                                              self.activityIndicator.frame.size.width,
                                              self.activityIndicator.frame.size.height);
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

- (void)cancel:(id)sender
{
    [self.activityIndicator stopAnimating];
    [self.delegate loadingViewControllerDidCancel:self];
}
@end
