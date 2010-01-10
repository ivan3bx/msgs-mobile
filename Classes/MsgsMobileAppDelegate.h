//
//  MsgsMobileAppDelegate.h
//  MsgsMobile
//
//  Created by ivan on 6/3/09.
//  Copyright - 3boxed Software 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSGRepository.h"

@interface MsgsMobileAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
	MSGRepository *repository;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

