//
//  BHTalkFromCell.m
//  SmartBus
//
//  Created by 王 正星 on 13-12-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTalkFromCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Helper.h"

@interface BHTalkFromCell ()
{
    UIView *m_container;
    UIImageView *icon;
    UILabel *content;
    UIImageView *bubble;
    UILabel *time;
}
@end

@implementation BHTalkFromCell

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(m_container);
    SAFE_RELEASE_SUBVIEW(icon);
    SAFE_RELEASE_SUBVIEW(content);
    SAFE_RELEASE_SUBVIEW(bubble);
    SAFE_RELEASE_SUBVIEW(time);
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        time = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 2.5f, 320.f, 20.f)];
        [time setTextColor:[UIColor grayColor]];
        [time setBackgroundColor:[UIColor clearColor]];
        [time setTextAlignment:NSTextAlignmentCenter];
        [time setFont:FONT_SIZE(12)];
        [self.contentView addSubview:time];
        
        m_container = [[UIView alloc]initWithFrame:CGRectMake(0.f, 25.f, 320.f, 40.f)];
        m_container.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:m_container];
        
        icon = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 5.f, 32.f, 32.f)];
        [icon.layer setCornerRadius:5.f];
        [icon.layer setMasksToBounds:YES];
        [m_container addSubview:icon];
        
        bubble = [[UIImageView alloc]initWithFrame:CGRectMake(50.f, 5.f, 200.f, 32.f)];
        [bubble setImage:[[UIImage imageNamed:@"bg_chat"] stretchableImageWithLeftCapWidth:15.f topCapHeight:18.f]];
        [m_container addSubview:bubble];
        
        content = [[UILabel alloc]initWithFrame:CGRectZero];
        [content setBackgroundColor:[UIColor clearColor]];
        [content setTextColor:[UIColor blackColor]];
        [content setFont:FONT_SIZE(14)];
        [content setNumberOfLines:0];
        [bubble addSubview:content];
    }
    return self;
}

- (void)setCellData:(BHMsgModel *)model hasTime:(BOOL)hasTime
{
    [icon setImageWithURL:[NSURL URLWithString:model.sender.avator] placeholderImage:[UIImage imageNamed:@"default_man.png"]];
    [content setFrame:CGRectMake(10.f, 0.f, 220.f, model.msgContentHeight)];
    [content setText:model.content];
    bubble.height = model.msgContentHeight;
    bubble.width = model.msgContentWidth;
    [time setHidden:!hasTime];
    if (hasTime) {
        m_container.top = 20.f;
        [time setText:[NSDate stringFromTimeInterval:model.dtime withFormat:@"MM月dd日 HH:mm"]];
    }else
    {
        m_container.top = 0;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
