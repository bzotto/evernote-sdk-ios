//
//  ViewController.m
//  EvernoteSDKSample
//
//  Created by Ben Zotto on 4/24/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "ViewController.h"
#import <ENSDK/ENSDK.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:NULL];
    [self.navigationItem setBackBarButtonItem:backButton];
    [self update];
}

- (void)update
{
    [self.tableView reloadData];
    if ([[ENSession sharedSession] isAuthenticated]) {
        [self.navigationItem setTitle:[[ENSession sharedSession] userDisplayName]];
    } else {
        [self.navigationItem setTitle:nil];
    }
}

- (UIViewController *)viewControllerFromStoryboardWithIdentifier:(NSString *)identifier
{
    UIStoryboard *storyboard = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

#pragma mark - UITableView

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[ENSession sharedSession] isAuthenticated]) {
        return 3; // Unauthenticate, user info, try activity
    } else {
        return 1; // Authenticate
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        if ([[ENSession sharedSession] isAuthenticated]) {
            cell.textLabel.text = @"Unauthenticate";
        } else {
            cell.textLabel.text = @"Authenticate";
        }
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"User info";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Save Activity";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([[ENSession sharedSession] isAuthenticated]) {
            [[ENSession sharedSession] unauthenticate];
            [self update];
        } else {
            [[ENSession sharedSession] authenticateWithViewController:self completion:^(NSError *authenticateError) {
                   if (!authenticateError) {
                       [self update];
                   } else if (authenticateError.code != ENErrorCodeCancelled) {
                       UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"Could not authenticate"
                                                                       delegate:nil
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"OK", nil];
                       [alert show];
                   }
            }];
        }
    } else if (indexPath.row == 1) {
        UIViewController * vc = [self viewControllerFromStoryboardWithIdentifier:@"UserInfo"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        UIViewController * vc = [self viewControllerFromStoryboardWithIdentifier:@"SaveActivity"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
