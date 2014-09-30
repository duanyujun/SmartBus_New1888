//
//  BHFavStationCell.m
//  SmartBus
//
//  Created by launching on 13-10-15.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHFavStationCell.h"
#import "LKStation.h"
#import "LKRoute.h"

@interface BHFavStationCell ()
{
    UILabel *titleLabel;
    UILabel *subtitleLabel;
}
@end

@implementation BHFavStationCell

@synthesize station = _station;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(titleLabel);
    SAFE_RELEASE_SUBVIEW(subtitleLabel);
    SAFE_RELEASE(_station);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setHeightForMenu:53.f];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 6.f, 280.f, 25.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = BOLD_FONT_SIZE(15);
        [self.scrollView addSubview:titleLabel];
        
        subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 31.f, 280.f, 16.f)];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.font = FONT_SIZE(14);
        subtitleLabel.textColor = [UIColor lightGrayColor];
        [self.scrollView addSubview:subtitleLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8.f, 53.f, 284.f, 1.f)];
        line.backgroundColor = [UIColor flatGrayColor];
        [self.scrollView addSubview:line];
        [line release];
    }
    return self;
}

- (void)setStation:(LKStation *)station
{
    SAFE_RELEASE(_station);
    _station = [station retain];
    
    titleLabel.text = _station.st_name;
    
    NSMutableString *lidstr = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < _station.st_routes.count; i++)
    {
        LKRoute *route = _station.st_routes[i];
        [lidstr appendFormat:@"%@/", route.line_name];
    }
    subtitleLabel.text = _station.st_routes.count ? [lidstr substringToIndex:lidstr.length - 1] : lidstr;
}

@end
