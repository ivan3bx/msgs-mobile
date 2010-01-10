//
//  MSGItem.m
//  Riseer
//
//  Created by ivan on 5/23/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import "MSGHeader.h"
#import "RegexKitLite.h"

@implementation MSGHeader
@synthesize author, email, subject, date, messageId, body;

+ (MSGHeader *)headerFromString:(NSString *)input {
	MSGHeader *item = [[[MSGHeader alloc] init] autorelease];
	
	/*
	 * The following regex matches multi-line, dot-all.  The only tricky part to
	 * understand is the 'email' capture, which is optional (some clients don't specify it).
	 * Also will be undefined if subject line is not present, but haven't seen example of that yet.
	 */
	NSArray *parts	= [input captureComponentsMatchedByRegex:@"(?ms:^From ([A-Za-z]+)( \\((.*)\\))? ([^\n]*).*^Subject: ([^\n]*).*?\n\n)"];
	item.author		= [parts objectAtIndex:1];
	item.email		= [parts objectAtIndex:3];
	item.date		= [parts objectAtIndex:4];
	item.subject	= [parts objectAtIndex:5];
	
	NSArray *bodyParts = [input captureComponentsMatchedByRegex:@"(?ms:.*?\n\n(.*))"];
	item.body = [bodyParts objectAtIndex:1];
	
	return item;
}

- (NSString *)formattedDate {
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"EEE MMM dd HH:mm:ss yyyy"];

	NSDate *parsedDate = [format dateFromString:date];
	
	[format setDateFormat:@"EEE MMM dd hh:mm a"];
	NSString *result = [format stringFromDate:parsedDate];
	[format release];
	return result;
}

- (NSString *)description {
	return [@"Message " stringByAppendingFormat:@"[author:%@] [email:%@] [date:%@] [subject:%@]", author, email, date, subject];
}

- (void)dealloc {
	[author release];
	[subject release];
	[date release];
	[super dealloc];
}

@end
