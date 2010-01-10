//
//  MSGRepository.m
//  MsgsMobile
//
//  Created by ivan on 6/3/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import "MSGRepository.h"
#import "MSGHeader.h"
#import "MSGSConnectionAdapter.h"
#import "NSURLRequest+Msgs.h"

@implementation MSGRepository
@synthesize high, low, currentIndex;

- (id) init {
	self = [super init];
	if (self != nil) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		connectionAdapter = [[MSGSConnectionAdapter alloc] initWithDelegate:self];
		[connectionAdapter readBounds];
	}
	return self;
}


- (void)getNextMessage {
	if (currentIndex == 0) {
		// Still in progress..
		queueNextMessage = YES;
	} else {
		currentIndex++;
		NSLog(@"Checking header for number: %d", currentIndex);
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		[connectionAdapter readMessage:currentIndex];
	}
}

- (void)getPreviousMessage {
	currentIndex--;
	NSLog(@"Checking header for number: %d", currentIndex);
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[connectionAdapter readMessage:currentIndex];
}


#pragma mark -
#pragma mark MSGSConnectionAdapterDelegate methods
#pragma mark -

- (void)logonDidFail {
	NSLog(@"Repository could not initialize; logon failed");
}

- (void)boundsDidChangeFrom:(int)lower to:(int)upper {
	NSLog(@"Bounds did change to [%d, %d]", lower, upper);
	high = upper;
	low = upper - 200 < 0 ? 0 : upper - 200;
	[connectionAdapter readCurrentReadCount];
}

- (void)readCountDidChange:(int)newValue {
	NSLog(@"Last Read did change to: %d", newValue - 2);
	currentIndex = newValue - 2;
	if (queueNextMessage) {
		queueNextMessage = NO;
		[self getNextMessage];
	}
}

- (void)messageHeaderDidLoad:(NSString *)data {
	MSGHeader *header = [MSGHeader headerFromString:data];
	header.messageId = currentIndex;
	
	//
	// Finished loading.  Notify
	//
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"INCOMING_MESSAGE" object:header];
}

@end
