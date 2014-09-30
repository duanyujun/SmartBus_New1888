//
//  BHFavRouteCell.m
//  SmartBus
//
//  Created by launching on 13-10-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHFavRouteCell.h"

@interface BHFavRouteCell ()
{
    UILabel *routeLabel;
    UILabel *directionLabel;
    UILabel *subtitleLabel;
}
@end

@implementation BHFavRouteCell

@synthesize route = _route;

- (void)dealloc
{
    SAFE_RELEASE(_route);
    SAFE_RELEASE_SUBVIEW(routeLabel);
    SAFE_RELEASE_SUBVIEW(directionLabel);
    SAFE_RELEASE_SUBVIEW(subtitleLabel);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setHeightForMenu:53.f];
        
        routeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 12.f, 70.f, 30.f)];
        routeLabel.backgroundColor = [UIColor clearColor];
        routeLabel.textAlignment = UITextAlignmentCenter;
        routeLabel.font = BOLD_FONT_SIZE(18);
        [self.scrollView addSubview:routeLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_separat.png"]];
        lineImageView.frame = CGRectMake(80, 15.f, 10.f, 24.f);
        [self.scrollView addSubview:lineImageView];
        [lineImageView release];
        
        directionLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.f, 6.f, 195.f, 25.f)];
        directionLabel.backgroundColor = [UIColor clearColor];
        directionLabel.font = FONT_SIZE(15);
        [self.scrollView addSubview:directionLabel];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_loc_gray.png"]];
        iconImageView.frame = CGRectMake(100, 32.f, 11.f, 13.f);
        [self.scrollView addSubview:iconImageView];
        [iconImageView release];
        
        subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(115.f, 31.f, 180.f, 16.f)];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.font = FONT_SIZE(12);
        subtitleLabel.textColor = [UIColor lightGrayColor];
        [self.scrollView addSubview:subtitleLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(18.f, 53.f, 284.f, 1.f)];
        line.backgroundColor = [UIColor flatGrayColor];
        [self.scrollView addSubview:line];
        [line release];
    }
    return self;
}

- (void)setRoute:(LKRoute *)route
{
    SAFE_RELEASE(_route);
    _route = [route retain];
    
    routeLabel.text = _route.line_name;
    directionLabel.text = [NSString stringWithFormat:@"%@-%@", _route.st_start, _route.st_end];
    subtitleLabel.text = _route.st_appoint.st_name;
}

@end
