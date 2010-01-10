//
//  MSGSURLProtocol.m
//  MsgsMobile
//
//  Created by ivan on 5/14/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import <CFNetwork/CFNetwork.h>
#import "AsyncSocket.h"
#import "MSGSURLProtocol.h"
#import "MSGSConnection.h"

#ifndef __MSGS_ERRORS__
#define __MSGS_ERRORS__
#define notifyWithError(codeNumber, descriptionText) \
NSError *error = [NSError errorWithDomain:@"msgs" code:codeNumber \
								 userInfo:[NSDictionary dictionaryWithObject:descriptionText \
																	  forKey:NSLocalizedDescriptionKey]];\
[[self client] URLProtocol:self didFailWithError:error];
#endif

@interface MSGSURLProtocol (Private)
- (BOOL)isMultiline:(NSURLRequest *)aRequest;
- (NSData *)parseSingleLine:(NSData *)data;
- (NSData *)parseMultiline:(NSData *)data;
@end

int const MSG_LOGON_ERROR_CODE = 4;
int const LOGON_TAG = 20;

@implementation MSGSURLProtocol

#pragma mark -
#pragma mark NSURLProtocol implementation methods
#pragma mark -

- (id)initWithRequest:(NSURLRequest *)req cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id < NSURLProtocolClient >)client 
{
	self = [super initWithRequest:req cachedResponse:cachedResponse client:client];
	if (self != nil) {
		commands_multi = [[NSArray alloc] initWithObjects:@"/head", @"/body", @"/msg", nil];
		request = [req retain];
		protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:[[request URL] host] 
																port:7778 protocol:@"msgs" 
															   realm:nil 
												authenticationMethod:NSURLAuthenticationMethodDefault];
	}
	return self;
}

- (void) dealloc 
{
	[commands_multi release];
	[request release];
	[protectionSpace release];
	[commandString release];
	[super dealloc];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request 
{
	return ([@"msgs" isEqualToString:[[request URL] scheme]]);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request 
{
	return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b 
{
	return ([[a URL] isEqual:b]);
}

- (void)startLoading 
{
	socket = [[MSGSConnection sharedConnection] socket];
	[socket setDelegate:self];
	
	
	if (![socket isConnected]) {
		NSError *err = nil;

		/*
		 * Authentication (and managing credentials) handled in 'onSocket:didSecure:'
		 * which is invoked asynchronously via 'connectToHost:onPort:error:' call above
		 */
		if(![socket connectToHost:[[request URL] host] onPort:7778 error:&err]) {
			notifyWithError(1, @"Unable to connect to host");
		}
		return;
	}
	
	if ([@"/quit" isEqualToString:[[request URL] path]]) {
		[socket disconnect];
		[[self client] URLProtocolDidFinishLoading:self];
	} else {
		commandString = [[[request URL] path] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
		commandString = [commandString stringByReplacingOccurrencesOfString:@"/" withString:@" "];
		commandString = [[commandString stringByAppendingString:@"\n"] retain];
		
		/*
		 * Determine how to expect delimiter type based on command
		 */
		NSData *delim;
		if ([self isMultiline:request]) {
			delim = [@"\n.\n" dataUsingEncoding:NSUTF8StringEncoding];
		} else {
			delim = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
		}
		
		NSData *data = [commandString dataUsingEncoding:NSUTF8StringEncoding];
		[socket writeData:data withTimeout:4.0 tag:0];
		[socket readDataToData:delim withTimeout:4.0 tag:0];
	}
}

- (void)stopLoading 
{
}	


#pragma mark -
#pragma mark AsyncSocket delegate methods
#pragma mark -


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port 
{
	NSLog(@"onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);
	NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
	[settings setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
	[sock startTLS:settings];
}

- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)isSecure 
{
	if (!isSecure) {
		notifyWithError(1, @"Unable to create SSL connection to host");
		return;
	}
	
	/*
	 * Issue an authentication challenge through the protocol client
	 */
	NSDictionary *desc = [NSDictionary dictionaryWithObject:@"Username and Password Required" forKey:NSLocalizedDescriptionKey];
	NSError *error = [NSError errorWithDomain:@"msgs" code:3 userInfo:desc];
	NSURLAuthenticationChallenge *challenge;
	challenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace
														   proposedCredential:nil
														 previousFailureCount:1
															  failureResponse:[[NSURLResponse alloc] init]
																		error:error
																	   sender:self];
	[[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err 
{
	notifyWithError(2, @"Disconnected from server with error");
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock 
{
	NSLog(@"onSocketDidDisconnect:%p", sock);
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag 
{
	NSLog(@"Did Write Data");
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData*)data withTag:(long)tag 
{
	NSLog(@"Did Read Data");
	NSURLResponse *res = [[[NSURLResponse alloc] initWithURL:[request URL] MIMEType:@"text/data" 
									  expectedContentLength:[data length]
										   textEncodingName:@"ISO-8859-1"] autorelease];
	
	NSString *result = [[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding] autorelease];
	
	/*
	 * Special case for pass-through authentication
	 */
	if (tag == LOGON_TAG) {
		if ([result rangeOfString:@"ERROR"].location == 0) {
			notifyWithError(MSG_LOGON_ERROR_CODE, [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
		} else {
			// This was an out-of-band write/read cycle, so
			// we start over using the original 'request'
			[self startLoading];
		}
		return; // Always return
	}
	
	/*
	 * Notify of any errors
	 */
	if ([result rangeOfString:@"ERROR"].location == 0) {
		notifyWithError(3, [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
		return;
	} 
	
	/*
	 * Notify client of response
	 */
	[[self client] URLProtocol:self didReceiveResponse:res cacheStoragePolicy: NSURLCacheStorageNotAllowed];
	
	/*
	 * Notify client of data
	 */
	if ([self isMultiline:request]) {
		data = [self parseMultiline:data];
	} else {
		data = [self parseSingleLine:data];
	}
	
	[[self client] URLProtocol:self didLoadData:data];
	[[self client] URLProtocolDidFinishLoading:self];
}

#pragma mark -
#pragma mark End AsynSocket Delegate
#pragma mark -

- (BOOL)isMultiline:(NSURLRequest *)aRequest {
	NSString *startOfURLPath = [NSString stringWithFormat:@"/%@", [[[[aRequest URL] path] componentsSeparatedByString:@"/"] objectAtIndex:1]];
	return [commands_multi containsObject:startOfURLPath];
}

- (NSData *)parseMultiline:(NSData *)data 
{
	NSString *result = [[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding] autorelease];
	result = [result substringFromIndex:3];
	result = [result substringToIndex:[result length] - 2];
	return [result dataUsingEncoding:NSISOLatin1StringEncoding];
}

- (NSData *)parseSingleLine:(NSData *)data 
{
	NSString *result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return [result dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark -
#pragma mark NSURLAuthenticationChallengeSender protocol
#pragma mark -

- (void)cancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge 
{
	NSLog(@"Sender will cancel challenge");
}

- (void)continueWithoutCredentialForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge 
{
	NSLog(@"Sender will continue without credentials");
}

- (void)useCredential:(NSURLCredential *)credential forAuthenticationChallenge:(NSURLAuthenticationChallenge *)aChallenge 
{
	NSString *logonString = [NSString stringWithFormat:@"logon %@ %@\n", [credential user], [credential password]];
	[socket writeData:[logonString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:4.0 tag:LOGON_TAG];
	[socket readDataWithTimeout:4.0 tag:20];
}

@end
