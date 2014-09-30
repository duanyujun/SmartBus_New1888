//
//  BHCheckModel.m
//  SmartBus
//
//  Created by launching on 13-11-15.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHCheckModel.h"

@implementation BHCheckModel

@synthesize ctime, staid, userid, coor;

- (void)dealloc
{
    SAFE_RELEASE(ctime);
    [super dealloc];
}

@end
