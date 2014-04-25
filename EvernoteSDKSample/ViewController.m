//
//  ViewController.m
//  EvernoteSDKSample
//
//  Created by Ben Zotto on 4/24/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "ViewController.h"
#import <ENSDK/ENSDK.h>
#import "UserInfoViewController.h"
#import "SaveActivityViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
}

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

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[ENSession sharedSession] isAuthenticated]) {
        return 4; // Unauthenticate, user info, try activity, photo note
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
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"Create photo note";
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
        UIViewController * vc = [[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        UIViewController * vc = [[SaveActivityViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    ENResource * resource = [[ENResource alloc] initWithImage:image];
    ENNote * note = [[ENNote alloc] init];
    note.title = @"Photo note";
    [note addResource:resource];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[ENSession sharedSession] uploadNote:note completion:^(ENNoteRef *noteRef, NSError *uploadNoteError) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        NSString * message = nil;
        if (noteRef) {
            message = @"Photo note created.";
        } else {
            message = @"Failed to create photo note.";
        }
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
        [alert show];
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
