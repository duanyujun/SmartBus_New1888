//
//  BHSectionModel.m
//  SmartBus
//
//  Created by launching on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSectionModel.h"

@implementation BHSectionModel

@synthesize tid, subject, summary, cover, wid;

- (void)dealloc
{
    SAFE_RELEASE(subject);
    SAFE_RELEASE(summary);
    SAFE_RELEASE(cover);
    [super dealloc];
}

@end
