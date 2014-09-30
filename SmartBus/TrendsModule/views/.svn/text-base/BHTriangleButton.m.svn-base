//
//  BHTriangleButton.m
//  SmartBus
//
//  Created by launching on 14-1-17.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHTriangleButton.h"

@interface BHTriangleButton ()
{
    UILabel *titleNameLabel;
}
@end

@implementation BHTriangleButton

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 8.f, 65.f, 24.f)];
        titleNameLabel.backgroundColor = [UIColor clearColor];
        titleNameLabel.font = BOLD_FONT_SIZE(16);
        [self addSubview:titleNameLabel];
        
        UIView *hline = [[UIView alloc] initWithFrame:CGRectMake(0.f, 30.f, 65.f, 1.f)];
        hline.backgroundColor = [UIColor blackColor];
        [self addSubview:hline];
        [hline release];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(64.f, 20.f, 11.f, 11.f)];
        iconImageView.backgroundColor = [UIColor clearColor];
        iconImageView.image = [UIImage imageNamed:@"icon_triangle.png"];
        [self addSubview:iconImageView];
        [iconImageView release];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [titleNameLabel setText:title];
}

- (void)setEnabled:(BOOL)enabled
{
    UIImageView *iconImageView = (UIImageView *)[self.subviews objectAtIndex:2];
    iconImageView.hidden = !enabled;
    
    UIView *hline = [self.subviews objectAtIndex:1];
    hline.hidden = !enabled;
}

@end
