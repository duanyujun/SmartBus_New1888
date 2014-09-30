//
//  BHTaskRegModel.m
//  SmartBus
//
//  Created by launching on 13-12-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTaskRegModel.h"

@implementation BHTaskRegModel

@synthesize publish, dates;

- (void)dealloc
{
    SAFE_RELEASE(dates);
    [super dealloc];
}

- (id)init
{
    if ( self = [super init] )
    {
        self.dates = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

@end
