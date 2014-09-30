//
//  MAMapViewBoard.h
//  SmartBus
//
//  Created by launching on 14-4-23.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHSampleBoard.h"
#import <MAMapKit/MAMapKit.h>
#import "SBAnnotationView.h"

@interface MAMapViewBoard : BHSampleBoard<MAMapViewDelegate>

@property (nonatomic, retain, readonly) MAMapView *mapView;
@property (nonatomic, retain) NSMutableArray *annotations;  // 覆盖物

// 打开/关闭定位
- (void)startShowingUserLocation;
- (void)stopShowingUserLocation;

// 设置ZoomLevel
- (void)setZoomLevel:(CGFloat)zoomLevel;

// 清除所有覆盖物
- (void)clearAllAnns;

// 清除覆盖物(不包括用户的定位点)
- (void)clearAnnsNotIncludeUser;

@end
