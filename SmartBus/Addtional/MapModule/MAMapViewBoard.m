//
//  MAMapViewBoard.m
//  SmartBus
//
//  Created by launching on 14-4-23.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "MAMapViewBoard.h"

@interface MAMapViewBoard ()

@end

@implementation MAMapViewBoard

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;

- (void)unload
{
    SAFE_RELEASE(_annotations);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_station.png"] title:@"线路地图"];
        [self initMapView];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_mapView);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        _mapView.frame = self.beeView.bounds;
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
        [[BHAPP reveal] setAllowsReveal:NO];
        [self performSelector:@selector(startShowingUserLocation) withObject:nil afterDelay:0.5];
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
        [[BHAPP reveal] setAllowsReveal:YES];
	}
}


#pragma mark - public methods

- (void)startShowingUserLocation
{
    [self.mapView setShowsUserLocation:YES];
}

- (void)stopShowingUserLocation
{
    [self.mapView setShowsUserLocation:NO];
}

- (void)setZoomLevel:(CGFloat)zoomLevel
{
    [self.mapView setZoomEnabled:YES];
    [self.mapView setZoomLevel:zoomLevel animated:YES];
}

- (void)clearAllAnns
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.annotations removeAllObjects];
}

- (void)clearAnnsNotIncludeUser
{
    for ( id<MAAnnotation> annotation in self.mapView.annotations )
    {
        if ( ![annotation isKindOfClass:[MAUserLocation class]] ) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.annotations removeAllObjects];
}

- (void)clearUserOverlays
{
    for ( id<MAOverlay> overlay in self.mapView.overlays )
    {
        if ( [overlay isKindOfClass:[MACircle class]] ) {
            [self.mapView removeOverlay:overlay];
        }
    }
}


#pragma mark - private methods

- (void)handleMenu
{
    [self clearAll];
    [super handleMenu];
}

- (void)initMapView
{
    // 创建覆盖物数组
    _annotations = [[NSMutableArray alloc] initWithCapacity:0];
    
    // 创建MapView
    _mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
    [self.beeView addSubview:_mapView];
    
    // 用户跟踪模式，MAUserTrackingModeNone不会显示用户当前位置
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    // 设置委托
    _mapView.delegate = self;
    
    // 设置ZoomLevel,默认为17(范围3-20)
    _mapView.zoomLevel = 17;
}

- (void)clearAll
{
    self.mapView.delegate = nil;
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
}


#pragma mark - MAMapViewDelegate

- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView
{
    NSLog(@"start locating...");
}

- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView
{
    NSLog(@"stop locating...");
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    [self stopShowingUserLocation];
    [self clearUserOverlays];
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"faild to locate");
}

@end
