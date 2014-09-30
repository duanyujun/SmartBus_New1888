//
//  BHStationTableCell.m
//  BusHelper
//
//  Created by launching on 13-8-28.
//  Copyright (c) 2013年 仲 阳. All rights reserved.
//

#import "BHStationTableCell.h"
#import "LKStation.h"

@interface BHStationTableCell () {
    UIImageView *iconImageView;
    UILabel *sequenceLabel;
    UILabel *stationNameLabel;
}
@end

#define kCellHighlightBGViewTag   120415

@implementation BHStationTableCell

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(iconImageView);
    SAFE_RELEASE_SUBVIEW(sequenceLabel);
    SAFE_RELEASE_SUBVIEW(stationNameLabel);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_line.png"]];
        lineImageView.frame = CGRectMake(0.f, kStationTableCellHeight-1.f, 320.f, 1.f);
        [self.contentView addSubview:lineImageView];
        [lineImageView release];
        
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, (kStationTableCellHeight-25.f)/2, 20.f, 25.f)];
        [self.contentView addSubview:iconImageView];
        
        sequenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 7.f, 15.f, 15.f)];
        sequenceLabel.backgroundColor = [UIColor clearColor];
        sequenceLabel.font = [UIFont systemFontOfSize:10.f];
        sequenceLabel.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:sequenceLabel];
        
        stationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(42.f, 5.f, 200.f, 25.f)];
        stationNameLabel.backgroundColor = [UIColor clearColor];
        stationNameLabel.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:stationNameLabel];
    }
    return self;
}

- (void)setStationModel:(id)stationModel currentLevel:(NSInteger)level
{
    if (!stationModel || ![stationModel isKindOfClass:[LKStation class]])
    {
        return;
    }
    
    LKStation *station = (LKStation *)stationModel;
    
    NSInteger currentLevel = station.st_level;
    
    UIImage *icon = [UIImage imageNamed:currentLevel == level ? @"icon_location02.png" : @"icon_location01.png"];
    iconImageView.image = icon;
    
    [sequenceLabel setText:[NSString stringWithFormat:@"%d", currentLevel]];
    [stationNameLabel setText:station.st_name];
    
    if (currentLevel <= level) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        sequenceLabel.textColor = [UIColor blackColor];
        stationNameLabel.textColor = [UIColor blackColor];
    } else {
        self.contentView.backgroundColor = RGB(244.f, 244.f, 244.f);
        sequenceLabel.textColor = [UIColor lightGrayColor];
        stationNameLabel.textColor = [UIColor lightGrayColor];
    }
}

@end
