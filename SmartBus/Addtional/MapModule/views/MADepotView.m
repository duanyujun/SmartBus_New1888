//
//  MADepotView.m
//  SmartBus
//
//  Created by launching on 13-12-6.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "MADepotView.h"

@interface MADepotView ()
{
    UIImageView *stickImageView;
    UIImageView *boardImageView;
    UIImageView *fontImageView;
    UILabel *titleLabel;
}
@end

@implementation MADepotView

@synthesize depotName = _depotName;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(stickImageView);
    SAFE_RELEASE_SUBVIEW(boardImageView);
    SAFE_RELEASE_SUBVIEW(fontImageView);
    SAFE_RELEASE_SUBVIEW(titleLabel);
    SAFE_RELEASE(_depotName);
    [super dealloc];
}

- (id)init
{
    if ( self = [super initWithFrame:CGRectZero] )
    {
        stickImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_gunzi.png"]];
        stickImageView.frame = CGRectMake(0.f, 0.f, 5.f, 63.f);
        [self addSubview:stickImageView];
        
        boardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_roadsign.png" stretched:CGPointMake(10.f, 10.f)]];
        boardImageView.frame = CGRectMake(0.f, 0.f, 79.f, 28.f);
        [self addSubview:boardImageView];
        
        fontImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"font_station.png"]];
        fontImageView.frame = CGRectMake(0.f, 0.f, 38.f, 5.f);
        [boardImageView addSubview:fontImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 20.f, 20.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = BOLD_FONT_SIZE(14);
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [boardImageView addSubview:titleLabel];
    }
    return self;
}

- (void)setDepotName:(NSString *)depotName
{
    SAFE_RELEASE(_depotName);
    _depotName = [depotName retain];
    
    CGSize size = [_depotName sizeWithFont:BOLD_FONT_SIZE(14) byWidth:300.f];
    titleLabel.text = _depotName;
    [self setFrame:CGRectMake(0.f, 0.f, size.width+20.f, 63.f)];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if ( self.subviews.count > 0 )
    {
        titleLabel.frame = CGRectMake(10.f, 1.f, frame.size.width-20.f, 20.f);
        boardImageView.frame = CGRectMake(0.f, 8.f, frame.size.width, 28.f);
        fontImageView.frame = CGRectMake((frame.size.width-38.f)/2, 22.f, 38.f, 4.f);
        stickImageView.frame = CGRectMake((frame.size.width-5.f)/2, 0.f, 5.f, 63.f);
    }
}

@end
