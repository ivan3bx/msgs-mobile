//
//  MSGItem.h
//  Riseer
//
//  Created by ivan on 5/23/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSGHeader : NSObject {
	NSUInteger messageId;
	NSString *author;
	NSString *email;
	NSString *date;
	NSString *subject;
	NSString *body;
}

+ (MSGHeader *)headerFromString:(NSString *)input;

- (NSString *)formattedDate;

@property(readwrite) NSUInteger messageId;
@property(readwrite,retain) NSString *author;
@property(readwrite,retain) NSString *email;
@property(readwrite,retain) NSString *subject;
@property(readwrite,retain) NSString *date;
@property(readwrite,retain) NSString *body;

@end
