//
//  BHRouteMapBoard.m
//  SmartBus
//
//  Created by launching on 13-10-31.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHRouteMapBoard.h"
#import "BHRouteModel.h"
#import "BHBusModel.h"
#import "BHBusHelper.h"
#import "BHAnnotationView.h"
#import "BHPointAnnotation.h"
#import "BMapKit.h"

@interface BHRouteMapBoard ()<BMKMapViewDelegate>
{
    BMKMapView *bmkMapView;
    NSMutableArray *annotations;
    BOOL firstLocating;
    BHBusHelper *_busHelper;
}
- (void)addRouteIndicator:(BHRouteModel *)route;
- (void)addRoutePolyline:(NSArray *)paths;
- (void)removeAnnotations;
@end

@implementation BHRouteMapBoard

@synthesize route = _route;

- (void)load
{
    firstLocating = YES;
    annotations = [[NSMutableArray alloc] initWithCapacity:0];
    _busHelper = [[BHBusHelper alloc] init];
    [_busHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_busHelper removeObserver:self];
    SAFE_RELEASE(_busHelper);
    SAFE_RELEASE(annotations);
    SAFE_RELEASE(_route);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_station.png"] title:@"地图"];
        
        // 加载地图
        bmkMapView = [[BMKMapView alloc] initWithFrame:CGRectZero];
        bmkMapView.zoomLevel = 15;
        [self.beeView addSubview:bmkMapView];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(bmkMapView);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        CGRect rc = self.beeView.bounds;
        rc.size.height = self.beeView.bounds.size.height + 50.f;
        bmkMapView.frame = rc;
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
        bmkMapView.delegate = self;
        [[BHAPP reveal] setAllowsReveal:NO];
        [self addRouteIndicator:_route];
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
        bmkMapView.delegate = nil;
        [[BHAPP reveal] setAllowsReveal:YES];
	}
}

- (void)addRouteIndicator:(BHRouteModel *)route
{
    [self removeAnnotations];
    
    // 添加站台标注
    BHPointAnnotation *annotation = [[BHPointAnnotation alloc] init];
    annotation.coordinate = route.site.mapcoor;
    annotation.mode = AnnoModeStationIndicator;
    [annotations addObject:annotation];
    [annotation release];
    
    // 添加车辆标注
    annotation = [[BHPointAnnotation alloc] init];
    annotation.coordinate = route.bus.coor;
    annotation.mode = AnnoModeBusIndicator;
    [annotations addObject:annotation];
    [annotation release];
    
    // 获取线路轨迹
    [_busHelper getRoutePathsById:route.rid];
}


#pragma mark -
#pragma mark private methods

- (void)removeAnnotations
{
    [bmkMapView removeAnnotations:annotations];
    [annotations removeAllObjects];
}

- (void)addRoutePolyline:(NSArray *)paths
{
    // 添加站点标注
    for ( NSDictionary *path in paths )
    {
        BHPointAnnotation *annotation = [[BHPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake([path[@"lat"] doubleValue], [path[@"long"] doubleValue]);
        annotation.mode = AnnoModeRouteIndicator;
        [annotations addObject:annotation];
        [annotation release];
    }
    [bmkMapView addAnnotations:annotations];
    
    // 绘制线路
    CLLocationCoordinate2D pointsToUse[[paths count]];
    for (int i = 0; i < paths.count; i++) {
        CLLocationCoordinate2D coords;
        coords.latitude = [paths[i][@"lat"] doubleValue];
        coords.longitude = [paths[i][@"long"] doubleValue];
        pointsToUse[i] = coords;
    }
    BMKPolyline *lineOne = [BMKPolyline polylineWithCoordinates:pointsToUse count:[paths count]];
    [bmkMapView addOverlay:lineOne];
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.succeed )
	{
        [self addRoutePolyline:_busHelper.nodes];
	}
}


#pragma mark-
#pragma mark 标注

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSLog(@"生成标注...");
    
    if ( [annotation isKindOfClass:[BHPointAnnotation class]] )
    {
		static NSString *identifier = @"identifier";
        BHAnnotationView *annotationView = (BHAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if ( !annotationView ) {
            annotationView = [[[BHAnnotationView alloc] initWithReuseIdentifier:identifier] autorelease];
        }
        annotationView.annotation = annotation;
        return annotationView;
	}
    
    return nil;
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if ( firstLocating )
    {
        [mapView setCenterCoordinate:_route.site.mapcoor];
    }
    firstLocating = NO;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView *lineview = [[BMKPolylineView alloc] initWithOverlay:overlay];
        lineview.strokeColor = [UIColor flatBlueColor];  //路线颜色
        lineview.lineWidth = 5.0;
        return lineview;
    }
    return nil;
}

@end
