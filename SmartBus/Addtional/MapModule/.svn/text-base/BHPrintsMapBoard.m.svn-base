//
//  BHPrintsMapBoard.m
//  SmartBus
//
//  Created by launching on 14-4-23.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHPrintsMapBoard.h"
#import "BHUserHelper.h"

@implementation BHPrintsMapBoard
{
    BHUserHelper *_userHelper;
}

- (void)load
{
    _userHelper = [[BHUserHelper alloc] init];
    [_userHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_userHelper removeObserver:self];
    SAFE_RELEASE(_userHelper);
    [super unload];
}

- (void)handleMenu
{
    [_userHelper removeObserver:self];
    SAFE_RELEASE(_userHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_footprint.png"] title:@"我的足迹"];
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
        // 获取签到信息
        [_userHelper performSelector:@selector(getStationChecks) withObject:nil afterDelay:0.2f];
	}
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
        
        if ( [request.userInfo is:@"getStationCheckList"] )
        {
            [self addFootPrintsIndicator:_userHelper.nodes];
        }
	}
    else if ( request.failed )
    {
        [self dismissTips];
    }
}


#pragma mark -
#pragma mark private methods

- (void)addFootPrintsIndicator:(NSArray *)prints
{
    [self clearAllAnns];
    
    for ( BHCheckModel *check in prints )
    {
        if ( check.coor.latitude > 0.f && check.coor.longitude > 0.f )
        {
            SBAnnotation *annotation = [[SBAnnotation alloc] init];
            annotation.coordinate = check.coor;
            annotation.mode = SBAnnoModeFeetIndicator;
            [self.annotations addObject:annotation];
            [annotation release];
        }
    }
    [self.mapView addAnnotations:self.annotations];
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
