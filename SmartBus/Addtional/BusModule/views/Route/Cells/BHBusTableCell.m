//
//  BHBusTableCell.m
//  BusHelper
//
//  Created by launching on 13-8-28.
//  Copyright (c) 2013年 仲 阳. All rights reserved.
//

#import "BHBusTableCell.h"

@interface BHBusTableCell () {
    UILabel *titleLabel;
    UILabel *subtitleLabel;
}
@end

@implementation BHBusTableCell

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(titleLabel);
    SAFE_RELEASE_SUBVIEW(subtitleLabel);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.contentView.backgroundColor = RGB(242.f, 242.f, 242.f);
//        self.backgroundColor = RGB(242.f, 242.f, 242.f);
        
        UIView *vline = [[UIView alloc] initWithFrame:CGRectMake(20.f, 0.f, 1.f, kBusTableCellHeight)];
        vline.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:vline];
        [vline release];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_realtime.png"]];
        iconImageView.frame = CGRectMake(12.f, (kBusTableCellHeight-20.f)/2, 36.f, 20.f);
        [self.contentView addSubview:iconImageView];
        [iconImageView release];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.f, 5.f, 250.f, 25.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        [self.contentView addSubview:titleLabel];
        
        subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.f, 30.f, 250.f, 16.f)];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.font = [UIFont systemFontOfSize:12.f];
        subtitleLabel.textColor = [UIColor darkGrayColor];
//        subtitleLabel.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:subtitleLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow.png"]];
        arrowImageView.frame = CGRectMake(300.f, (kBusTableCellHeight-24.f)/2, 15.f, 24.f);
        [self.contentView addSubview:arrowImageView];
        [arrowImageView release];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_line.png"]];
        lineImageView.frame = CGRectMake(0.f, kBusTableCellHeight-1.f, 320.f, 1.f);
        [self.contentView addSubview:lineImageView];
        [lineImageView release];
    }
    return self;
}

- (void)setRealTimeData:(BHRealTimeData *)data
{
    LKBus *bus = (LKBus *)data.data;
    
    NSString *name = data.st_name;
    if ( [name rangeOfString:@"("].location != NSNotFound ) {
        name = [name substringToIndex:[name rangeOfString:@"("].location];
    }
    
    titleLabel.text = [NSString stringWithFormat:@"约%dm    %0.1fkm/h        %d秒前", bus.st_dis, bus.bus_speed, bus.rtime];
    subtitleLabel.text = [NSString stringWithFormat:@"id : %d", bus.bus_id];
}

@end
