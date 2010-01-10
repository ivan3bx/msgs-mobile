//
//  MSGSConnection.h
//  MsgsMobile
//
//  Created by ivan on 5/16/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@interface MSGSConnection : NSObject {
	AsyncSocket *socket;
}

+ (MSGSConnection *)sharedConnection;

- (AsyncSocket *)socket;

@end
