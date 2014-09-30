//
//  BHChannelListCell.m
//  SmartBus
//
//  Created by 王 正星 on 13-10-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHChannelListCell.h"
#import "BHChannelTagView.h"
#import "BHPlayTimeView.h"
#import "UIImageView+WebCache.h"

@interface BHChannelListCell ()
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
@implementation BHChannelListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        screenShot = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 10.f, 142.f, 85)];
        [screenShot setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:screenShot];
        
        channelTag = [[BHChannelTagView alloc]initWithFrame:CGRectMake(165.f, 20.f, 83.f, 25.f)];
        [channelTag setTitle:@"江苏卫视" withIconUrl:@"icon_play" withBg:nil];
        [self.contentView addSubview:channelTag];
        
        beginTime = [[BHPlayTimeView alloc]initWithFrame:CGRectMake(165.f, 50.f, 50.f, 20.f) withType:BHPlayTimeTypeBegin];
        [self.contentView addSubview:beginTime];
        beginName = [[UILabel alloc]initWithFrame:CGRectMake(225.f, beginTime.top, 72.f, 20.f)];
        [beginName setBackgroundColor:[UIColor clearColor]];
        [beginName setFont:[UIFont systemFontOfSize:12.f]];
        beginName.text = @"非诚勿扰";
        [self.contentView addSubview:beginName];
        
        endTime = [[BHPlayTimeView alloc]initWithFrame:CGRectMake(165.f, 70.f, 40.f, 20.f) withType:BHPlayTimeTypeEnd];
        [self.contentView addSubview:endTime];
        nextName = [[UILabel alloc]initWithFrame:CGRectMake(225.f, endTime.top, 72.f, 20.f)];
        [nextName setBackgroundColor:[UIColor clearColor]];
        [nextName setTextColor:[UIColor lightGrayColor]];
        [nextName setFont:[UIFont systemFontOfSize:12.f]];
        nextName.text = @"爱情公寓｜｜";
        [self.contentView addSubview:nextName];
    }
    return self;
}

- (void)setCellData:(NSDictionary *)dic
{
    [channelTag setTitle:[dic objectForKey:@"channel_name"] withIconUrl:[dic objectForKey:@"channel_logo"] withBg:nil];
    [channelTag setBackgroundColor:[UIColor clearColor]];
    [beginTime setTime:dic[@"now_epg_time"]];
    beginName.text = dic[@"now_epg_name"];
    [endTime setTime:dic[@"next_epg_time"]];
    nextName.text = dic[@"next_epg_name"];
    [screenShot setImageWithURL:[NSURL URLWithString:dic[@"img_screenUrl"]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
