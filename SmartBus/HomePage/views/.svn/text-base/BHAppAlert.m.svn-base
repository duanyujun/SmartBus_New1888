//
//  BHAppAlert.m
//  SmartBus
//
//  Created by launching on 14-3-13.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHAppAlert.h"

#define kNoticeLabelTag  3689
#define kButtonBaseTag   3769

@implementation BHAppAlert
{
    UIView *_container;
}

DEF_SIGNAL( CANCEL );
DEF_SINGLETON( BHAppAlert );

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:[UIScreen mainScreen].bounds] )
    {
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 136)];
        _container.backgroundColor = [UIColor whiteColor];
        _container.layer.masksToBounds = YES;
        _container.layer.cornerRadius = 4;
        _container.center = self.center;
        [self addSubview:_container];
        
        UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, _container.width-30, 60)];
        noticeLabel.backgroundColor = [UIColor clearColor];
        noticeLabel.tag = kNoticeLabelTag;
        noticeLabel.font = TTFONT_SIZED(14);
        noticeLabel.textColor = [UIColor darkGrayColor];
        noticeLabel.textAlignment = UITextAlignmentCenter;
        noticeLabel.numberOfLines = 0;
        [_container addSubview:noticeLabel];
        [noticeLabel release];
        
        BeeUIButton *button = [BeeUIButton new];
        button.frame = CGRectMake(15, 90, _container.width-30, 36);
        button.tag = kButtonBaseTag;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = RGBA(0, 0, 0, 0.5).CGColor;
        button.titleColor = [UIColor blackColor];
        button.titleFont = TTFONT_SIZED(15);
        button.title = @"知道了";
        [button addSignal:self.CANCEL forControlEvents:UIControlEventTouchUpInside];
        [_container addSubview:button];
    }
    return self;
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.CANCEL] )
    {
        [self hide];
    }
}

- (void)reloadMessage:(NSString *)message
{
    CGSize size = [message sizeWithFont:TTFONT_SIZED(14) byWidth:_container.width-30];
    
    UILabel *noticeLabel = (UILabel *)[_container viewWithTag:kNoticeLabelTag];
    noticeLabel.text = message;
    
    CGRect rect = noticeLabel.frame;
    rect.size.height = size.height;
    noticeLabel.frame = rect;
    
    BeeUIButton *button = (BeeUIButton *)[_container viewWithTag:kButtonBaseTag];
    rect = button.frame;
    rect.origin.y = 30 + size.height;
    button.frame = rect;
    
    // 重设CONTAINER的frame
    rect = _container.frame;
    rect.size.height = 30 + size.height + 36 + 10;
    _container.frame = rect;
    _container.center = self.center;
}

- (void)showMessage:(NSString *)message inView:(UIView *)view
{
    [view addSubview:self];
    [self reloadMessage:message];
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_container.layer addAnimation:animation forKey:nil];
}

- (void)hide
{
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
