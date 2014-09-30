//
//  BHDistanceHelper.m
//  SmartBus
//
//  Created by launching on 14-3-4.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHDistanceHelper.h"

@implementation BHDistanceHelper
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D _resultCoordinate;
    CLLocationCoordinate2D _targetCoordinate;
}

DEF_SINGLETON( BHDistanceHelper );

@synthesize delegate = _delegate;

- (void)dealloc
{
    SAFE_RELEASE(locationManager);
    [super dealloc];
}

- (id)init
{
    if ( self = [super init] )
    {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager setDelegate:self];
    }
    return self;
}

- (void)startCalculatingDistanceByTargetCoordinate:(CLLocationCoordinate2D)targetCoor
{
    _targetCoordinate = targetCoor;
    
    if ( _resultCoordinate.latitude > 0.0 && _resultCoordinate.longitude > 0.0 )
    {
        CLLocationDistance distance = [self getDistanceWithCoordinate:_resultCoordinate fromCoordinate:_targetCoordinate];
        
        if ( [_delegate respondsToSelector:@selector(distanceHelper:didUpdateDistance:error:)] )
        {
            [_delegate distanceHelper:self didUpdateDistance:distance error:nil];
        }
    }
    else
    {
        [locationManager startUpdatingLocation];
    }
}

- (CLLocationDistance)getDistanceWithCoordinate:(CLLocationCoordinate2D)coordinate fromCoordinate:(CLLocationCoordinate2D)fromCoordinate
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:fromCoordinate.latitude longitude:fromCoordinate.longitude];
    CLLocationDistance distance = [location distanceFromLocation:thisLocation];
    return distance;
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    if ( _targetCoordinate.latitude == 0.0 || _targetCoordinate.longitude == 0.0 )
        return;
    
    _resultCoordinate = newLocation.coordinate;
    CLLocationDistance distance = [self getDistanceWithCoordinate:_resultCoordinate fromCoordinate:_targetCoordinate];
    
    if ( [_delegate respondsToSelector:@selector(distanceHelper:didUpdateDistance:error:)] )
    {
        [_delegate distanceHelper:self didUpdateDistance:distance error:nil];
    }
    
    [manager performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:3];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"【ERROR】:%@", error);
    
    if ( [_delegate respondsToSelector:@selector(distanceHelper:didUpdateDistance:error:)] )
    {
        [_delegate distanceHelper:self didUpdateDistance:0.0 error:error];
    }
    
    [manager performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:3];
}

@end
