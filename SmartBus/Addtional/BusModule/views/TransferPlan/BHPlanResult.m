//
//  BHPlanResult.m
//  SmartBus
//
//  Created by launching on 13-10-14.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPlanResult.h"

@implementation BHPlanResult

@synthesize lines, time, distance, number, plans;

- (void)dealloc
{
    SAFE_RELEASE(lines);
    SAFE_RELEASE(time);
    SAFE_RELEASE(plans);
    [super dealloc];
}

- (id)init
{
    if ( self = [super init] ) {
        self.lines = [NSMutableArray arrayWithCapacity:0];
        self.plans = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)addPlan:(id)anObject
{
    [self.plans addObject:anObject];
}

- (void)insertPlan:(id)anObject atIndex:(int)idx
{
    [self.plans insertObject:anObject atIndex:idx];
}

- (id)planAtIndex:(int)idx
{
    return [self.plans objectAtIndex:idx];
}

@end
