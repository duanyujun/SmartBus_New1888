//
//  BHRoutePopoupView.m
//  SmartBus
//
//  Created by launching on 13-11-18.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHRoutePopoupView.h"

@interface BHRoutePopoupView ()
{
    UIControl *layer;
    UIView *container;
    BOOL _collected;  // 是否已收藏
}
@end

#define kPopoupHeight   60.f
#define kItemBaseTag    18257

@implementation BHRoutePopoupView

DEF_SINGLETON( BHRoutePopoupView );

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(layer);
    SAFE_RELEASE_SUBVIEW(container);
    [super dealloc];
}

- (id)init
{
    if ( self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]] )
    {
        self.backgroundColor = [UIColor clearColor];
        
        layer = [[UIControl alloc] initWithFrame:self.bounds];
        layer.backgroundColor = [UIColor blackColor];
        layer.alpha = 0.3f;
        [layer addTarget:self action:@selector(handleTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:layer];
        
        container = [[UIView alloc] initWithFrame:CGRectMake(0.f, -kPopoupHeight, self.frame.size.width, kPopoupHeight)];
        container.backgroundColor = [UIColor whiteColor];
        container.layer.shadowColor = [UIColor blackColor].CGColor;
        container.layer.shadowOffset = CGSizeMake(0, 1);
        container.layer.shadowOpacity = 0.9f;
        container.layer.shadowRadius = 6.f;
        [self addSubview:container];
        
        NSArray *items = [NSArray arrayWithObjects:@"线路详情", @"收藏线路", @"线路地图", nil];
        NSArray *images = [NSArray arrayWithObjects:@"icon_about.png", @"icon_my_collection.png", @"icon_map.png", nil];
        CGFloat width = (self.frame.size.width - 2.f ) / items.count;
        
        for (int i = 0; i < items.count; i++)
        {
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(i*(width+1.f), 0.f, width, kPopoupHeight);
            item.backgroundColor = [UIColor clearColor];
            item.tag = kItemBaseTag + i;
            
            UIImage *image = [UIImage imageNamed:[images objectAtIndex:i]];
            UIImageView *iconImageView = [[UIImageView alloc] initWithImage:image];
            iconImageView.frame = CGRectMake((width-image.size.width)/2, 10.f, image.size.width, image.size.height);
            [item addSubview:iconImageView];
            [iconImageView release];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 5.f+image.size.height, width-20.f, kPopoupHeight-image.size.height-5.f)];
            label.backgroundColor = [UIColor clearColor];
            label.font = FONT_SIZE(14);
            label.textAlignment = UITextAlignmentCenter;
            label.text = [items objectAtIndex:i];
            [item addSubview:label];
            [label release];
            
            UIView *vline = [[UIView alloc] initWithFrame:CGRectMake(width, 0.f, 1.f, kPopoupHeight)];
            vline.backgroundColor = [UIColor flatWhiteColor];
            [item addSubview:vline];
            [vline release];
            
            [item addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
            [container addSubview:item];
        }
    }
    return self;
}

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    [self setFrame:view.bounds];
    [layer setFrame:self.bounds];
    [container setFrame:CGRectMake(0.f, -kPopoupHeight+y_offset+10, self.frame.size.width, kPopoupHeight)];
    
    [view addSubview:self];
    
    if ( animated )
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rc = container.frame;
            rc.origin.y = 0.f;
            container.frame = rc;
        }];
    }
    else
    {
        CGRect rc = container.frame;
        rc.origin.y = 0.f;
        container.frame = rc;
    }
}

- (void)hideWithAnimated:(BOOL)animated
{
    if ( animated )
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rc = container.frame;
            rc.origin.y = -kPopoupHeight+y_offset+10;
            container.frame = rc;
        } completion:^(BOOL finished) {
            if ( finished ) {
                [self removeFromSuperview];
            }
        }];
    }
    else
    {
        [self removeFromSuperview];
    }
}

- (BOOL)isShowing
{
    return self.superview != nil;
}

- (BOOL)isCollected
{
    return _collected;
}

- (void)setCollected:(BOOL)collected
{
    _collected = collected;
    
    UIButton *item = (UIButton *)[container viewWithTag:kItemBaseTag + 1];
    UIImageView *iconImageView = (UIImageView *)[item.subviews objectAtIndex:0];
    UILabel *label = (UILabel *)[item.subviews objectAtIndex:1];
    if ( collected )
    {
        [iconImageView setImage:[UIImage imageNamed:@"icon_collectioned.png"]];
        [label setText:@"已收藏"];
    }
    else
    {
        [iconImageView setImage:[UIImage imageNamed:@"icon_my_collection.png"]];
        [label setText:@"收藏线路"];
    }
}


#pragma mark - 
#pragma mark button events

- (void)handleTouched:(UIButton *)sender
{
    [self hideWithAnimated:YES];
}

- (void)itemSelected:(UIButton *)sender
{
    NSInteger idx = sender.tag - kItemBaseTag;
    if ( idx != 1 ) {
        [self hideWithAnimated:YES];
    }
    
    if ( [self.delegate respondsToSelector:@selector(routePopoupView:didSelectAtIndex:)] )
    {
        [self.delegate routePopoupView:self didSelectAtIndex:idx];
    }
}

@end
