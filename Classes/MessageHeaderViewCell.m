//
//  MessageHeaderViewCell.m
//  MsgsMobile
//
//  Created by ivan on 6/3/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import "MessageHeaderViewCell.h"


@implementation MessageHeaderViewCell

@dynamic author, subject, date;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewStylePlain reuseIdentifier:reuseIdentifier];
	if (self != nil) {
		[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		CGRect frame = CGRectMake(0.0, 4.0, self.contentView.bounds.size.width, (self.contentView.bounds.size.height - 4));
		headerContentView = [[MessageHeaderViewContent alloc] initWithFrame:frame];
		headerContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:headerContentView];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	if (shouldDrawLastReadMarker) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetLineWidth(context, 4);
		CGContextSetRGBStrokeColor(context, 0.8, 0.3, 0.3, 1.0);
		CGContextMoveToPoint(context, 0, 0);
		CGContextAddLineToPoint(context, rect.size.width, 0);
		CGContextStrokePath(context);
	} else {
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetLineWidth(context, 1);
		CGContextSetGrayStrokeColor(context, 0.2, 1.0);
		CGContextMoveToPoint(context, 0, 0);
		CGContextAddLineToPoint(context, rect.size.width, 0);
		CGContextStrokePath(context);
	}
	[super drawRect:rect];
}

/*
 * Passing through calls to the underlying view
 */
- (void)setAuthor:(NSString *)value {
	headerContentView.author = value;
}

/*
 * Passing through calls to the underlying view
 */
- (void)setSubject:(NSString *)value {
	headerContentView.subject = value;
}

/*
 * Passing through calls to the underlying view
 */
- (void)setDate:(NSString *)value {
	headerContentView.date = value;
}

/*
 * Passing through calls to the underlying view
 */
- (void)setHasBeenRead:(BOOL)value {
	headerContentView.hasBeenRead = value;
}

- (void)setLastReadMarker:(BOOL)value {
	shouldDrawLastReadMarker = value;
}


- (void)dealloc {
	[headerContentView release];
    [super dealloc];
}

@end
