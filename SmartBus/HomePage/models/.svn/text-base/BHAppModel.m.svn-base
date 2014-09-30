//
//  BHAppModel.m
//  SmartBus
//
//  Created by launching on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAppModel.h"

@implementation BHAppModel

@synthesize banners, recommend, liveinfo;

- (void)dealloc
{
    SAFE_RELEASE(banners);
    SAFE_RELEASE(recommend);
    SAFE_RELEASE(liveinfo);
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        self.banners = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)addBanner:(id)banner
{
    [self.banners addObject:banner];
}

- (id)bannerAtIndex:(NSInteger)index
{
    return [self.banners objectAtIndex:index];
}

@end
