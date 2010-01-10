//
//  MSGRepository.h
//  MsgsMobile
//
//  Created by ivan on 6/3/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import "MSGSConnection.h"
#import "MSGSConnectionAdapter.h"

@class MSGHeader;

@interface MSGRepository : NSObject<MSGSConnectionAdapterDelegate> {
	NSInteger high;
	NSInteger low;
	NSInteger currentIndex;
	
	BOOL queueNextMessage; // for bootstrapping
	MSGSConnectionAdapter *connectionAdapter;
}

- (void)getNextMessage;
- (void)getPreviousMessage;

@property(readonly) NSInteger currentIndex;
@property(readonly) NSInteger high;
@property(readonly) NSInteger low;

@end
