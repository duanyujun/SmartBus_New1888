//
//  BHPlanModel.m
//  SmartBus
//
//  Created by launching on 13-10-14.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPlanModel.h"

@implementation BHPlanModel

@synthesize type, rname, distance, snumber, ename;

- (void)dealloc
{
    SAFE_RELEASE(rname);
    SAFE_RELEASE(ename);
    [super dealloc];
}

@end
