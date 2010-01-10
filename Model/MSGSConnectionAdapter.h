//
//  MSGLogonConnectionDelegate.h
//  MsgsMobile
//
//  Created by ivan on 6/11/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

/*
 * Delegates of this adapter must implement the following methods
 * in order to be notified when data is returned from the server
 */
@protocol MSGSConnectionAdapterDelegate
- (void)logonDidFail;
- (void)boundsDidChangeFrom:(int)lower to:(int)upper;
- (void)readCountDidChange:(int)newValue;
- (void)messageHeaderDidLoad:(NSString *)data;
@end


@interface MSGSConnectionAdapter : NSObject {
	id<MSGSConnectionAdapterDelegate> delegate;
	SEL action;
	NSMutableData *tmpData;
	NSURLAuthenticationChallenge *challengeSender;
}

// This should really move to a separate protocol, as it's trigged via notificaiton
- (void)authenticateWithUser:(NSString *)username password:(NSString *)password;

- (id)initWithDelegate:(id<MSGSConnectionAdapterDelegate>)aDelegate;
- (void)readBounds;
- (void)readCurrentReadCount;
- (void)readMessage:(NSUInteger)messageNumber;

@end
