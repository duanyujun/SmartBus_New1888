//
//  BHArroundSitesMapBoard.m
//  SmartBus
//
//  Created by launching on 13-11-15.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHArroundSitesMapBoard.h"
#import "BHStationBoard.h"
#import "BUSDBHelper.h"

@interface BHArroundSitesMapBoard ()<SBAnnotationViewDelegate>
{
    NSArray *_stations;
    CLLocationCoordinate2D _coordinate;
}
- (void)addStationsIndicator:(NSArray *)stations;
- (void)reloadArroundStations;
@end

@implementation BHArroundSitesMapBoard

DEF_SIGNAL( TARGET );

- (void)unload
{
    SAFE_RELEASE(_stations);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_station.png"] title:@"附近站点"];
        
        CGRect rc = self.beeView.bounds;
        BeeUIButton *targetButton = [BeeUIButton new];
        targetButton.frame = CGRectMake(rc.size.width-50.f, rc.size.height-50.f, 40.f, 40.f);
        targetButton.image = [UIImage imageNamed:@"icon_target.png"];
        [targetButton addSignal:self.TARGET forControlEvents:UIControlEventTouchUpInside];
        [self.beeView addSubview:targetButton];
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
        [self startShowingUserLocation];
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.TARGET] )
    {
        [self.mapView setCenterCoordinate:[BHUserModel sharedInstance].coordinate animated:YES];
    }
}


#pragma mark -
#pragma mark private methods

- (void)addStationsIndicator:(NSArray *)stations
{
    SAFE_RELEASE(_stations);
    _stations = [stations retain];
    
    [self clearAnnsNotIncludeUser];
    
    // 添加annotations
    for (int i = 0; i < _stations.count; i++)
    {
        LKStation *station = [_stations objectAtIndex:i];
        SBAnnotation *annotation = [[SBAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(station.st_real_lat, station.st_real_lon);
        annotation.title = station.st_name;
        annotation.mode = SBAnnoModeStationIndicator;
        annotation.index = i;
        [self.annotations addObject:annotation];
        [annotation release];
    }
    [self.mapView addAnnotations:self.annotations];
}

- (void)reloadArroundStations
{
    NSArray *nearbyStations = [[BUSDBHelper sharedInstance] queryNearbyStations:_coordinate];
    [self addStationsIndicator:nearbyStations];
}


#pragma mark-
#pragma mark 标注

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ( [annotation isKindOfClass:[SBAnnotation class]] )
    {
		static NSString *identifier = @"identifier";
        SBAnnotationView *annotationView = (SBAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if ( !annotationView )
        {
            annotationView = [[[SBAnnotationView alloc] initWithReuseIdentifier:identifier] autorelease];
            annotationView.delegate = self;
        }
        [annotationView setPointAnnotation:annotation];
        return annotationView;
	}
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if ( !updatingLocation )
    {
        //[self stopShowingUserLocation];
        
        CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
        [BHUserModel sharedInstance].coordinate = coordinate;
        _coordinate = coordinate;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(reloadArroundStations) withObject:nil afterDelay:0.5];
    }
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    _coordinate = mapView.region.center;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(reloadArroundStations) withObject:nil afterDelay:0.5];
}


#pragma mark -
#pragma mark SBAnnotationViewDelegate

- (void)annotationView:(SBAnnotationView *)annotationView didSelectAnnotation:(id)annotation
{
    int index = [(SBAnnotation *)annotation index];
    LKStation *station = [_stations objectAtIndex:index];
    BHStationBoard *board = [[BHStationBoard alloc] initWithDataSource:station];
    [self.stack pushBoard:board animated:YES];
    [board release];
}

@end
