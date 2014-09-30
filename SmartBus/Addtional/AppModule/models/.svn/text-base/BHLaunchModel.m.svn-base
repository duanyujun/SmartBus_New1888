//
//  BHLaunchModel.m
//  SmartBus
//
//  Created by launching on 13-9-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHLaunchModel.h"
#import "BHDefines.h"

@implementation BHLaunchModel

DEF_SINGLETON( BHLaunchModel );

@synthesize adv_id, splash, adv, version, tips, forced;

- (void)dealloc
{
    SAFE_RELEASE(splash);
    SAFE_RELEASE(adv);
    SAFE_RELEASE(version);
    SAFE_RELEASE(tips);
    [super dealloc];
}

@end
