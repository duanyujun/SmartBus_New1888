//
//  LKAdditionInfo.m
//  SmartBus
//
//  Created by launching on 13-10-24.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "LKAdditionInfo.h"

@implementation LKAdditionInfo

@synthesize wait, collect_id, notice;
@synthesize banners, section, ledad;

- (id)init
{
    if ( self = [super init] )
    {
        self.banners = [NSMutableArray arrayWithCapacity:0];
        section = [[BHSectionModel alloc] init];
    }
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE(section);
    SAFE_RELEASE(notice);
    SAFE_RELEASE(banners);
    SAFE_RELEASE(ledad);
    [super dealloc];
}

- (void)addBanner:(id)banner
{
    [self.banners addObject:banner];
}

- (id)bannerAtIndex:(NSInteger)idx
{
    return [self.banners objectAtIndex:idx];
}

- (void)removeAllBanners
{
    [self.banners removeAllObjects];
}

@end
