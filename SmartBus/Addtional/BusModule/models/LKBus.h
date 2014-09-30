//
//  LKBus.h
//  SmartBus
//
//  Created by launching on 14-6-25.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKBus : NSObject

// BUS_ID
@property (nonatomic, assign) int bus_id;

// 速度
@property (nonatomic, assign) float bus_speed;

// 车子的高德经纬度
@property (nonatomic, assign) CLLocationCoordinate2D bus_coor;

// 站台ID
@property (nonatomic, assign) int st_id;

// 站台LEVEL
@property (nonatomic, assign) int st_level;

// 距离站台多少米
@property (nonatomic, assign) int st_dis;

// 刷新时间
@property (nonatomic, assign) int rtime;

@end
