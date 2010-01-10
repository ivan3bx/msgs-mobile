//
//  AuthenticationViewController.m
//  MsgsMobile
//
//  Created by ivan on 1/9/10.
//  Copyright 2010 - 3boxed Software. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "DetailViewController.h"
#import "Constants.h"

@implementation AuthenticationViewController

@synthesize connectionAdapter;

- (void)viewDidLoad {
	[server setText:MSGS_SERVER_URL];
    [super viewDidLoad];
}

-(IBAction)login:(id)sender {
	[connectionAdapter authenticateWithUser:[username text] password:[password text]];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[username release];
	[password release];
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods
#pragma mark -

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//	return YES;
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//	return YES;
//}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([username isFirstResponder]) {
		[password becomeFirstResponder];
	} else {
		[textField resignFirstResponder];
	}
	return YES;
}

@end
