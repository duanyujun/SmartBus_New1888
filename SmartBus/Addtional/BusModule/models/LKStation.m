//
//  LKStation.m
//  SmartBus
//
//  Created by launching on 14-6-19.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "LKStation.h"

@implementation LKStation

@synthesize st_id, weiba_id, st_name, st_level, st_real_lat, st_real_lon, distance, st_routes;

- (void)dealloc
{
    SAFE_RELEASE(st_name);
    SAFE_RELEASE(st_routes);
    [super dealloc];
}

- (id)init
{
    if ( self = [super init] ) {
        self.st_routes = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

@end
