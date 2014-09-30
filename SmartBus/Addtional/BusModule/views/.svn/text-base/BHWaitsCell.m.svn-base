//
//  BHWaitsCell.m
//  SmartBus
//
//  Created by launching on 13-11-19.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHWaitsCell.h"
#import "UIButton+WebCache.h"

@interface BHWaitsCell ()
{
    UIButton *avatorButton;
    UILabel *unameLabel;
    UILabel *distanceLabel;
}
@end

@implementation BHWaitsCell

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(avatorButton);
    SAFE_RELEASE_SUBVIEW(unameLabel);
    SAFE_RELEASE_SUBVIEW(distanceLabel);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)]];
        bubbleImageView.frame = CGRectMake(5.f, 4.f, 310.f, kWaitsCellHeight-5.f);
        
        avatorButton = [[UIButton alloc] initWithFrame:CGRectMake(5.f, 6.f, 40.f, 40.f)];
        avatorButton.backgroundColor = [UIColor clearColor];
        avatorButton.layer.masksToBounds = YES;
        avatorButton.layer.cornerRadius = 20.f;
        [bubbleImageView addSubview:avatorButton];
        
        unameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.f, 15.f, 170.f, 26.f)];
        unameLabel.backgroundColor = [UIColor clearColor];
        unameLabel.font = FONT_SIZE(16);
        [bubbleImageView addSubview:unameLabel];
        
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(230.f, 15.f, 60.f, 26.f)];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.font = FONT_SIZE(14);
        distanceLabel.textColor = [UIColor lightGrayColor];
        distanceLabel.textAlignment = UITextAlignmentRight;
        [bubbleImageView addSubview:distanceLabel];
        
        [self.contentView addSubview:bubbleImageView];
        [bubbleImageView release];
    }
    return self;
}

- (void)setUser:(BHUserModel *)user
{
    SAFE_RELEASE(_user);
    _user = [user retain];
    
    [avatorButton setImageWithURL:[NSURL URLWithString:user.avator] placeholderImage:[UIImage imageNamed:@"default_man.png"]];
    unameLabel.text = user.uname;
    
    CLLocationDistance distance = [self getDistanceWithCoordinate:[BHUserModel sharedInstance].coordinate fromCoordinate:_user.coordinate];
    distanceLabel.text = [NSString stringWithFormat:@"%0.0fm", distance];
}

- (CLLocationDistance)getDistanceWithCoordinate:(CLLocationCoordinate2D)coordinate fromCoordinate:(CLLocationCoordinate2D)fromCoordinate
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:fromCoordinate.latitude longitude:fromCoordinate.longitude];
    CLLocationDistance distance = [location distanceFromLocation:thisLocation];
    return distance;
}


@end
