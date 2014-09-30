//
//  BHPhotoModel.m
//  SmartBus
//
//  Created by launching on 13-11-13.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPhotoModel.h"

@implementation BHPhotoModel

@synthesize dtime, links;

- (id)init
{
    if ( self = [super init] )
    {
        self.links = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE(links);
    SAFE_RELEASE(dtime);
    [super dealloc];
}

- (CGFloat)getHeight
{
    CGFloat height = 50.f;
    height += (ceil((float)self.links.count/4) * (65.f + 8.f));
    return height;
}

@end
