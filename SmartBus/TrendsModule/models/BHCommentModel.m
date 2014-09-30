//
//  BHCommentModel.m
//  SmartBus
//
//  Created by launching on 13-11-12.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHCommentModel.h"

@implementation BHCommentModel

@synthesize cid, content, ctime, user;

- (id)init
{
    if ( self = [super init] ) {
        user = [[BHUserModel alloc] init];
    }
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE(content);
    SAFE_RELEASE(ctime);
    SAFE_RELEASE(user);
    [super dealloc];
}

@end
