/*
 *  Constants.h
 *  MsgsMobile
 *
 *  Created by ivan on 1/10/10.
 *  Copyright 2010 - 3boxed Software. All rights reserved.
 *
 */

#ifndef __SERVER_INFORMATION__
#define __SERVER_INFORMATION__

#define MSGS_SERVER_URL @"msgs://your.msgs.server"

#define MSGS_BOUNDS     [MSGS_SERVER_URL stringByAppendingString: @"/bounds"]
#define MSGS_RC_READ    [MSGS_SERVER_URL stringByAppendingString: @"/rc-read"]
#define MSGS_MESSAGE    [MSGS_SERVER_URL stringByAppendingString: @"/msg/%d"]

#endif
