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

NS_ENUM(NSInteger, SampleFunctions) {
    kSampleFunctionsUnauthenticate,
    kSampleFunctionsUserInfo,
    kSampleFunctionsSaveActivity,
    kSampleFunctionsCreatePhotoNote,
    kSampleFunctionsClipWebPage,
    
    kSampleFunctionsMaxValue
};

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIWebViewDelegate>
@property (nonatomic, strong) UIWebView * webView;
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

- (void)showSimpleAlertWithMessage:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
    [alert show];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[ENSession sharedSession] isAuthenticated]) {
        return kSampleFunctionsMaxValue;
    } else {
        return 1; // Authenticate
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.row) {
        case kSampleFunctionsUnauthenticate:
            if ([[ENSession sharedSession] isAuthenticated]) {
                cell.textLabel.text = @"Unauthenticate";
            } else {
                cell.textLabel.text = @"Authenticate";
            }
            break;
            
        case kSampleFunctionsUserInfo:
            cell.textLabel.text = @"User info";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case kSampleFunctionsSaveActivity:
            cell.textLabel.text = @"Save Activity";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case kSampleFunctionsCreatePhotoNote:
            cell.textLabel.text = @"Create photo note";
            break;
            
        case kSampleFunctionsClipWebPage:
            cell.textLabel.text = @"Clip web page";
            break;
            
        default:
            ;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case kSampleFunctionsUnauthenticate:
            if ([[ENSession sharedSession] isAuthenticated]) {
                [[ENSession sharedSession] unauthenticate];
                [self update];
            } else {
                [[ENSession sharedSession] authenticateWithViewController:self completion:^(NSError *authenticateError) {
                    if (!authenticateError) {
                        [self update];
                    } else if (authenticateError.code != ENErrorCodeCancelled) {
                        [self showSimpleAlertWithMessage:@"Could not authenticate."];
                    }
                }];
            }
            break;
            
        case kSampleFunctionsUserInfo:
        {
            UIViewController * vc = [[UserInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case kSampleFunctionsSaveActivity:
        {
            UIViewController * vc = [[SaveActivityViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case kSampleFunctionsCreatePhotoNote:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];
            }
            break;
        }
        case kSampleFunctionsClipWebPage:
        {
            self.webView = [[UIWebView alloc] initWithFrame:self.view.window.bounds];
            self.webView.delegate = self;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.evernote.com"]]];
            break;
        }
        default:
            ;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Web view fail: %@", error);
    [self showSimpleAlertWithMessage:@"Failed to load web page to clip."];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [ENNote populateNoteFromWebView:self.webView completion:^(ENNote * note) {
        if (!note) {
            return;
        }
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [[ENSession sharedSession] uploadNote:note completion:^(ENNoteRef *noteRef, NSError *uploadNoteError) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            NSString * message = nil;
            if (noteRef) {
                message = @"Web note created.";
            } else {
                message = @"Failed to create web note.";
            }
            [self showSimpleAlertWithMessage:message];
        }];
    }];
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
        [self showSimpleAlertWithMessage:message];
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
