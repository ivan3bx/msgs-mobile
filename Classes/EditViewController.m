//
//  EditViewController.m
//  MsgsMobile
//
//  Created by ivan on 10/14/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import "EditViewController.h"


@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)save:(id)sender {
	NSLog(@"Would save: %@", content.text);
	[super dismissModalViewControllerAnimated:YES];
}


- (IBAction)cancel:(id)sender {
	[super dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[subject release];
	[content release];
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods
#pragma mark -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[content becomeFirstResponder];
	return YES;
}


#pragma mark -
#pragma mark UITextViewDelegate methods
#pragma mark -


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
	
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
	
}

@end
