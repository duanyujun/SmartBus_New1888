//
//  BHStationsTable.m
//  SmartBus
//
//  Created by launching on 13-10-8.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHStationsTable.h"
#import "LKStation.h"
#import "LKRoute.h"
#import "BHBadgeView.h"

@interface BHStationsTable ()<CLLocationManagerDelegate>
{
    UIImageView *bubbleImageView;
    UIView *headerView;
    UIView *itemsView;
}
@end

#define kItemBaseTag       119

@implementation BHStationsTable

DEF_SIGNAL( MAP_MODE );

@synthesize stations = _stations;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(bubbleImageView);
    SAFE_RELEASE_SUBVIEW(headerView);
    SAFE_RELEASE_SUBVIEW(itemsView);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:10.f topCapHeight:10.f]];
        bubbleImageView.frame = self.bounds;
        [self addSubview:bubbleImageView];
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 300.f, kItemHeaderHeight)];
        headerView.backgroundColor = [UIColor clearColor];
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 90.f, kItemHeaderHeight)];
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.font = FONT_SIZE(15);
        tipsLabel.text = @"您附近站点";
        [headerView addSubview:tipsLabel];
        [tipsLabel release];
        
        BHBadgeView *badgeView = [[BHBadgeView alloc] initWithFrame:CGRectMake(100.f, (kItemHeaderHeight-24.f)/2, 24.f, 24.f)];
        badgeView.fontSize = 14;
        [headerView addSubview:badgeView];
        [badgeView release];
        
        BeeUIButton *button = [BeeUIButton new];
        button.frame = CGRectMake(256.f, 0.f, kItemHeaderHeight, kItemHeaderHeight);
        button.image = [UIImage imageNamed:@"icon_map.png"];
        [button addSignal:self.MAP_MODE forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        
        [self addSubview:headerView];
        
        itemsView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kItemHeaderHeight, 300.f, self.frame.size.height-kItemHeaderHeight)];
        itemsView.backgroundColor = [UIColor clearColor];
        [self addSubview:itemsView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [bubbleImageView setFrame:CGRectMake(0.f, 0.f, frame.size.width, frame.size.height)];
    [itemsView setFrame:CGRectMake(0.f, kItemHeaderHeight, 300.f, self.frame.size.height-kItemHeaderHeight)];
}

- (void)setStations:(NSArray *)stations
{
    SAFE_RELEASE(_stations);
    _stations = [stations retain];
    
    BHBadgeView *badgeView = (BHBadgeView *)[headerView.subviews objectAtIndex:1];
    [badgeView setBadgeNumber:_stations.count];
    
    if (itemsView.subviews.count > 0) {
        [itemsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (int i = 0; i < _stations.count; i++)
    {
        LKStation *station = _stations[i];
        
        NSNumber *idx = [NSNumber numberWithInt:i];
        BeeUIButton *itemCellButton = [BeeUIButton new];
        itemCellButton.backgroundColor = [UIColor clearColor];
        itemCellButton.tag = kItemBaseTag + i;
        itemCellButton.frame = CGRectMake(0.f, i*kItemCellHeight, self.frame.size.width, kItemCellHeight);
        [itemCellButton addSignal:@"item" forControlEvents:UIControlEventTouchUpInside object:idx];
        [itemsView addSubview:itemCellButton];
        
        UILabel *sequenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 6.f, 20.f, 20.f)];
        sequenceLabel.backgroundColor = [UIColor clearColor];
        sequenceLabel.font = FONT_SIZE(15);
        sequenceLabel.textColor = [UIColor lightGrayColor];
        sequenceLabel.text = [NSString stringWithFormat:@"%d", i + 1];
        [itemCellButton addSubview:sequenceLabel];
        [sequenceLabel release];
        
        UILabel *snameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 6.f, 200.f, 20.f)];
        snameLabel.backgroundColor = [UIColor clearColor];
        snameLabel.font = BOLD_FONT_SIZE(15);
        snameLabel.text = station.st_name;
        [itemCellButton addSubview:snameLabel];
        [snameLabel release];
        
        // 拼线路
        NSMutableString *lidstr = [NSMutableString stringWithCapacity:0];
        for (int j = 0; j < station.st_routes.count; j++)
        {
            LKRoute *route = station.st_routes[j];
            [lidstr appendFormat:@"%@/", route.line_name];
        }
        UILabel *busesLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 28.f, 250.f, 16.f)];
        busesLabel.backgroundColor = [UIColor clearColor];
        busesLabel.font = FONT_SIZE(14);
        busesLabel.textColor = [UIColor lightGrayColor];
        busesLabel.text = station.st_routes.count ? [lidstr substringToIndex:lidstr.length - 1] : nil;
        [itemCellButton addSubview:busesLabel];
        [busesLabel release];
        
        UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(240.f, 6.f, 50.f, 20.f)];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.font = FONT_SIZE(14);
        distanceLabel.textColor = [UIColor lightGrayColor];
        distanceLabel.textAlignment = UITextAlignmentRight;
        distanceLabel.text = [NSString stringWithFormat:@"%0.0fm", station.distance];
        [itemCellButton addSubview:distanceLabel];
        [distanceLabel release];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10.f, 0.f, 280.f, 1.f)];
        line.backgroundColor = [UIColor flatWhiteColor];
        [itemCellButton addSubview:line];
        [line release];
    }
}

ON_SIGNAL2( BeeUIButton, signal )
{
    [super handleUISignal:signal];
}


//#pragma mark - private methods
//
//- (void)startLocating
//{
//    locationManager = [[CLLocationManager alloc] init];
//    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    [locationManager startUpdatingLocation];
//    [locationManager setDelegate:self];
//}
//
//- (void)stopLocating
//{
//    [locationManager stopUpdatingLocation];
//    SAFE_RELEASE(locationManager);
//}
//
//- (CLLocationDistance)getDistanceWithCoordinate:(CLLocationCoordinate2D)coordinate fromCoordinate:(CLLocationCoordinate2D)fromCoordinate
//{
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:fromCoordinate.latitude longitude:fromCoordinate.longitude];
//    CLLocationDistance distance = [location distanceFromLocation:thisLocation];
//    return distance;
//}
//
//- (void)updateItemWithDistance:(CLLocationDistance)distance atIndex:(NSInteger)index
//{
//    UIButton *itemCellButton = (UIButton *)[itemsView viewWithTag:kItemBaseTag + index];
//    
//    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[itemCellButton.subviews objectAtIndex:4];
//    [activityView stopAnimating];
//    activityView.hidden = YES;
//    
//    UILabel *distanceLabel = (UILabel *)[itemCellButton.subviews objectAtIndex:3];
//    distanceLabel.hidden = NO;
//    [distanceLabel setText:[NSString stringWithFormat:@"%0.fm", distance]];
//}
//
//
//#pragma mark - CLLocationManagerDelegate
//
//- (void)locationManager:(CLLocationManager *)manager
//	didUpdateToLocation:(CLLocation *)newLocation
//		   fromLocation:(CLLocation *)oldLocation
//{
//    for (int i = 0; i < _stations.count; i++)
//    {
//        BHStationModel *station = _stations[i];
//        CLLocationDistance distance = [self getDistanceWithCoordinate:newLocation.coordinate fromCoordinate:station.coor];
//        [self updateItemWithDistance:distance atIndex:i];
//    }
//    
//    [self stopLocating];
//}
//
//- (void)locationManager:(CLLocationManager *)manager
//       didFailWithError:(NSError *)error
//{
//    NSLog(@"【ERROR】:%@", error);
//}

@end
