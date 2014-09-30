//
//  BHErrorPicker.m
//  SmartBus
//
//  Created by launching on 14-8-1.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHErrorPicker.h"

#define TAG_ITEM_BASE   8247

@implementation BHErrorPicker
{
    UIView *popoupView;
    NSArray *__errors;
    BHErrorPickHandler __handler;
}

- (id)initWithErrors:(NSArray *)errors
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        self.backgroundColor = [UIColor clearColor];
        
        __errors = [errors retain];
        
        UIControl *layer = [[UIControl alloc] initWithFrame:self.bounds];
        layer.backgroundColor = [UIColor blackColor];
        layer.alpha = 0.3;
        [layer addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:layer];
        [layer release];
        
        popoupView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.height-88)/2, self.width, 88)];
        popoupView.backgroundColor = [UIColor whiteColor];
        popoupView.layer.shadowColor = [UIColor blackColor].CGColor;
        popoupView.layer.shadowOffset = CGSizeMake(0, 0);
        popoupView.layer.shadowOpacity = 0.9f;
        popoupView.layer.shadowRadius = 6.f;
        [self addSubview:popoupView];
        
        for (int i = 0; i < __errors.count; i++)
        {
            UIButton *item = [self buttonWithError:[__errors objectAtIndex:i]];
            [item addTarget:self action:@selector(itemDidSelected:) forControlEvents:UIControlEventTouchUpInside];
            [popoupView addSubview:item];
        }
    }
    return self;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    [window addSubview:self];
    
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5f;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [popoupView.layer addAnimation:animation forKey:nil];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        popoupView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)didSelectBlock:(BHErrorPickHandler)block
{
    SAFE_RELEASE(__handler);
    __handler = [block copy];
}


#pragma mark - private methods

- (UIButton *)buttonWithError:(NSString *)error
{
    int idx = [__errors indexOfObject:error];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.f, idx*44, 320.f, 44);
    button.tag = idx + TAG_ITEM_BASE;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 290, 44)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = TTFONT_BOLD_SIZE(15);
    nameLabel.text = error;
    [button addSubview:nameLabel];
    [nameLabel release];
    
    if (idx == 0) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
        line.backgroundColor = [UIColor flatGrayColor];
        [button addSubview:line];
        [line release];
    }
    
    return button;
}

- (void)handleTouched:(id)sender
{
    [self dismiss];
}

- (void)itemDidSelected:(id)sender
{
    int idx = [sender tag] - TAG_ITEM_BASE;
    
    if ( __handler ) {
        __handler( idx );
    }
    
    [self dismiss];
}

@end
