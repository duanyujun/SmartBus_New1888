//
//  BHSiteMapBoard.m
//  SmartBus
//
//  Created by launching on 13-10-31.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "BHSiteMapBoard.h"
#import "LKStation.h"

@interface BHSiteMapBoard ()<MAMapViewDelegate>
{
    LKStation *_station;
}
- (void)addStationTipsBar;
- (void)addStationIndicator:(id)station;
@end

#define kStaNameLabelTag   74185
#define kRoutesLabelTag    74186

@implementation BHSiteMapBoard

DEF_SIGNAL( TARGET )

- (void)unload
{
    SAFE_RELEASE(_station);
    [super unload];
}

- (id)initWithSite:(id)site
{
    if ( self = [super init] )
    {
        _station = [(LKStation *)site retain];
    }
    return self;
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_station.png"] title:@"站台地图"];
        [self addStationTipsBar];
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(_station.st_real_lat, _station.st_real_lon) animated:YES];
        [self addStationIndicator:_station];
	}
}


#pragma mark -
#pragma mark private methods

- (void)addStationIndicator:(LKStation *)station
{
    // 添加标注
    SBAnnotation *annotation = [[SBAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(station.st_real_lat, station.st_real_lon);
    annotation.title = station.st_name;
    annotation.mode = SBAnnoModeStationIndicator;
    [self.mapView addAnnotation:annotation];
    [annotation release];
}

- (void)addStationTipsBar
{
    UIView *bmkTipsBar = [[UIView alloc] initWithFrame:CGRectMake(0.f, self.beeView.bounds.size.height-49.f, 320.f, 49.f)];
    bmkTipsBar.backgroundColor = [UIColor whiteColor];
    bmkTipsBar.layer.shadowColor = [UIColor flatDarkGrayColor].CGColor;
    bmkTipsBar.layer.shadowOffset = CGSizeMake(0, 0);
    bmkTipsBar.layer.shadowOpacity = 0.8;
    bmkTipsBar.layer.shadowRadius = 1.5;
    
    UILabel *snameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 5.f, 250.f, 20.f)];
    snameLabel.backgroundColor = [UIColor clearColor];
    snameLabel.tag = kStaNameLabelTag;
    snameLabel.font = BOLD_FONT_SIZE(15);
    snameLabel.text = _station.st_name;
    [bmkTipsBar addSubview:snameLabel];
    [snameLabel release];
    
    NSMutableString *lidstr = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < _station.st_routes.count; i++) {
        LKRoute *route = _station.st_routes[i];
        [lidstr appendFormat:@"%@/", route.line_name];
    }
    UILabel *routesLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 28.f, 300.f, 16.f)];
    routesLabel.backgroundColor = [UIColor clearColor];
    routesLabel.tag = kRoutesLabelTag;
    routesLabel.font = FONT_SIZE(14);
    routesLabel.textColor = [UIColor lightGrayColor];
    routesLabel.text = [lidstr substringToIndex:lidstr.length-1];
    [bmkTipsBar addSubview:routesLabel];
    [routesLabel release];
    
    [self.beeView addSubview:bmkTipsBar];
    [bmkTipsBar release];
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

@end
