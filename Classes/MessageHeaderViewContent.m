//
//  MessageHeaderViewContent.m
//  MsgsMobile
//
//  Created by ivan on 6/16/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import "MessageHeaderViewContent.h"

/*
 * Originally this code was in the custom table view cell class, but
 * soon realized that 'highlighted' background view appears between
 * cell content (in front, here), and the underlying view of the cell
 * itself (behind).  So if you draw on the table cell's view directly,
 * the blue highlighted background will hide all content from drawRect.
 */
@implementation MessageHeaderViewContent

@synthesize author;
@synthesize subject;
@synthesize date;
@synthesize highlighted;
@synthesize hasBeenRead;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self setOpaque:YES];
		self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setHighlighted:(BOOL)lit {
	if (highlighted != lit) {
		highlighted = lit;	
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect
{
	if (highlighted) {
		[[UIColor whiteColor] set];
	} else {
		if (hasBeenRead) {
			[[UIColor lightGrayColor] set];
		} else {
			[[UIColor blackColor] set];
		}
		self.backgroundColor = [UIColor whiteColor];
	}
	
	[subject drawAtPoint:CGPointMake(20.0, 3.0) withFont:[UIFont boldSystemFontOfSize:16.0]];
	[author drawAtPoint:CGPointMake(20.0, 35.0) withFont:[UIFont systemFontOfSize:12.0]];
	[date drawAtPoint:CGPointMake(151.0, 35.0) withFont:[UIFont systemFontOfSize:12.0]];
	[super drawRect:rect];
}

- (void)dealloc {
	[author release];
	[subject release];
	[date release];
    [super dealloc];
}

@end
