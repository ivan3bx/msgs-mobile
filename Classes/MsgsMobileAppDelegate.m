//
//  MsgsMobileAppDelegate.m
//  MsgsMobile
//
//  Created by ivan on 6/3/09.
//  Copyright - 3boxed Software 2009. All rights reserved.
//

#import "MsgsMobileAppDelegate.h"
#import "DetailViewController.h"
#import "MSGSURLProtocol.h"

@implementation MsgsMobileAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[NSURLProtocol registerClass:[MSGSURLProtocol class]];
	
	// Create a repository for msgs
	repository = [[MSGRepository alloc] init];
	
	// Create root view controller and push it on the navigation stack
	DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
	[viewController setRepository:repository];
	[navigationController initWithRootViewController:viewController];
	[viewController release];
	
	// Show main subview
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
