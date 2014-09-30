//
//  BUSDBHelper.h
//  SmartBus
//
//  Created by launching on 14-5-14.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKStation.h"
#import "LKRoute.h"
#import "FMDatabase.h"

// 线路表
static NSString *TABLE_NAME_LINE          = @"ibus_line";

// 站台表
static NSString *TABLE_NAME_STATION       = @"ibus_station";

// 上下行线路关系表
static NSString *TABLE_NAME_LINE_UPDOWN   = @"ibus_line_updown";

// 线路站台关系表
static NSString *TABLE_NAME_LINE_STATION  = @"ibus_line_stations";

/**
 *  公交数据工具类
 */
@interface BUSDBHelper : NSObject

AS_SINGLETON( BUSDBHelper );

@property (nonatomic, retain) FMDatabase *usingDb;

/**
 *  @brief  查询附近站台及站台信息
 *
 *  @param  coor           当前坐标(经纬度)
 *
 *  @return 返回所有线路信息
 *
 */
- (NSArray *)queryNearbyStations:(CLLocationCoordinate2D)coor;

/**
 *  @brief  根据站台名查询所经过的线路信息
 *
 *  @param  station_name    站台名(对应数据库里的station_name字段)
 *
 *  @return 返回所有线路信息
 *
 */
- (NSArray *)queryRoutesByStationName:(NSString *)station_name;

/**
 *  @brief  根据线路代码和上下行标志获取整条线路所经过的站台信息
 *
 *  @param  line_id    线路代码(对应数据库里的line_id字段)
 *  @param  ud_type    上下行标志(对应数据库里的updown_type字段)
 *
 *  @return 返回该线路所经过的所有站台及顺序
 *
 */
- (NSArray *)queryStationsInRouteByRouteID:(int)line_id andUDType:(int)ud_type;

/**
 *  @brief  根据关键字模糊查询站台名
 *
 *  @param  key    用户输入的关键字
 *
 *  @return 返回所有匹配条件的站台信息
 *
 */
- (NSArray *)blurredQueryStations:(NSString *)key;

/**
 *  @brief  根据关键字模糊查询线路名
 *
 *  @param  key    用户输入的关键字
 *
 *  @return 返回所有匹配条件的线路信息
 *
 */
- (NSArray *)blurredQueryRoutes:(NSString *)key;

/**
 *  @brief  根据ID查询站台信息
 *
 *  @param  st_id      站台ID
 *
 *  @return 返回查询到的站台信息
 *
 */
- (LKStation *)queryStationByID:(int)st_id;

/**
 *  @brief  根据ID查询线路信息
 *
 *  @param  line_id      线路ID
 *  @param  ud_type      上下行标志
 *
 *  @return 返回查询到的线路信息
 *
 */
- (LKRoute *)queryRouteByID:(int)line_id udType:(int)ud_type;

/**
 *  @brief  根据ID查询线路信息
 *
 *  @param  line_id      线路ID
 *
 *  @return 返回查询到的线路信息(分为上下行)
 *
 */
- (NSArray *)queryRoutesByID:(int)line_id;

/**
 *  @brief  查询指定表中最大更新时间
 *
 *  @param  tab_name     指定的表名
 *
 *  @return 返回最大更新时间
 *
 */
- (double)queryMaxUpdateTimeInTable:(NSString *)tab_name;

/**
 *  @brief  插入数据
 *
 *  @param  objects    需要插入的数据(NSDictionary)
 *  @param  tab_name   需要插入的表名
 *
 */
- (void)insertObjects:(NSArray *)objects intoTable:(NSString *)tab_name;

/**
 *  @brief  删除数据
 *
 *  @param  objects   需要删除的数据(只需要取里面的主键)
 *  @param  tab_name  需要删除的表名
 *
 */
- (BOOL)removeObjects:(NSArray *)objects fromTable:(NSString *)tab_name;

/**
 *  @brief  更新数据(此处实际上是先删再插)
 *
 *  @param  objects   需要更新的数据
 *  @param  tab_name  需要更新的表名
 *
 */
- (void)updateObjects:(NSArray *)objects intoTable:(NSString *)tab_name;

/**
 *  @brief  检测更新内容
 *
 *  @param  tab_name  需要更新的表名
 *
 */
- (void)checkTable:(NSString *)tab_name;

@end
