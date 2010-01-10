//
//  MSGLogonConnectionDelegate.m
//  MsgsMobile
//
//  Created by ivan on 6/11/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import "MSGSConnectionAdapter.h"
#import "MSGSURLProtocol.h"
#import "Constants.h"

@interface MSGSConnectionAdapter (Private)
- (void)handleBounds:(NSString *)data;
- (void)handleRcRead:(NSString *)data;
- (void)handleHead:(NSString *)data;
@end

@implementation MSGSConnectionAdapter


- (id)initWithDelegate:(id<MSGSConnectionAdapterDelegate>)aDelegate
{
	self = [super init];
	if (self != nil) {
		delegate = [((NSObject *)aDelegate) retain];
	}
	return self;
}

- (void) dealloc
{
	[((NSObject *)delegate) release];
	[super dealloc];
}

- (void)readBounds
{
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:MSGS_BOUNDS]];
	[NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)readCurrentReadCount
{
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:MSGS_RC_READ]];
	[NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void)readMessage:(NSUInteger)messageNumber
{
	NSString *urlString = [NSString stringWithFormat:MSGS_MESSAGE, messageNumber];
	NSLog(@"Sending command: %@", urlString);
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark -
#pragma mark Private handlers
#pragma mark -

- (void)handleBounds:(NSString *)data
{
	NSArray *parts = [data componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	[delegate boundsDidChangeFrom:[[parts objectAtIndex:0] intValue] to:[[parts objectAtIndex:1] intValue]];
}

- (void)handleRcRead:(NSString *)data
{
	[delegate readCountDidChange:[data intValue]];
}

- (void)handleHead:(NSString *)data
{
	[delegate messageHeaderDidLoad:data];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate methods
#pragma mark -

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge 
{
	NSLog(@"Received authentication challenge");
	challengeSender = [challenge retain];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"authentication" 
														object:self];
}

- (void)authenticateWithUser:(NSString *)username password:(NSString *)password {
	NSURLCredential *cred = [NSURLCredential credentialWithUser:username 
													   password:password
													persistence:NSURLCredentialPersistenceNone];
	[[challengeSender sender] useCredential:cred forAuthenticationChallenge:challengeSender];
	[challengeSender release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSString *requestPath = [[response URL] path];
	if ([@"/bounds" isEqualToString:requestPath]) {
		action = @selector(handleBounds:);
	} else if ([@"/rc-read" isEqualToString:requestPath]) {
		action = @selector(handleRcRead:);
	} else if ([requestPath rangeOfString:@"/msg"].location == 0) {
		action = @selector(handleHead:);
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if ([error code] == MSG_LOGON_ERROR_CODE) {
		[delegate logonDidFail];
	} else {
		NSLog(@"Connection adapter received error it could not dispatch: %@", error);
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	if (!tmpData) {
		tmpData = [[NSMutableData alloc] initWithData:data];
	} else {
		[tmpData appendData:data];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *stringData = [[[NSString alloc] initWithData:tmpData encoding:NSISOLatin1StringEncoding] autorelease];
	if (action) {
		NSLog(@"Connection delegate will perform selector");
		[self performSelector:action withObject:stringData];
	}
	
	/*
	 * Release temporary data buffer
	 */
	if (tmpData) {
		[tmpData autorelease];
		tmpData = nil;
	}
}

@end
