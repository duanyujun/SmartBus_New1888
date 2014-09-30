//
//  BHArticleModel.m
//  SmartBus
//
//  Created by launching on 13-11-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHArticleModel.h"

@implementation BHArticleModel

@synthesize base, attachs;

- (void)dealloc
{
    SAFE_RELEASE(base);
    SAFE_RELEASE(attachs);
    [super dealloc];
}


- (id)init
{
    if ( self = [super init] )
    {
        self.attachs = [NSMutableArray arrayWithCapacity:0];
        base = [[BHArticleBase alloc] init];
    }
    return self;
}


- (void)addAttach:(id)attach
{
    [self.attachs addObject:attach];
}

- (id)attachAtIndex:(NSInteger)index
{
    return [self.attachs objectAtIndex:index];
}

- (NSInteger)countOfAttachs
{
    return [self.attachs count];
}


//================================================================//

- (CGFloat)heightOfSubject
{
    CGFloat height = 8.f;
    CGSize size = [self.base.subject sizeWithFont:BOLD_FONT_SIZE(16) constrainedToSize:CGSizeMake(304.f, 200.f)];
    height += size.height + 3.f;
    height += 28.f;
    return height;
}


- (CGFloat)heightOfSummary
{
    CGFloat height = 8.f;
    height += self.attachs.count * (148.f + 8.f);
    CGSize size = [self.base.subject sizeWithFont:FONT_SIZE(15) constrainedToSize:CGSizeMake(304.f, MAXFLOAT)];
    height += size.height + 20.f;
    return height;
}

@end
