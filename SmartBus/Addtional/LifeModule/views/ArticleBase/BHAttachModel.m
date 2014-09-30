//
//  BHAttachModel.m
//  SmartBus
//
//  Created by launching on 13-11-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAttachModel.h"

@implementation BHAttachModel

@synthesize category, summary, text, link, play, size;

- (void)dealloc
{
    SAFE_RELEASE(category);
    SAFE_RELEASE(summary);
    SAFE_RELEASE(text);
    SAFE_RELEASE(link);
    SAFE_RELEASE(play);
    [super dealloc];
}

@end
