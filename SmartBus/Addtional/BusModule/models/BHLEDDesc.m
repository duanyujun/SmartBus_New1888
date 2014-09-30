//
//  BHLEDDesc.m
//  SmartBus
//
//  Created by launching on 14-1-27.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHLEDDesc.h"

@implementation BHLEDDesc

@synthesize rid, rname, dest, busId, currentLevel, theLevel, distance, rtime;

- (void)dealloc
{
    SAFE_RELEASE(rname);
    SAFE_RELEASE(dest);
    [super dealloc];
}

@end
