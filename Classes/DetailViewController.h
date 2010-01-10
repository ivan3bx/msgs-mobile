//
//  DetailViewController.h
//  MsgsMobile
//
//  Created by ivan on 6/17/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSGHeader.h"
#import "MSGRepository.h"

@interface DetailViewController : UIViewController {
	IBOutlet UILabel *messageIdField;
	IBOutlet UILabel *fromField;
	IBOutlet UILabel *dateField;
	IBOutlet UIWebView *webView;
	
	IBOutlet UISegmentedControl *upDown;
	MSGRepository *repository;
}

@property(readwrite,assign) MSGRepository *repository;

- (IBAction)move:(UISegmentedControl *)sender;
- (IBAction)compose:(id)sender;

@end
