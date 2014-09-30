//
//  BHMoodVIew.m
//  SmartBus
//
//  Created by 王 正星 on 13-12-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHMoodVIew.h"

@interface BHMoodVIew ()
{
    UILabel *tipsLbl;
}
@end

@implementation BHMoodVIew

- (void)dealloc
{
    [super dealloc];
    SAFE_RELEASE_SUBVIEW(tipsLbl);
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *container = [[UIView alloc]initWithFrame:CGRectMake(10.f, 0.f, 300.f, frame.size.height)];
        UIImageView *container_Bg = [[UIImageView alloc]initWithFrame:container.bounds];
        [container_Bg setImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f]];
        [container addSubview:container_Bg];
        [container_Bg release];
        
        UILabel *contentLbl = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 10.f, 150.f, 20.f)];
        [contentLbl setBackgroundColor:[UIColor clearColor]];
        [contentLbl setFont:FONT_SIZE(12.f)];
        [contentLbl setTextColor:[UIColor grayColor]];
        [contentLbl setText:@"说说今天的心情吧"];
        [container addSubview:contentLbl];
        [contentLbl release];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(120.f, 10.f, 15.f, 15.f)];
        [icon setImage:[UIImage imageNamed:@"mood_icon"]];
        [container addSubview:icon];
        [icon release];

        tipsLbl = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 30.f, 280.f, 20.f)];
        [tipsLbl setBackgroundColor:[UIColor clearColor]];
        [tipsLbl setFont:FONT_SIZE(12.f)];
        [tipsLbl setTextColor:[UIColor redColor]];
        [tipsLbl setText:@"分享心情还可获得15银币哦"];
        [container addSubview:tipsLbl];
        
        [self.backgroundImageView addSubview:container];
        [container release];
    }
    return self;
}

- (void)setFistPub:(BOOL)isFirst
{
    [tipsLbl setAlpha:isFirst];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
