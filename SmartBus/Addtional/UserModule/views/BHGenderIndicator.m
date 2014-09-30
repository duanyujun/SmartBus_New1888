//
//  BHGenderIndicator.m
//  SmartBus
//
//  Created by launching on 14-3-6.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHGenderIndicator.h"
#import "NSDate+Helper.h"

@implementation BHGenderIndicator

- (id)initWithPosition:(CGPoint)point
{
    if ( self = [super initWithFrame:CGRectMake(point.x, point.y, 15, 15)] )
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
    }
    return self;
}

- (void)indicatorUser:(BHUserModel *)user
{
    if ( self.subviews.count > 0 )
    {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    self.backgroundColor = user.ugender == USER_GENDER_MALE ? RGB(33, 194, 247) : RGB(232, 76, 61);
    
    NSString *symbol = user.ugender == USER_GENDER_MALE ? @"♂" : @"♀";
    NSInteger age = [NSDate ageFromString:user.birth withFormat:@"yyyy-MM-dd"];
    NSString *string = [NSString stringWithFormat:@"%@  %d", symbol, age];
    CGSize size = [string sizeWithFont:FONT_SIZE(10) byWidth:200];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, size.width, 15)];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_SIZE(10);
    label.textColor = [UIColor whiteColor];
    label.text = string;
    [self addSubview:label];
    [label release];
    
    CGRect frame = self.frame;
    frame.size.width = size.width + 10;
    self.frame = frame;
}

@end
