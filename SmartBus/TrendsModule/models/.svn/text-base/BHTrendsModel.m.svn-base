//
//  BHTrendsModel.m
//  SmartBus
//
//  Created by launching on 13-11-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTrendsModel.h"

@implementation BHTrendsModel

@synthesize feedid, weibaId, weiba, title, content, user, ctime, coor, address, images, cnum, dnum, digg, hide, fromSelf;

- (id)init
{
    if ( self = [super init] )
    {
        self.images = [NSMutableArray arrayWithCapacity:0];
        user = [[BHUserModel alloc] init];
    }
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE(content);
    SAFE_RELEASE(weiba);
    SAFE_RELEASE(user);
    SAFE_RELEASE(ctime);
    SAFE_RELEASE(address);
    SAFE_RELEASE(images);
    [super dealloc];
}

- (void)addImage:(id)image
{
    [self.images addObject:image];
}

- (id)imageAtIndex:(NSInteger)idx
{
    return [self.images objectAtIndex:idx];
}

- (NSInteger)countOfImages
{
    return self.images.count;
}

- (CGFloat)getHeight
{
    CGFloat y = 48.f;
    CGSize size = [self.title sizeWithFont:FONT_SIZE(14) byWidth:fromSelf ? 280.f : 220.f];
    y += size.height + 8.f;
    if ( self.images.count > 0 ) {
        y += 68.f;
    }
    y += 42.f;
    y += 40.f;
    return y;
}

- (CGFloat)getDescHeight
{
    CGFloat y = 60.f;
    CGSize size = [self.content sizeWithFont:FONT_SIZE(14) byWidth:220.f];
    y += size.height + 8.f;
    if ( self.images.count > 0 ) {
        y += 68.f;
    }
    y += 80.f;
    return y;
}

@end
