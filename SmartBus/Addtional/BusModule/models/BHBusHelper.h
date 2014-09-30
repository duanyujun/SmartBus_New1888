//
//  BHBusHelper.h
//  SmartBus
//
//  Created by launching on 13-9-29.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BHBusHelper.h"
#import "LKAdditionInfo.h"
#import "LKStation.h"
#import "LKBus.h"
#import "BHCheckModel.h"
#import "BHLEDDesc.h"

@interface BHBusHelper : BeeModel

@property (nonatomic, retain) NSMutableArray *nodes;
@property (nonatomic, retain) NSMutableArray *buses;  // 车辆数据
@property (nonatomic, retain) NSMutableArray *paths;  // 线路轨迹
@property (nonatomic, retain) LKAdditionInfo *addInfo;
@property (nonatomic, retain) NSURL *jnURL;
@property (nonatomic, assign) BOOL succeed;

// 获取站台信息
- (void)getStationInfo:(NSInteger)st_id;

// 获取站台LED信息
- (void)getLEDByStationId:(NSInteger)staid;

// 获取线路信息
- (void)getLineInfo:(int)line_id updown:(int)ud_type station:(int)st_id;

// 获取线路详情
- (void)getLineDetail:(int)line_id updown:(int)ud_type station:(int)st_id;

// 获取站台/线路最新一条动态(如果是获取线路的动态,st_id传0即可)
- (void)getNewDynamic:(int)weiba_id inStation:(int)st_id;

// 获取公交实时数据(新接口)
- (void)getRealTimeDataByRouteId:(int)line_id andUDType:(int)ud_type;

// 获取线路轨迹
- (void)getRoutePathsById:(NSInteger)rid;

// 获取江宁公交URL
- (void)getJNBusInfoByRoute:(LKRoute *)route;

// 获取一起等车的人
- (void)getWaitsForStation:(NSInteger)st_id;

// 站台签到
- (void)checkInStation:(NSInteger)sid;

// 获取站台签到列表
- (void)getStationChecks;

@end
