//
//  MessageHeaderViewCell.h
//  MsgsMobile
//
//  Created by ivan on 6/3/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageHeaderViewContent.h"

@interface MessageHeaderViewCell : UITableViewCell {
	MessageHeaderViewContent *headerContentView;
	BOOL shouldDrawLastReadMarker;
}

@property(readwrite,assign) NSString *author;
@property(readwrite,assign) NSString *subject;
@property(readwrite,assign) NSString *date;

- (void)setLastReadMarker:(BOOL)value;
- (void)setHasBeenRead:(BOOL)value;
@end
