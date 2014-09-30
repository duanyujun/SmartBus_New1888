//
//  BHRouteMapBoard.m
//  SmartBus
//
//  Created by launching on 13-10-31.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHRouteMapBoard.h"
#import "LKStation.h"
#import "UILabelExt.h"
#import "BUSDBHelper.h"
#import "BHBusHelper.h"
#import "LKBus.h"

@interface BHRouteMapBoard ()
{
    NSArray *_stationsInRoute;
    NSMutableArray *_busAnnos;
    BHBusHelper *_busHelper;
}
- (void)addRouteIndicator:(LKRoute *)route;
- (void)addBusIndicators:(NSArray *)buses;
- (void)addSitesIndicator:(NSArray *)sites;
- (void)addRoutePolyline:(NSArray *)paths;
- (void)getRealTimeBuses;
- (NSArray *)busesBySorted:(NSArray *)buses;    // 按照level和距离排序
- (NSArray *)getUnOverBuses:(NSArray *)buses;   // 获取未经过当前站台的所有车辆信息
@end


#define kDurationLabelTag  6823
#define kSubtitleLabelTag  6824


@implementation BHRouteMapBoard

DEF_SIGNAL( MAP_REFRESH );

@synthesize route = _route;

- (void)load
{
    _busAnnos = [[NSMutableArray alloc] initWithCapacity:0];
    _busHelper = [[BHBusHelper alloc] init];
    [_busHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_busHelper removeObserver:self];
    SAFE_RELEASE(_busHelper);
    SAFE_RELEASE(_busAnnos);
    SAFE_RELEASE(_route);
    [super unload];
}

- (void)handleMenu
{
    [_busHelper removeObserver:self];
    SAFE_RELEASE(_busHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_bus.png"] title:nil];
        [self addNavMenus];
	}
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [self loadStationsInRoute:_route];
        [self addRouteIndicator:_route];
        [self addSitesIndicator:_stationsInRoute];
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.MAP_REFRESH] )
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self getRealTimeBuses];
    }
}


#pragma mark -
#pragma mark private methods

- (void)addNavMenus
{
    CGSize size = [_route.line_name sizeWithFont:FONT_SIZE(15) constrainedToSize:CGSizeMake(320.0, 44.0)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(48.f, 5.f, size.width, 20.f)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = FONT_SIZE(15);
    titleLabel.text = _route.line_name;
    [self.navigationBar addSubview:titleLabel];
    [titleLabel release];
    
    UILabelExt *durationLabel = [[UILabelExt alloc] initWithFrame:CGRectMake(54.f+size.width, 5.f, 200.f, 20.f)];
    durationLabel.backgroundColor = [UIColor clearColor];
    durationLabel.tag = kDurationLabelTag;
    durationLabel.font = FONT_SIZE(12);
    durationLabel.textColor = [UIColor lightGrayColor];
    [self.navigationBar addSubview:durationLabel];
    [durationLabel release];
    
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(48.f, 25.f, 200.f, 18.f)];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.tag = kSubtitleLabelTag;
    subtitleLabel.font = FONT_SIZE(12);
    subtitleLabel.textColor = [UIColor lightGrayColor];
    [self.navigationBar addSubview:subtitleLabel];
    [subtitleLabel release];
    
    BeeUIButton *refreshButton = [BeeUIButton new];
    refreshButton.frame = CGRectMake(320-40, 2.f, 40.f, 40.f);
    refreshButton.image = [UIImage imageNamed:@"icon_refresh.png"];
    [refreshButton addSignal:self.MAP_REFRESH forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:refreshButton];
}

- (void)loadStationsInRoute:(LKRoute *)route
{
    // 加载线路经过的所有站台数据
    _stationsInRoute = [[BUSDBHelper sharedInstance] queryStationsInRouteByRouteID:route.line_id andUDType:route.ud_type];
    
    // 重置NavBar上下行数据
    UILabel *subtitleLabel = (UILabel *)[self.navigationBar viewWithTag:kSubtitleLabelTag];
    [subtitleLabel setText:[NSString stringWithFormat:@"%@-%@", route.st_start, route.st_end]];
    
    UILabel *durationLabel = (UILabel *)[self.navigationBar viewWithTag:kDurationLabelTag];
    [durationLabel setText:[NSString stringWithFormat:@"(%@-%@)", _route.start_time, _route.end_time]];
}

- (void)addRouteIndicator:(LKRoute *)route
{
    // 添加当前站台标注
    SBAnnotation *annotation = [[SBAnnotation alloc] init];
    annotation.title = route.st_appoint.st_name;
    annotation.coordinate = CLLocationCoordinate2DMake(route.st_appoint.st_real_lat, route.st_appoint.st_real_lon);
    annotation.mode = SBAnnoModeStationIndicator;
    [self.annotations addObject:annotation];
    [annotation release];
    
    // 获取线路轨迹
    //[_busHelper getRoutePathsById:route.rid];
    
    // 获取实时数据
    [self getRealTimeBuses];
}

