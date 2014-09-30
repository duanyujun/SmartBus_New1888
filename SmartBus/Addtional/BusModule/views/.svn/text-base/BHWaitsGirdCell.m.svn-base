//
//  BHWaitsGirdCell.m
//  SmartBus
//
//  Created by launching on 14-3-4.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHWaitsGirdCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#define kAvatorImageTag  5180
#define kToolBarTag      5181
#define kButtonBaseTag   5182

@implementation BHWaitsGirdCell
{
    CLLocationManager *locationManager;
    NSArray *_users;
    GirdCellBasicBlock _block;
}

- (void)dealloc
{
    SAFE_RELEASE(locationManager);
    SAFE_RELEASE(_users);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        for (int i = 0; i < kNumberPerRow; i++)
        {
            UIImageView *container = [[UIImageView alloc] initWithFrame:CGRectMake(5+i*80, 5, 70, 90)];
            container.tag = kButtonBaseTag + i;
            container.backgroundColor = [UIColor clearColor];
            container.userInteractionEnabled = YES;
            
            UIImageView *avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
            avatorImageView.backgroundColor = [UIColor clearColor];
            avatorImageView.tag = kAvatorImageTag;
            avatorImageView.layer.masksToBounds = YES;
            avatorImageView.layer.cornerRadius = 8;
            avatorImageView.userInteractionEnabled = YES;
            [container addSubview:avatorImageView];
            [avatorImageView release];
            
            // 添加bar视图
            UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(1, 70, 68, 19)];
            bar.backgroundColor = [UIColor clearColor];
            bar.tag = kToolBarTag;
            
            UIImageView *genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 14, 14)];
            [bar addSubview:genderImageView];
            [genderImageView release];
            
            UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 3, 45, 14)];
            distanceLabel.backgroundColor = [UIColor clearColor];
            distanceLabel.font = FONT_SIZE(12);
            distanceLabel.textColor = [UIColor darkGrayColor];
            [bar addSubview:distanceLabel];
            [distanceLabel release];
            
            [container addSubview:bar];
            [bar release];
            
            [self.contentView addSubview:container];
            [container release];
        }
        
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager setDelegate:self];
    }
    return self;
}

- (void)setUsers:(NSArray *)users
{
    SAFE_RELEASE(_users);
    _users = [users retain];
    
    // 开始定位
    [locationManager startUpdatingLocation];
    
    for (int i = 0; i < _users.count; i++)
    {
        BHUserModel *user = _users[i];
        
        UIImageView *container = (UIImageView *)[self.contentView viewWithTag:kButtonBaseTag + i];
        [container setImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5, 5)]];
        
        UIImageView *avatorImageView = (UIImageView *)[container viewWithTag:kAvatorImageTag];
        [avatorImageView setImageWithURL:[NSURL URLWithString:user.avator] placeholderImage:[UIImage imageNamed:@"default_man.png"]];
        
        UIView *bar = [container viewWithTag:kToolBarTag];
        bar.backgroundColor = [UIColor flatWhiteColor];
        
        UIImageView *genderImageView = (UIImageView *)bar.subviews[0];
        genderImageView.image = [UIImage imageNamed:user.ugender == USER_GENDER_FEMALE ? @"icon_female.png" : @"icon_male.png"];
        
        // 添加单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [avatorImageView addGestureRecognizer:tap];
        [tap release];
    }
}

- (void)gridCellSelectionBlock:(GirdCellBasicBlock)block
{
    [_block release];
    _block = [block copy];
}

- (CLLocationDistance)getDistanceWithCoordinate:(CLLocationCoordinate2D)coordinate fromCoordinate:(CLLocationCoordinate2D)fromCoordinate
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:fromCoordinate.latitude longitude:fromCoordinate.longitude];
    CLLocationDistance distance = [location distanceFromLocation:thisLocation];
    return distance;
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    UIImageView *avatorImageView = (UIImageView *)recognizer.view;
    int index = avatorImageView.superview.tag - kButtonBaseTag;
    BHUserModel *user = _users[index];
    if ( _block )
    {
        _block( user );
    }
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    for (int i = 0; i < _users.count; i++)
    {
        BHUserModel *user = _users[i];
        CLLocationDistance distance = [self getDistanceWithCoordinate:newLocation.coordinate fromCoordinate:user.coordinate];
        UIImageView *container = (UIImageView *)[self.contentView viewWithTag:kButtonBaseTag + i];
        UIView *bar = [container viewWithTag:kToolBarTag];
        UILabel *distanceLabel = (UILabel *)bar.subviews[1];
        distanceLabel.text = [NSString stringWithFormat:@"%0.0fm", distance];
    }
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"【ERROR】:%@", error);
    
    for (int i = 0; i < _users.count; i++)
    {
        UIImageView *container = (UIImageView *)[self.contentView viewWithTag:kButtonBaseTag + i];
        UIView *bar = [container viewWithTag:kToolBarTag];
        UILabel *distanceLabel = (UILabel *)bar.subviews[1];
        distanceLabel.text = @"未知";
    }
    
    [manager stopUpdatingLocation];
}

@end
