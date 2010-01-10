//
//  MessageHeaderViewContent.h
//  MsgsMobile
//
//  Created by ivan on 6/16/09.
//  Copyright 2009 - 3boxed Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageHeaderViewContent : UIView {
	NSString *author;
	NSString *subject;
	NSString *date;
	BOOL highlighted;
	BOOL hasBeenRead;
}

@property(nonatomic, getter=isHighlighted) BOOL highlighted;
@property(nonatomic, getter=hasBeenRead) BOOL hasBeenRead;
@property(readwrite,assign) NSString *author;
@property(readwrite,assign) NSString *subject;
@property(readwrite,assign) NSString *date;

@end
