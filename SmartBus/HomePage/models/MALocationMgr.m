//
//  MALocationMgr.m
//  SmartBus
//
//  Created by launching on 13-12-5.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "MALocationMgr.h"

@interface MALocationMgr ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
    BOOL firstUpload;
    CLLocationCoordinate2D tempCoor;
    int timeForUpdate;
}
- (CLLocationDistance)distanceWithCoordinate:(CLLocationCoordinate2D)coor fromCoordinate:(CLLocationCoordinate2D)fromCoor;
- (void)uploadUserLocation:(CLLocationCoordinate2D)coor;
@end

@implementation MALocationMgr

DEF_SINGLETON( MALocationMgr );

- (id)init
{
    if ( self = [super init] )
    {
        timeForUpdate = 60;
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate = self;
    }
    return self;
}

- (void)start
{
    _mapView.showsUserLocation = YES;
}

- (void)pause
{
    _mapView.showsUserLocation = NO;
}

- (void)stop
{
    _mapView.showsUserLocation = NO;
    SAFE_RELEASE(_mapView);
}


#pragma mark -
#pragma mark private methods

- (CLLocationDistance)distanceWithCoordinate:(CLLocationCoordinate2D)coor fromCoordinate:(CLLocationCoordinate2D)fromCoor
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
    CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:fromCoor.latitude longitude:fromCoor.longitude];
    CLLocationDistance distance = [location distanceFromLocation:thisLocation];
    return distance;
}

- (void)uploadUserLocation:(CLLocationCoordinate2D)coor
{
    NSDictionary *params = @{@"uid":[NSNumber numberWithInt:[BHUserModel sharedInstance].uid],
                             @"identify":[BeeSystemInfo deviceUUID],
                             @"lat":[NSString stringWithFormat:@"%f", coor.latitude],
                             @"lon":[NSString stringWithFormat:@"%f", coor.longitude]};
    NSString *url = [NSString stringWithFormat:@"%@line/gpswaiter", SBDomain];
    self
    .HTTP_GET( url )
    .PARAM ([SMBusEncryption encryption:params])
    .USER_INFO ( @"submitLocation" )
    .TIMEOUT( 10 );
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.succeed )
	{
        NSDictionary *result = [request.responseString objectFromJSONString];
        NSLog(@"submitLocation :%@", result);
    }
}


#pragma mark -
#pragma mark MAMapViewDelegate

- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView
{
    // TODO:
}

- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView
{
    // TODO:
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if ( updatingLocation ) return;
    
    // 停止定位,10分钟后再次开启
    [self pause];
    
    // 定位错误,设置新街口坐标
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    if ( coordinate.latitude < 0.f || coordinate.longitude < 0.f ) {
        coordinate = CLLocationCoordinate2DMake(32.040992, 118.784135);
    }
    [BHUserModel sharedInstance].coordinate = coordinate;
    
    // 如果第一次上传，无需判断
    if ( firstUpload || [self distanceWithCoordinate:tempCoor fromCoordinate:coordinate] > 50.f )
    {
        [self uploadUserLocation:coordinate];
        firstUpload = NO;
        timeForUpdate =  60;
    }
    else
    {
        timeForUpdate += 60;
        if (timeForUpdate >= 600) {
            timeForUpdate = 600;
        }
    }
    
    tempCoor = coordinate;
    [self performSelector:@selector(start) withObject:nil afterDelay:timeForUpdate];
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位错误 Error: %@", error);
    
    // 定位错误,默认定位到新街口
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(32.040992, 118.784135);
    [BHUserModel sharedInstance].coordinate = coordinate;
}

@end
