//
//  BHGroupModel.m
//  SmartBus
//
//  Created by launching on 13-12-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHGroupModel.h"

@implementation BHGroupModel

@synthesize gpid, gpname, cover, attnum, postnum, intro, notify, focused;

- (void)dealloc
{
    SAFE_RELEASE(gpname);
    SAFE_RELEASE(cover);
    SAFE_RELEASE(intro);
    SAFE_RELEASE(notify);
    [super dealloc];
}

- (CGFloat)getGroupIntroHeight
{
    CGFloat height = 42.f * 2;
    CGSize size = [self.intro sizeWithFont:FONT_SIZE(14) byWidth:276.f];
    height += size.height;
    size = [self.notify sizeWithFont:FONT_SIZE(14) byWidth:276.f];
    height += size.height;
    return height;
}

@end
