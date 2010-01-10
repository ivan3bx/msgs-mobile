//
//  MSGSConnection.m
//  MsgsMobile
//
//  Created by ivan on 5/16/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import "MSGSConnection.h"

static MSGSConnection *sharedConnection = nil;

@implementation MSGSConnection


- (id) init {
	self = [super init];
	if (self != nil) {
		socket = [[AsyncSocket alloc] init];
		[socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
	}
	return self;
}

- (AsyncSocket *)socket {
	return socket;
}

+ (MSGSConnection *)sharedConnection {
	
    @synchronized(self) {
        if (sharedConnection == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedConnection;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
        if (sharedConnection == nil) {
            sharedConnection = [super allocWithZone:zone];
            return sharedConnection;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

- (void)release {
}

- (id)autorelease {
    return self;
}

@end
