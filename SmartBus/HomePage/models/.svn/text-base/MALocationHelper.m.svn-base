//
//  MALocationHelper.m
//  SmartBus
//
//  Created by launching on 13-12-5.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "MALocationHelper.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface MALocationHelper ()<MAMapViewDelegate, AMapSearchDelegate>
{
    MAMapView *_mapView;
    id<MALocationDelegate> _delegate;
    
}
- (void)searchReGeocode:(CLLocation *)location;
@end

@implementation MALocationHelper

- (void)dealloc
{
    //SAFE_RELEASE(_mapView);
    _delegate = nil;
    [super dealloc];
}

- (id)initWithDelegate:(id<MALocationDelegate>)delegate
{
    if ( self = [super init] )
    {
        _delegate = delegate;
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate = self;
        _mapView.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

- (void)startLocating
{
    if ( [_delegate respondsToSelector:@selector(locationHelperDidStartLocating:)] )
    {
        [_delegate locationHelperDidStartLocating:self];
    }
    
    _mapView.showsUserLocation = YES;
}

- (void)stopLocating
{
    _mapView.showsUserLocation = NO;
}


#pragma mark -
#pragma mark private methods

- (void)searchReGeocode:(CLLocation *)location
{
    //定位城市通过CLGeocoder
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if ( placemarks && placemarks.count > 0 )
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            if ( [_delegate respondsToSelector:@selector(locationHelper:didFinishedReGeocode:)] )
            {
                NSString *address = [NSString stringWithFormat:@"%@%@%@%@", placemark.administrativeArea, placemark.locality, placemark.subLocality, placemark.thoroughfare];
                [_delegate locationHelper:self didFinishedReGeocode:address];
            }
        }
        else
        {
            if ( [_delegate respondsToSelector:@selector(locationHelper:didFaildLocating:)] ) {
                [_delegate locationHelper:self didFaildLocating:error];
            }
        }
    }];
}


#pragma mark -
#pragma mark MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if ( !updatingLocation )
    {
        [self stopLocating];
        
        if ( [_delegate respondsToSelector:@selector(locationHelper:didFinishedLocating:)] )
        {
            [_delegate locationHelper:self didFinishedLocating:userLocation.location.coordinate];
        }
        
        // 反地理编码
        if ( self.usingReGeocode ) {
            [self searchReGeocode:userLocation.location];
        }
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位错误 Error: %@", error);
    
    // 定位错误,默认定位到新街口
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(32.040992, 118.784135);
    [BHUserModel sharedInstance].coordinate = coordinate;
    
    if ( [_delegate respondsToSelector:@selector(locationHelper:didFaildLocating:)] ) {
        [_delegate locationHelper:self didFaildLocating:error];
    }
}

@end
