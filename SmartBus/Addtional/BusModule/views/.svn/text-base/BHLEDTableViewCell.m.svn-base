//
//  BHLEDTableViewCell.m
//  SmartBus
//
//  Created by launching on 14-1-27.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHLEDTableViewCell.h"
#import "BHLEDDesc.h"

@interface BHLEDTableViewCell ()
{
    UILabel *routeNameLabel;
    UILabel *destinationLabel;
    UILabel *distanceLabel;
    UILabel *busidLabel;
    UILabel *reloadtimeLabel;
}
@end

@implementation BHLEDTableViewCell

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(routeNameLabel);
    SAFE_RELEASE_SUBVIEW(destinationLabel);
    SAFE_RELEASE_SUBVIEW(distanceLabel);
    SAFE_RELEASE_SUBVIEW(busidLabel);
    SAFE_RELEASE_SUBVIEW(reloadtimeLabel);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        routeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 4.f, 60.f, 20.f)];
        routeNameLabel.backgroundColor = [UIColor clearColor];
        routeNameLabel.font = BOLD_FONT_SIZE(15);
        routeNameLabel.textColor = [UIColor flatBlueColor];
        [self.contentView addSubview:routeNameLabel];
        
        destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.f, 4.f, 60.f, 20.f)];
        destinationLabel.backgroundColor = [UIColor clearColor];
        destinationLabel.font = FONT_SIZE(12);
        destinationLabel.textColor = [UIColor flatBlueColor];
        [self.contentView addSubview:destinationLabel];
        
        busidLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 24.f, 90.f, 16.f)];
        busidLabel.backgroundColor = [UIColor clearColor];
        busidLabel.font = FONT_SIZE(12);
        [self.contentView addSubview:busidLabel];
        
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.f, 24.f, 90.f, 16.f)];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.font = BOLD_FONT_SIZE(12);
        [self.contentView addSubview:distanceLabel];
        
        reloadtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230.f, 24.f, 60.f, 16.f)];
        reloadtimeLabel.backgroundColor = [UIColor clearColor];
        reloadtimeLabel.font = FONT_SIZE(12);
        [self.contentView addSubview:reloadtimeLabel];
    }
    return self;
}

- (void)setLEDDesc:(id)led
{
    BHLEDDesc *ledDesc = (BHLEDDesc *)led;
    
    CGSize size = [ledDesc.rname sizeWithFont:BOLD_FONT_SIZE(15) byWidth:200];
    routeNameLabel.frame = CGRectMake(10.f, 4.f, size.width, 20.f);
    routeNameLabel.text = ledDesc.rname;
    
    destinationLabel.frame = CGRectMake(size.width+20.f, 4.f, 300.f-size.width, 20.f);
    destinationLabel.text = [NSString stringWithFormat:@"开往 : %@", ledDesc.dest];
    
    busidLabel.text = [NSString stringWithFormat:@"编号 : %d", ledDesc.busId];
    reloadtimeLabel.text = [NSString stringWithFormat:@"%d秒前", ledDesc.rtime];
    
    if ( ledDesc.currentLevel != ledDesc.theLevel )
    {
        distanceLabel.text = [NSString stringWithFormat:@"距离 : %0.0f站", fabs(ledDesc.currentLevel - ledDesc.theLevel)];
    }
    else
    {
        distanceLabel.text = [NSString stringWithFormat:@"距离 : %0.1f米", ledDesc.distance];
    }
}

@end
