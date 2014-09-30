//
//  BHSelectionView.m
//  BusHelper
//
//  Created by launching on 13-9-5.
//  Copyright (c) 2013年 仲 阳. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BHSelectionView.h"
#import "LKRoute.h"

@interface BHSelectionView ()
{
    UIView *popoupView;
    BHSelectionBlock __selectionBlock;
    NSArray *__routes;
}
@end

#define kSelectionItemHeight  88.f
#define kButtonBaseTag  120121

@implementation BHSelectionView

- (void)dealloc
{
    SAFE_RELEASE(popoupView);
    SAFE_RELEASE(__routes);
    [super dealloc];
}

- (id)initWithRoutes:(NSArray *)routes
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        self.backgroundColor = [UIColor clearColor];
        
        __routes = [routes retain];
        
        UIControl *layer = [[UIControl alloc] initWithFrame:self.bounds];
        layer.backgroundColor = [UIColor blackColor];
        layer.alpha = 0.3f;
        [layer addTarget:self action:@selector(handleTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:layer];
        [layer release];
        
        popoupView = [[UIView alloc] initWithFrame:CGRectMake(0.f, (self.frame.size.height-kSelectionItemHeight)/2, self.frame.size.width, kSelectionItemHeight)];
        popoupView.backgroundColor = [UIColor whiteColor];
        popoupView.layer.shadowColor = [UIColor blackColor].CGColor;
        popoupView.layer.shadowOffset = CGSizeMake(0, 0);
        popoupView.layer.shadowOpacity = 0.9f;
        popoupView.layer.shadowRadius = 6.f;
        [self addSubview:popoupView];
        
        for (int i = 0; i < __routes.count; i++)
        {
            UIButton *item = [self buttonWithRoute:[__routes objectAtIndex:i]];
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

- (void)didSelectBlock:(BHSelectionBlock)block
{
    SAFE_RELEASE(__selectionBlock);
    __selectionBlock = [block copy];
}


#pragma mark - private methods

- (UIButton *)buttonWithRoute:(LKRoute *)route
{
    int idx = [__routes indexOfObject:route];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.f, idx*44.f, 320.f, kSelectionItemHeight/2);
    button.tag = idx + kButtonBaseTag;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_direct.png"]];
    iconImageView.frame = CGRectMake(10.f, (44.f-17.f)/2, 22.f, 17.f);
    [button addSubview:iconImageView];
    [iconImageView release];
    
    NSString *name = [NSString stringWithFormat:@"%@ : ", route.line_name];
    CGSize size = [name sizeWithFont:[UIFont boldSystemFontOfSize:14.f] constrainedToSize:CGSizeMake(200.f, 24.f) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.f, 10.f, size.width, 24.f)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:14.f];
    nameLabel.text = name;
    [button addSubview:nameLabel];
    [nameLabel release];
    
    UILabel *directionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.f+size.width, 10.f, 270.f-size.width, 24.f)];
    directionLabel.backgroundColor = [UIColor clearColor];
    directionLabel.font = [UIFont systemFontOfSize:12.f];
    directionLabel.text = [NSString stringWithFormat:@"%@-%@", route.st_start, route.st_end];
    [button addSubview:directionLabel];
    [directionLabel release];
    
    if (idx == 0) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.f, 43.f, 320.f, 1.f)];
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
    int idx = [sender tag] - kButtonBaseTag;
    __selectionBlock( [__routes objectAtIndex:idx] );
    [self removeFromSuperview];
}

@end
