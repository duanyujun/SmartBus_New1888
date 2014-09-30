//
//  BHMsgModel.m
//  SmartBus
//
//  Created by launching on 13-12-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHMsgModel.h"

@implementation BHMsgModel

@synthesize msgid, sender, receiver, dtime, content, newnum;

- (id)init
{
    if ( self = [super init] )
    {
        sender = [[BHUserModel alloc] init];
        receiver = [[BHUserModel alloc] init];
    }
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE(sender);
    SAFE_RELEASE(receiver);
    SAFE_RELEASE(content);
    [super dealloc];
}

- (void)setContent:(NSString *)ccontent
{
    [content release];
    content = [ccontent retain];
    self.msgContentHeight = [self heightForMessage];
}

- (NSString *)content
{
    return content;
}

#pragma mark -
#pragma mark public methods

- (CGFloat)heightForMsgList
{
    CGFloat height = 16.f;
    height += 45.f;
    return height;
}

- (CGFloat)heightForMessage
{
    CGFloat height = 16.f;
    CGSize size = [content sizeWithFont:FONT_SIZE(14) byWidth:220.f];
    height += size.height;
    
    self.msgContentWidth = size.width+30.f;
    return height;
}

- (CGFloat)widthForMessage
{
    CGFloat height = 16.f;
    height += 45.f;
    return height;
}


@end
