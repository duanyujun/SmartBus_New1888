//
//  BHSiteMapBoard.m
//  SmartBus
//
//  Created by launching on 13-10-31.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSiteMapBoard.h"
#import "BHStationModel.h"
#import "BHDisplayRoute.h"
#import "BHPointAnnotation.h"
#import "BHAnnotationView.h"
#import "BMapKit.h"

@interface BHSiteMapBoard ()<BMKMapViewDelegate>
{
    BMKMapView *bmkMapView;
    BHPointAnnotation *_annotation;
    BOOL firstLocating;
}
- (void)addStationTipsBar;
- (void)addStationIndicator:(id)station;
@end

#define kStaNameLabelTag   74185
#define kRoutesLabelTag    74186

@implementation BHSiteMapBoard

DEF_SIGNAL( TARGET )

@synthesize station = _station;
@synthesize displays = _displays;

- (void)load
{
    firstLocating = YES;
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(_annotation);
    SAFE_RELEASE(_station);
    SAFE_RELEASE(_displays);
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
        
        CGRect rc = self.beeView.bounds;
        BeeUIButton *targetButton = [BeeUIButton new];
        targetButton.frame = CGRectMake(rc.size.width-50.f, rc.size.height-94.f, 40.f, 40.f);
        targetButton.image = [UIImage imageNamed:@"icon_target.png"];
        [targetButton addSignal:BHSiteMapBoard.TARGET forControlEvents:UIControlEventTouchUpInside];
        [self.beeView addSubview:targetButton];
        
        [self addStationTipsBar];
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
        [self addStationIndicator:_station];
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
        bmkMapView.delegate = nil;
        [[BHAPP reveal] setAllowsReveal:YES];
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:BHSiteMapBoard.TARGET] )
    {
        [bmkMapView setCenterCoordinate:_annotation.coordinate];
    }
}


#pragma mark -
#pragma mark private methods

- (void)addStationIndicator:(BHStationModel *)station
{
    [bmkMapView removeAnnotation:_annotation];
    
    _annotation = [[BHPointAnnotation alloc] init];
    _annotation.coordinate = station.mapcoor;
    _annotation.title = station.sname;
    _annotation.mode = AnnoModeStationIndicator;
    
    // 添加标注
    [bmkMapView addAnnotation:_annotation];
}

- (void)addStationTipsBar
{
    UIView *bmkTipsBar = [[UIView alloc] initWithFrame:CGRectMake(0.f, self.beeView.bounds.size.height-49.f, 320.f, 49.f)];
    bmkTipsBar.backgroundColor = [UIColor whiteColor];
    bmkTipsBar.layer.shadowColor = [UIColor flatDarkGrayColor].CGColor;
    bmkTipsBar.layer.shadowOffset = CGSizeMake(0, 0);
    bmkTipsBar.layer.shadowOpacity = 0.8;
    bmkTipsBar.layer.shadowRadius = 1.5;
    
    UILabel *snameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 6.f, 250.f, 20.f)];
    snameLabel.backgroundColor = [UIColor clearColor];
    snameLabel.tag = kStaNameLabelTag;
    snameLabel.font = FONT_SIZE(15);
    snameLabel.text = _station.sname;
    [bmkTipsBar addSubview:snameLabel];
    [snameLabel release];
    
    NSMutableString *lidstr = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < _displays.count; i++) {
        BHDisplayRoute *display = [_displays objectAtIndex:i];
        [lidstr appendFormat:@"%@ / ", display.displayName];
    }
    UILabel *routesLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 26.f, 300.f, 16.f)];
    routesLabel.backgroundColor = [UIColor clearColor];
    routesLabel.tag = kRoutesLabelTag;
    routesLabel.font = FONT_SIZE(12);
    routesLabel.textColor = [UIColor lightGrayColor];
    routesLabel.text = [lidstr substringToIndex:lidstr.length - 2];
    [bmkTipsBar addSubview:routesLabel];
    [routesLabel release];
    
    [self.beeView addSubview:bmkTipsBar];
    [bmkTipsBar release];
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

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"select");
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if ( firstLocating )
    {
        [mapView setCenterCoordinate:_annotation.coordinate];
    }
    firstLocating = NO;
}

@end
