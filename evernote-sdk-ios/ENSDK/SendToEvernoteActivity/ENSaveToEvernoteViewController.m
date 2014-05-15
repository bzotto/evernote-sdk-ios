/*
 * Copyright (c) 2014 by Evernote Corporation, All rights reserved.
 *
 * Use of the source code and binary libraries included in this package
 * is permitted under the following terms:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ENSaveToEvernoteViewController.h"
#import "ENNotebookChooserViewController.h"
#import "ENNotebookPickerButton.h"
#import "ENSDK.h"
#import "ENTheme.h"
#import "RMSTokenView.h"

#define kTitleViewHeight        50.0
#define kTagsViewHeight         44.0
#define kNotebookViewHeight     50.0
#define kTextLeftPadding        20

@interface ENSaveToEvernoteActivity (Private)
- (ENNote *)preparedNote;
@end

@interface ENSaveToEvernoteViewController () <ENNotebookChooserViewControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIBarButtonItem * saveButtonItem;
@property (nonatomic, strong) UITextField * titleField;
@property (nonatomic, strong) UITextField * notebookField;
@property (nonatomic, strong) ENNotebookPickerButton * notebookButton;
@property (nonatomic, strong) RMSTokenView * tagsView;

@property (nonatomic, strong) NSArray * notebookList;
@property (nonatomic, strong) ENNotebook * currentNotebook;
@end

@implementation ENSaveToEvernoteViewController

- (void)loadView {
    [super loadView];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.view setBackgroundColor:[ENTheme defaultBackgroundColor]];
    [self.navigationController.view setTintColor:[ENTheme defaultTintColor]];
    
    UITextField *titleField = [[UITextField alloc] initWithFrame:CGRectZero];
    titleField.translatesAutoresizingMaskIntoConstraints = NO;
    [titleField setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [titleField setTextColor:[UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1]];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTextLeftPadding, 0)];
    titleField.leftView = paddingView1;
    titleField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:titleField];
    self.titleField = titleField;
    
    UIView *divider1 = [[UIView alloc] initWithFrame:CGRectZero];
    divider1.translatesAutoresizingMaskIntoConstraints = NO;
    [divider1 setBackgroundColor: [ENTheme defaultSeparatorColor]];
    [self.view addSubview:divider1];
    
    RMSTokenView *tagsView = [[RMSTokenView alloc] initWithFrame:CGRectZero];
    tagsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tagsView];
    self.tagsView = tagsView;
    
    UITextField *notebookField = [[UITextField alloc] initWithFrame:CGRectZero];
    [notebookField setText:NSLocalizedString(@"Notebook", @"Notebook")];
    [notebookField setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0]];
    notebookField.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTextLeftPadding, 0)];
    notebookField.leftView = paddingView3;
    notebookField.leftViewMode = UITextFieldViewModeAlways;
    
    ENNotebookPickerButton *notebookButton = [[ENNotebookPickerButton alloc] init];
    [notebookButton setTitleColor:[ENTheme defaultTintColor] forState:UIControlStateNormal];
    [notebookButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0]];
    [notebookButton addTarget:self action:@selector(pickNotebook:) forControlEvents:UIControlEventTouchUpInside];
    self.notebookButton = notebookButton;
    notebookField.rightView = notebookButton;
    notebookField.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:notebookField];
    self.notebookField = notebookField;
    
    UIView *divider3 = [[UIView alloc] initWithFrame:CGRectZero];
    divider3.translatesAutoresizingMaskIntoConstraints = NO;
    [divider3 setBackgroundColor:[ENTheme defaultSeparatorColor]];
    [self.view addSubview:divider3];
    
    NSString *format = [NSString stringWithFormat:@"V:[titleField(%f)][divider1(%f)][tagsView(>=%f)][notebookField(%f)][divider3(%f)]", kTitleViewHeight, OnePxHeight(), kTagsViewHeight, kNotebookViewHeight, OnePxHeight()];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                       options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(titleField, divider1, tagsView, notebookField, divider3)]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleField]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(titleField)]];
    
    self.navigationItem.title = NSLocalizedString(@"Save To Evernote", @"Save To Evernote");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    self.saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = self.saveButtonItem;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.saveButtonItem.enabled = NO;
    self.titleField.text = [self.delegate defaultNoteTitleForViewController:self];
    if (self.titleField.text.length == 0) {
        [self.titleField setPlaceholder:NSLocalizedString(@"Add Title", @"Add Title")];
    }
    self.notebookField.delegate = self;
    self.tagsView.placeholder = NSLocalizedString(@"Add Tag", @"Add Tag");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Kick off the notebook list fetch.
    [[ENSession sharedSession] listNotebooksWithHandler:^(NSArray *notebooks, NSError *listNotebooksError) {
        self.notebookList = notebooks;
        // Populate the notebook picker with the default notebook.
        for (ENNotebook * notebook in notebooks) {
            if (notebook.isDefaultNotebook) {
                self.currentNotebook = notebook;
                [self updateCurrentNotebookDisplay];
                break;
            }
        }
        self.saveButtonItem.enabled = YES;
    }];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)updateCurrentNotebookDisplay
{
    NSString * displayName = self.currentNotebook.name;
    [self.notebookButton setIsBusinessNotebook:(self.currentNotebook.isBusinessNotebook)];
    [self.notebookButton setTitle:displayName forState:UIControlStateNormal];
    [self.notebookButton sizeToFit];
}

- (void)showNotebookChooser
{
    ENNotebookChooserViewController * chooser = [[ENNotebookChooserViewController alloc] init];
    chooser.delegate = self;
    chooser.notebookList = self.notebookList;
    chooser.currentNotebook = self.currentNotebook;
    [self.navigationController pushViewController:chooser animated:YES];
}

#pragma mark - Actions

- (void)save:(id)sender
{
    // Fetch the note we've built so far.
    ENNote * note = [self.delegate noteForViewController:self];

    // Populate the metadata fields we offered.
    note.title = self.titleField.text;
    if (note.title.length == 0) {
        note.title = NSLocalizedString(@"Untitled note", @"Untitled note");
    }
    note.notebook = self.currentNotebook;
    
    NSArray * tags = [self.tagsView tokens];
    if (tags.count > 0) {
        note.tagNames = tags;
    }
    
    // Upload the note.
    [[ENSession sharedSession] uploadNote:note completion:^(ENNoteRef *noteRef, NSError *uploadNoteError) {
        [self.delegate viewController:self didFinishWithSuccess:(noteRef != nil)];
    }];
}

- (void)cancel:(id)sender
{
    [self.delegate viewController:self didFinishWithSuccess:NO];
}

- (void)pickNotebook:(id)sender{
    [self textFieldShouldBeginEditing:self.notebookField];
}

#pragma mark - ENNotebookChooserViewControllerDelegate

- (void)notebookChooser:(ENNotebookChooserViewController *)chooser didChooseNotebook:(ENNotebook *)notebook
{
    self.currentNotebook = notebook;
    [self updateCurrentNotebookDisplay];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.notebookField) {
        [self showNotebookChooser];
        return NO;
    }
    
    return YES;
}
@end
