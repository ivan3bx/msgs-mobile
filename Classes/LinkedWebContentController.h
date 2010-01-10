//
//  LinkedWebContentController.h
//  MsgsMobile
//
//  Created by ivan on 7/4/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LinkedWebContentController : UIViewController {
	IBOutlet UIWebView *webView;
	NSURLRequest *request;
}

- (id)initWithNibName:(NSString *)nibNameOrNil webResource: (NSURLRequest *)aRequest bundle:(NSBundle *)nibBundleOrNil;

@end
