//
//  BHChannelCellVIew.m
//  SmartBus
//
//  Created by 王 正星 on 13-10-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHChannelCellVIew.h"
#import "BHChannelTagView.h"
#import "BHPlayTimeView.h"
#import "UIImageView+WebCache.h"

@interface BHChannelCellVIew ()
{
    UIImageView *screenShot;
    BHChannelTagView *channelTag;
    BHPlayTimeView *beginTime;
    UILabel *beginName;
    BHPlayTimeView *endTime;
    UILabel *nextName;
    BeeUIButton *button;
}
@end
@implementation BHChannelCellVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *containerBg = [[UIImageView alloc]initWithFrame:frame];
        [containerBg setImage:[[UIImage imageNamed:@"bubble"] stretchableImageWithLeftCapWidth:5.f topCapHeight:2.f]];
        [self addSubview:containerBg];
        containerBg.center = CGPointMake(self.width/2.f, self.height/2.f);
        [containerBg release];
        
        UIView *container = [[UIView alloc]initWithFrame:CGRectMake(1.f, 0.f, 143.f, 135.f)];
        [container.layer setMasksToBounds:YES];
        [container.layer setCornerRadius:4.f];
        
        screenShot = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, 143.f, 85)];
        [screenShot setBackgroundColor:[UIColor blackColor]];
        [container addSubview:screenShot];
        
        channelTag = [[BHChannelTagView alloc]initWithFrame:CGRectMake(0.f, 0.f, 83.f, 25.f)];
        [channelTag setTitle:@"江苏卫视" withIconUrl:@"icon_play" withBg:nil];
        [container addSubview:channelTag];
        
        beginTime = [[BHPlayTimeView alloc]initWithFrame:CGRectMake(5.f, 90.f, 50.f, 20.f) withType:BHPlayTimeTypeBegin];
        [container addSubview:beginTime];
        beginName = [[UILabel alloc]initWithFrame:CGRectMake(65.f, beginTime.top, 72.f, 20.f)];
        [beginName setBackgroundColor:[UIColor clearColor]];
        [beginName setFont:[UIFont systemFontOfSize:12.f]];
        beginName.text = @"非诚勿扰";
        [container addSubview:beginName];
        
        endTime = [[BHPlayTimeView alloc]initWithFrame:CGRectMake(5.f, 110.f, 40.f, 20.f) withType:BHPlayTimeTypeEnd];
        [container addSubview:endTime];
        nextName = [[UILabel alloc]initWithFrame:CGRectMake(65.f, endTime.top, 72.f, 20.f)];
        [nextName setBackgroundColor:[UIColor clearColor]];
        [nextName setTextColor:[UIColor lightGrayColor]];
        [nextName setFont:[UIFont systemFontOfSize:12.f]];
        nextName.text = @"爱情公寓｜｜";
        [container addSubview:nextName];
        
        [self addSubview:container];
        
        button = [[BeeUIButton alloc]initWithFrame:self.bounds];
        [button setSignal:@"cellClick"];
        [self addSubview:button];
    }
    return self;
}

- (void)setCellData:(NSDictionary *)dic
{
    [channelTag setTitle:[dic objectForKey:@"channel_name"] withIconUrl:[dic objectForKey:@"channel_logo"] withBg:nil];
    [beginTime setTime:dic[@"now_epg_time"]];
    beginName.text = dic[@"now_epg_name"];
    [endTime setTime:dic[@"next_epg_time"]];
    nextName.text = dic[@"next_epg_name"];
    
    [screenShot setImageWithURL:[NSURL URLWithString:dic[@"img_screenUrl"]]];
}

ON_SIGNAL2(BeeUIButton, signal)
{
    [super handleUISignal:signal];
}

- (void)setBtnTag:(NSInteger)tag
{
    [button setTag:tag];
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
