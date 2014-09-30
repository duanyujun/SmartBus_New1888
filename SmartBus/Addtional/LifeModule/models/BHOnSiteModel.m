//
//  BHOnSiteModel.m
//  SmartBus
//
//  Created by launching on 13-11-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHOnSiteModel.h"

@implementation BHOnSiteModel

@synthesize disId, author, title, remark, date, level, ugroup, ucity, attachs;

- (void)dealloc
{
    SAFE_RELEASE(author);
    SAFE_RELEASE(title);
    SAFE_RELEASE(remark);
    SAFE_RELEASE(date);
    SAFE_RELEASE(ugroup);
    SAFE_RELEASE(ucity);
    SAFE_RELEASE(attachs);
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        self.attachs = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)addAttach:(id)attach {
    [self.attachs addObject:attach];
}

- (id)attachAtIndex:(NSInteger)index {
    return [self.attachs objectAtIndex:index];
}

- (NSInteger)countOfAttachs {
    return [self.attachs count];
}


- (CGFloat)discloseTableCellHeight
{
    CGFloat height = 8.f * 2;  // 上下边框空白
    height += 25.f;  // 标题高度
    height += 22.f;
    
    if ([self.attachs count] > 0) {
        height += 60.f;
    }
    
    CGSize size = [self.remark sizeWithFont:FONT_SIZE(14) constrainedToSize:CGSizeMake(240.f, 50.f)];
    height += size.height;
    return height;
}

@end
