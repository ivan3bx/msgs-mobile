//
//  EditViewController.h
//  MsgsMobile
//
//  Created by ivan on 10/14/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate> {
	IBOutlet UITextField *subject;
	IBOutlet UITextView *content;
}

-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;

@end
