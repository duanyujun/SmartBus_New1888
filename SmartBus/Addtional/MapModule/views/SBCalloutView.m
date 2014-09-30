//
//  SBCalloutView.m
//  SmartBus
//
//  Created by launching on 14-4-24.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "SBCalloutView.h"

#define kArrorHeight    10

@implementation SBCalloutView

- (void)dealloc
{
    SAFE_RELEASE(__title);
    SAFE_RELEASE(__subtitle);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)fillCalloutTitle:(NSString *)title andSubtitle:(NSString *)subtitle
{
    if ( title && title.length > 0 )
    {
        SAFE_RELEASE(__title)
        __title = [title retain];
    }
    
    if ( subtitle && subtitle.length > 0 )
    {
        SAFE_RELEASE(__subtitle);
        __subtitle = [subtitle retain];
    }
    
    [self setNeedsDisplay];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [self.layer addAnimation:animation forKey:nil];
}

- (void)dismiss
{
    [self removeFromSuperview];
}


#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
    
    // Draw the title and the separator with shadow
    CGSize size = [__title sizeWithFont:TTFONT_SIZED(14) byWidth:self.width-10];
    CGPoint point = CGPointMake((self.width-size.width)/2, (__subtitle && ![__subtitle empty]) ? 5. : (self.height-10-size.height)/2);
    CGRect rect = CGRectMake(point.x, point.y, size.width, size.height);
    [[UIColor darkGrayColor] setFill];
    [__title drawInRect:rect withFont:TTFONT_SIZED(14)];
    
    if ( __subtitle && ![__subtitle empty] )
    {
        CGRect subRect = CGRectMake(point.x, rect.origin.y+rect.size.height+5, self.width-10., 16.);
        [[UIColor lightGrayColor] setFill];
        [__subtitle drawInRect:subRect withFont:TTFONT_SIZED(14)];
    }
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

@end
