//
//  AuthenticationViewController.h
//  MsgsMobile
//
//  Created by ivan on 1/9/10.
//  Copyright 2010 - 3boxed Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSGSConnectionAdapter.h"

@interface AuthenticationViewController : UIViewController<UITextFieldDelegate> {
	IBOutlet UITextField *server;
	IBOutlet UITextField *username;
	IBOutlet UITextField *password;
	
	MSGSConnectionAdapter *connectionAdapter;
}

-(IBAction)login:(id)sender;

@property(readwrite,assign) MSGSConnectionAdapter *connectionAdapter;

@end
