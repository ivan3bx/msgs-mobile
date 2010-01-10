//
//  MSGSURLProtocol.h
//  MsgsMobile
//
//  Created by ivan on 5/14/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

extern int const MSG_LOGON_ERROR_CODE;

@class AsyncSocket;

@interface MSGSURLProtocol : NSURLProtocol <NSURLAuthenticationChallengeSender>{
	NSArray *commands_multi;
	
	NSURLRequest *request;
	AsyncSocket *socket;
	
	NSString *commandString;
	
	NSURLProtectionSpace *protectionSpace;
}

@end
