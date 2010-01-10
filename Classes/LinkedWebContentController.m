//
//  LinkedWebContentController.m
//  MsgsMobile
//
//  Created by ivan on 7/4/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import "LinkedWebContentController.h"


@implementation LinkedWebContentController

- (id)initWithNibName:(NSString *)nibNameOrNil webResource: (NSURLRequest *)aRequest bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		request = [aRequest retain];
    }
    return self;
}

- (void)viewDidLoad {
	[webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
	[[self navigationController] setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[self navigationController] setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[webView stopLoading];
}


- (void)dealloc {
    [super dealloc];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}



@end
