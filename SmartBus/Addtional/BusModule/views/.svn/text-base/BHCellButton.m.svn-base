//
//  BHCellButton.m
//  SmartBus
//
//  Created by launching on 13-10-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHCellButton.h"
#import "BHBadgeView.h"

@implementation BHCellButton
{
    BHBadgeView *_badgeView;
}

@synthesize number = _number;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(_badgeView);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if ( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:10.f topCapHeight:10.f]];
        bubbleImageView.frame = self.bounds;
        [self addSubview:bubbleImageView];
        [bubbleImageView release];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_members.png"]];
        iconImageView.frame = CGRectMake(10.f, 12.f, 20.f, 20.f);
        [self addSubview:iconImageView];
        [iconImageView release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(36.f, 12.f, 100.f, 20.f)];
        label.backgroundColor = [UIColor clearColor];
        label.font = FONT_SIZE(15);
        label.text = @"一起等车的人";
        [self addSubview:label];
        [label release];
        
        _badgeView = [[BHBadgeView alloc] initWithFrame:CGRectMake(260.f, 10.f, 24.f, 24.f)];
        _badgeView.badgeColor = [UIColor flatOrangeColor];
        _badgeView.fontSize = 14;
        _badgeView.badgeNumber = 0;
        [self addSubview:_badgeView];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right_arrow.png"]];
        arrowImageView.frame = CGRectMake(290.f, 16.f, 6.f, 12.f);
        [self addSubview:arrowImageView];
        [arrowImageView release];
    }
    return self;
}

- (void)setNumber:(NSInteger)number
{
    _number = number;
    _badgeView.badgeNumber = _number;
}

@end
