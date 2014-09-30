//
//  SBAnnotation.m
//  SmartBus
//
//  Created by launching on 14-4-23.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "SBAnnotation.h"

@implementation SBAnnotation

- (id)init
{
    if ( self = [super init] )
    {
        self.mode = SBAnnoModeNone;
        self.index = NSNotFound;
        self.canCallout = NO;
    }
    return self;
}

@end
