//
//  NSURLRequest+Msgs.h
//  MsgsMobile
//
//  Created by ivan on 5/20/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURLRequest (Msgs)

+ (id)requestToConnect:(NSURL *)URL 
			  withUser:(NSString *)username 
			  password:(NSString *)password;

+ (id)requestToConnect:(NSURL *)URL 
			  withUser:(NSString *)username 
			  password:(NSString *)password 
		   cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
	   timeoutInterval:(NSTimeInterval)timeoutInterval;

@end
