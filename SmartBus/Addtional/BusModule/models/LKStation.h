//
//  LKStation.h
//  SmartBus
//
//  Created by launching on 14-6-19.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKRoute.h"
#import "BHSectionModel.h"

@interface LKStation : NSObject

// 站台代码
@property (nonatomic, assign) int st_id;

// 微吧ID(也就是原始的站台ID)
@property (nonatomic, assign) int weiba_id;

// 站台名称
@property (nonatomic, retain) NSString *st_name;

// 站台LEVEL
@property (nonatomic, assign) int st_level;

// 站台纬度
@property (nonatomic, assign) double st_real_lat;

// 站台经度
@property (nonatomic, assign) double st_real_lon;

// 距离当前坐标多少米(查询附近站台时)
@property (nonatomic, assign) double distance;

// 经过该站台的所有线路(LKRoute数组)
@property (nonatomic, retain) NSMutableArray *st_routes;

@end
