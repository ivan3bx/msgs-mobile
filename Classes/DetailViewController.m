//
//  DetailViewController.m
//  MsgsMobile
//
//  Created by ivan on 6/17/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//
#import "RegexKitLite.h"
#import "EditViewController.h"
#import "DetailViewController.h"
#import "LinkedWebContentController.h"
#import "discountWrapper.h"
#import "AuthenticationViewController.h"
#import "MSGSConnectionAdapter.h"

@implementation DetailViewController

@synthesize repository;

- (void)viewDidLoad {
	
	// Register for notifications on authentication
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(promptForAuthentication:) name:@"authentication" object:nil];

    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScreen:) name:@"INCOMING_MESSAGE" object:nil];
	[self.navigationItem setTitle:@"MsgsMobile"];
	[repository getNextMessage];
}

- (void)promptForAuthentication:(NSNotification *)sender {
	AuthenticationViewController *modal = [[AuthenticationViewController alloc] initWithNibName:@"AuthenticationViewController" bundle:nil];
	modal.connectionAdapter = (MSGSConnectionAdapter *)[sender object];;
	
	[self presentModalViewController:modal animated:YES];
	[modal release];
}

- (void)refreshScreen:(NSNotification *)notification {
	MSGHeader *header = [notification object];
	messageIdField.text = [[NSNumber numberWithInt:header.messageId] stringValue];
	fromField.text = header.author;
	dateField.text = [header formattedDate];
	
	// The original message text
	NSString *msgsText = header.body;
	
	// Find location of first 'gap' between body & probable 'footer / sig'
	NSRange startOfSignature = [msgsText rangeOfRegex:@"(?ms:\\s^[-<=].*\\Z)"];	
	NSString *formattedSignature;
	
	if (startOfSignature.location != NSNotFound) {
		formattedSignature = [msgsText stringByReplacingOccurrencesOfRegex:@"\n" withString:@"\n    " range:startOfSignature];
		msgsText = [msgsText substringToIndex:startOfSignature.location];
	} else {
		formattedSignature = @"";
	}
	
	NSString *htmlToRender = @"<html><head>"
	"<link rel=\"stylesheet\" href=\"msgsmobile.css\" type=\"text/css\">"
	"</head><body>";
	htmlToRender = [htmlToRender stringByAppendingFormat:
					@"<div id=\"header\">"
					@"<div id=\"author\">From: %@</div>"
					@"<div id=\"subject\">Subject: %@</div>"
					@"</div>"
					@"<div id=\"content\">%@</div>"
					@"<div id=\"signature\">%@</div>"
					@"</body></html>",
					header.author,
					header.subject,
					discountToHTML(msgsText), 
					discountToHTML(formattedSignature)];
	[webView loadHTMLString:htmlToRender baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath] isDirectory:YES]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)dealloc {
	[repository release];
    [super dealloc];
}


#pragma mark -
#pragma mark UISegmentedControl handler methods
#pragma mark -

- (IBAction)move:(UISegmentedControl *)sender {
	if (sender.selectedSegmentIndex == 0) {
		[repository getPreviousMessage];
	} else {
		// 'UP'
		[repository getNextMessage];
	}
	
	// Update state
	[sender setEnabled:(repository.currentIndex > repository.low) forSegmentAtIndex:0];
	[sender setEnabled:(repository.currentIndex < repository.high) forSegmentAtIndex:1];
	
}

- (IBAction)compose:(id)sender {
	EditViewController *editViewController = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
	[self presentModalViewController:editViewController animated:YES];
	[editViewController release];
}

#pragma mark -
#pragma mark UIWebViewDelegate methods
#pragma mark -


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if ([[request URL] host]) {
		// Intercept URL's for external hosts
//		[[self navigationController] pushViewController:[[[LinkedWebContentController alloc] initWithNibName:@"LinkedWebContentController" 
//																								 webResource:request 
//																									  bundle:[NSBundle mainBundle]] autorelease]
//											   animated:YES];
		return NO;
	} else {
		// Allow local content to be rendered in this view.
		return YES;
	}
}
@end