- (void)addBusIndicators:(NSArray *)busArray
{
    [self.mapView removeAnnotations:_busAnnos];
    
    for ( LKBus *bus in busArray )
    {
        SBAnnotation *annotation = [[SBAnnotation alloc] init];
        annotation.mode = SBAnnoModeBusIndicator;
        annotation.title = [NSString stringWithFormat:@"约%dm  %0.1fkm/h", bus.st_dis, bus.bus_speed];
        annotation.subtitle = [NSString stringWithFormat:@"id : %d", bus.bus_id];
        annotation.canCallout = YES;
        annotation.coordinate = bus.bus_coor;
        [_busAnnos addObject:annotation];
        [self.mapView addAnnotation:annotation];
        [annotation release];
    }
}

- (void)addSitesIndicator:(NSArray *)sites
{
    for ( LKStation *site in sites )
    {
        if ( ![site.st_name is:_route.st_appoint.st_name] )
        {
            SBAnnotation *annotation = [[SBAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(site.st_real_lat, site.st_real_lon);
            annotation.title = site.st_name;
            annotation.mode = SBAnnoModeRouteIndicator;
            annotation.index = [sites indexOfObject:site];
            annotation.canCallout = ![site.st_name isEqual:_route.st_appoint.st_name];
            [self.annotations addObject:annotation];
            [annotation release];
        }
    }
    [self.mapView addAnnotations:self.annotations];
    
    // 绘制线路
    CLLocationCoordinate2D pointsToUse[[sites count]];
    for ( int i = 0; i< sites.count; i++ )
    {
        LKStation *station = sites[i];
        CLLocationCoordinate2D coords;
        coords.latitude = station.st_real_lat;
        coords.longitude = station.st_real_lon;
        pointsToUse[i] = coords;
    }
    MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:pointsToUse count:[sites count]];
    [self.mapView addOverlay:lineOne];
}

- (void)addRoutePolyline:(NSArray *)paths
{
    // 绘制线路
    CLLocationCoordinate2D pointsToUse[[paths count]];
    for (int i = 0; i < paths.count; i++) {
        CLLocationCoordinate2D coords;
        coords.latitude = [paths[i][@"lat"] doubleValue];
        coords.longitude = [paths[i][@"long"] doubleValue];
        pointsToUse[i] = coords;
    }
    MAPolyline *lineOne = [MAPolyline polylineWithCoordinates:pointsToUse count:[paths count]];
    [self.mapView addOverlay:lineOne];
}

- (void)getRealTimeBuses
{
    [_busHelper getRealTimeDataByRouteId:_route.line_id andUDType:_route.ud_type];
}

- (NSArray *)busesBySorted:(NSArray *)buses
{
    // 先按照按车辆的level进行排序,如果level相同在按照距离进行排序
    NSArray *sortedBuses = [buses sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        LKBus *bus1 = (LKBus *)obj1;
        LKBus *bus2 = (LKBus *)obj2;
        
        if ( bus1.st_level < bus2.st_level ) {
            return NSOrderedDescending;
        }
        
        if ( bus1.st_level > bus2.st_level ) {
            return NSOrderedAscending;
        }
        
        if ( bus1.st_level == bus2.st_level )
        {
            if ( bus1.st_dis < bus2.st_dis ) {
                return NSOrderedDescending;
            }
            
            if ( bus1.st_dis > bus2.st_dis ) {
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }
        return NSOrderedSame;
    }];
    
    return sortedBuses;
}

- (NSArray *)getUnOverBuses:(NSArray *)buses
{
    NSMutableArray *unovers = [NSMutableArray arrayWithCapacity:0];
    
    // 取level小于当前站台的所有车辆
    for ( LKBus *bus in buses )
    {
        if ( bus.st_level <= _route.st_appoint.st_level ) {
            [unovers addObject:bus];
        }
    }
    
    return unovers;
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        [self presentLoadingTips:@"加载中..."];
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        
        if ( [request.userInfo is:@"getLinePath"] )
        {
            [self addRoutePolyline:_busHelper.paths];
        }
        else if ( [request.userInfo is:@"getRealtimeData"] )
        {
            // 按照level和距离排序
            NSArray *sortedBuses = [self busesBySorted:_busHelper.buses];
            NSArray *unovers = [self getUnOverBuses:sortedBuses];
            [self addBusIndicators:unovers];
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(getRealTimeBuses) withObject:nil afterDelay:10];
        }
	}
    else if ( request.failed )
    {
        [self dismissTips];
    }
}


#pragma mark-
#pragma mark 标注

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ( [annotation isKindOfClass:[SBAnnotation class]] )
    {
		static NSString *identifier = @"identifier";
        SBAnnotationView *annotationView = (SBAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if ( !annotationView ) {
            annotationView = [[[SBAnnotationView alloc] initWithReuseIdentifier:identifier] autorelease];
        }
        [annotationView setPointAnnotation:annotation];
        return annotationView;
	}
    
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *lineview = [[MAPolylineView alloc] initWithOverlay:overlay];
        lineview.strokeColor = [UIColor flatBlueColor];  //路线颜色
        lineview.lineWidth = 8.0;
        return lineview;
    }
    return nil;
}

@end
