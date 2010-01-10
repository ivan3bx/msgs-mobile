//
//  NSURLRequest+Msgs.m
//  MsgsMobile
//
//  Created by ivan on 5/20/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import "NSURLRequest+Msgs.h"


@implementation NSURLRequest (Msgs)

+ (id)requestToConnect:(NSURL *)URL 
			  withUser:(NSString *)username 
			  password:(NSString *)password 
{
	id request = [NSURLRequest requestWithURL:URL];
	[NSURLProtocol setProperty:username forKey:@"user" inRequest:request];
	[NSURLProtocol setProperty:password forKey:@"password" inRequest:request];
	return request;
}

+ (id)requestToConnect:(NSURL *)URL 
			  withUser:(NSString *)username 
			  password:(NSString *)password 
		   cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
	   timeoutInterval:(NSTimeInterval)timeoutInterval
{
	id request = [NSURLRequest requestWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
	[NSURLProtocol setProperty:username forKey:@"user" inRequest:request];
	[NSURLProtocol setProperty:password forKey:@"password" inRequest:request];
	return request;
}

@end
