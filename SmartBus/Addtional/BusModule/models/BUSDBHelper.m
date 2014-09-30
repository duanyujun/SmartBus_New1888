//
//  BUSDBHelper.m
//  SmartBus
//
//  Created by launching on 14-5-14.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BUSDBHelper.h"
#import "ZipArchiveHandler.h"

#define MAX_DISTANCE  500    // 最大距离

@implementation BUSDBHelper

DEF_SINGLETON( BUSDBHelper );

@synthesize usingDb = __usingDb;

- (id)init
{
    if ( self = [super init] )
    {
        [self initialize];
    }
    return self;
}

- (void)dealloc
{
    [__usingDb close];
    SAFE_RELEASE(__usingDb);
    [super dealloc];
}


#pragma mark -
#pragma mark private methods

- (void)initialize
{
    // 开始解压
    if ( [ZipArchiveHandler handleUnzip] )
    {
        // 解压成功后,指定DB文件路径
        NSString *path = [DOCUMENTS stringByAppendingString:@"/caches/ibus_datas.db"];
        __usingDb = [[FMDatabase alloc] initWithPath:path];
        if ( [__usingDb open] ) {
            [__usingDb setKey:@";n78ya5#!"];   // 解密
        }
    }
}

- (CLLocationDistance)distanceWithCoordinate:(CLLocationCoordinate2D)coor fromCoordinate:(CLLocationCoordinate2D)fromCoor
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
    CLLocation *fromLocation = [[CLLocation alloc] initWithLatitude:fromCoor.latitude longitude:fromCoor.longitude];
    CLLocationDistance distance = [location distanceFromLocation:fromLocation];
    return distance;
}


#pragma mark -
#pragma mark fmdb helper

- (NSArray *)queryNearbyStations:(CLLocationCoordinate2D)coor
{
    // 1.查询大致范围的站台
    NSMutableArray *stations = [NSMutableArray arrayWithCapacity:0];
    NSString *sql = [NSString stringWithFormat:@"select st_id, weiba_id, st_name, st_real_lat, st_real_lon from %@ where st_real_lat-%f<0.01 and %f-st_real_lat<0.01 and st_real_lon-%f<0.01 and %f-st_real_lon<0.01 and st_status = 0 group by st_name;", TABLE_NAME_STATION, coor.latitude, coor.latitude, coor.longitude, coor.longitude];
    
    FMResultSet *rs = [self.usingDb executeQuery:sql];
    while ( rs.next )
    {
        LKStation *station = [[LKStation alloc] init];
        station.st_id = [rs intForColumn:@"st_id"];
        station.weiba_id = [rs intForColumn:@"weiba_id"];
        station.st_name = [rs stringForColumn:@"st_name"];
        station.st_real_lat = [rs doubleForColumn:@"st_real_lat"];
        station.st_real_lon = [rs doubleForColumn:@"st_real_lon"];
        [stations addObject:station];
    }
    
    // 2.找出经过该站台的所有线路
    for ( int i = 0; i < stations.count; i++ )
    {
        LKStation *station = stations[i];
        
        CLLocationCoordinate2D st_coor = CLLocationCoordinate2DMake(station.st_real_lat, station.st_real_lon);
        
        station.distance = [self distanceWithCoordinate:st_coor fromCoordinate:coor];
        [station.st_routes addObjectsFromArray:[self queryRoutesByStationName:station.st_name]];
        [stations replaceObjectAtIndex:i withObject:station];
    }
    
    // 3.按照距离排序
    [stations sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        LKStation *station1 = (LKStation *)obj1;
        LKStation *station2 = (LKStation *)obj2;
        
        if ( station1.distance < station2.distance ) {
            return NSOrderedAscending;
        }
        
        if ( station1.distance > station2.distance ) {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
        
    }];
    
    return stations.count > 10 ? [stations subarrayWithRange:NSMakeRange(0, 10)] : stations;
}

- (NSArray *)queryRoutesByStationName:(NSString *)station_name
{
    NSMutableArray *routes = [NSMutableArray arrayWithCapacity:0];
    
    NSString *sql = [NSString stringWithFormat:@"select l.line_id, l.weiba_id, l.line_code, l.line_name, l.ltd from %@ l, %@ s where s.st_name = \'%@\' and l.line_id = s.line_id and l.line_status = 0 group by s.line_id;", TABLE_NAME_LINE, TABLE_NAME_LINE_STATION, station_name];
    
    FMResultSet *rs = [self.usingDb executeQuery:sql];
    while ( rs.next )
    {
        LKRoute *route = [[LKRoute alloc] init];
        route.line_id = [rs intForColumn:@"line_id"];
        route.weiba_id = [rs intForColumn:@"weiba_id"];
        route.line_code = [rs intForColumn:@"line_code"];
        route.line_name = [rs stringForColumn:@"line_name"];
        route.line_ltd = [rs intForColumn:@"ltd"];
        [routes addObject:route];
        [route release];
    }
    
    return routes;
}

- (NSArray *)queryStationsInRouteByRouteID:(int)line_id andUDType:(int)ud_type
{
    NSMutableArray *stations = [NSMutableArray arrayWithCapacity:0];
    
    NSString *sql = [NSString stringWithFormat:@"select s.st_id, i.weiba_id, s.st_stop_level, i.st_name, i.st_real_lat, i.st_real_lon from %@ s, %@ i where s.line_id = %d and s.updown_type = %d and s.st_id = i.st_id and s.line_st_status = 0 group by s.st_stop_level;", TABLE_NAME_LINE_STATION, TABLE_NAME_STATION, line_id, ud_type];
    
    FMResultSet *rs = [self.usingDb executeQuery:sql];
    while ( rs.next )
    {
        LKStation *station = [[LKStation alloc] init];
        station.st_id = [rs intForColumnIndex:0];
        station.weiba_id = [rs intForColumnIndex:1];
        station.st_level = [rs intForColumnIndex:2];
        station.st_name = [rs stringForColumnIndex:3];
        station.st_real_lat = [rs doubleForColumnIndex:4];
        station.st_real_lon = [rs doubleForColumnIndex:5];
        [stations addObject:station];
    }
    
    return stations;
}

- (NSArray *)blurredQueryStations:(NSString *)key
{
    if ( !key || key.length == 0 ) {
        return [NSArray array];
    }
    
    NSMutableArray *stations = [NSMutableArray arrayWithCapacity:0];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where st_name like '%%%@%%' and st_status = 0 group by st_name;", TABLE_NAME_STATION, key];
    
    FMResultSet *rs = [self.usingDb executeQuery:sql];
    while ( rs.next )
    {
        LKStation *station = [[LKStation alloc] init];
        station.st_id = [rs intForColumn:@"st_id"];
        station.weiba_id = [rs intForColumn:@"weiba_id"];
        station.st_name = [rs stringForColumn:@"st_name"];
        station.st_real_lat = [rs doubleForColumn:@"st_real_lat"];
        station.st_real_lon = [rs doubleForColumn:@"st_real_lon"];
        [stations addObject:station];
    }
    
    return stations;
}

- (NSArray *)blurredQueryRoutes:(NSString *)key
{
    if ( !key || key.length == 0 ) {
        return [NSArray array];
    }
    
    NSMutableArray *routes = [NSMutableArray arrayWithCapacity:0];
    
    NSString *sql = [NSString stringWithFormat:@"select l.line_id, l.weiba_id, l.line_code, l.line_name, l.ltd, u.updown_type, a.st_name as st_start, b.st_name as st_end, u.bus_start, u.bus_end from %@ l, %@ u, %@ a, %@ b where a.st_id = u.st_start_id and b.st_id = u.st_end_id and line_name like '%%%@%%'and l.line_id = u.line_id and l.line_status = 0;", TABLE_NAME_LINE, TABLE_NAME_LINE_UPDOWN, TABLE_NAME_STATION, TABLE_NAME_STATION, key];
    
    FMResultSet *rs = [self.usingDb executeQuery:sql];
    while ( rs.next )
    {
        LKRoute *route = [[LKRoute alloc] init];
        route.line_id = [rs intForColumn:@"line_id"];
        route.weiba_id = [rs intForColumn:@"weiba_id"];
        route.line_code = [rs intForColumn:@"line_code"];
        route.line_name = [rs stringForColumn:@"line_name"];
        route.line_ltd = [rs intForColumn:@"ltd"];
        route.ud_type = [rs intForColumn:@"updown_type"];
        route.st_start = [rs stringForColumn:@"st_start"];
        route.st_end = [rs stringForColumn:@"st_end"];
        route.start_time = [rs stringForColumn:@"bus_start"];
        route.end_time = [rs stringForColumn:@"bus_end"];
        [routes addObject:route];
        [route release];
    }
    
    return routes;
}

- (LKStation *)queryStationByID:(int)st_id
{
    LKStation *station = [[LKStation alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where st_id = %d and st_status = 0;", TABLE_NAME_STATION, st_id];
    FMResultSet *rs = [self.usingDb executeQuery:sql];
    while ( rs.next )
    {
        station.st_id = [rs intForColumn:@"st_id"];
        station.weiba_id = [rs intForColumn:@"weiba_id"];
        station.st_name = [rs stringForColumn:@"st_name"];
        station.st_real_lat = [rs doubleForColumn:@"st_real_lat"];
        station.st_real_lon = [rs doubleForColumn:@"st_real_lon"];
    }
    
    return [station autorelease];
}

- (LKRoute *)queryRouteByID:(int)line_id udType:(int)ud_type
{
    LKRoute *route = [[LKRoute alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"select l.line_id, l.weiba_id, l.line_code, l.line_name, l.ltd, u.updown_type, a.st_name as st_start, b.st_name as st_end, u.bus_start, u.bus_end from %@ l, %@ u, %@ a, %@ b where a.st_id = u.st_start_id and b.st_id = u.st_end_id and l.line_id = %d and u.updown_type = %d and l.line_id = u.line_id and l.line_status = 0;", TABLE_NAME_LINE, TABLE_NAME_LINE_UPDOWN, TABLE_NAME_STATION, TABLE_NAME_STATION, line_id, ud_type];
    
    FMResultSet *rs = [self.usingDb executeQuery:sql];
    while ( rs.next )
    {
        route.line_id = [rs intForColumn:@"line_id"];
        route.weiba_id = [rs intForColumn:@"weiba_id"];
        route.line_code = [rs intForColumn:@"line_code"];
        route.line_name = [rs stringForColumn:@"line_name"];
        route.line_ltd = [rs intForColumn:@"ltd"];
        route.ud_type = [rs intForColumn:@"updown_type"];
        route.st_start = [rs stringForColumn:@"st_start"];
        route.st_end = [rs stringForColumn:@"st_end"];
        route.start_time = [rs stringForColumn:@"bus_start"];
        route.end_time = [rs stringForColumn:@"bus_end"];
    }
    
    return [route autorelease];
}

- (NSArray *)queryRoutesByID:(int)line_id
{
    NSMutableArray *routes = [NSMutableArray arrayWithCapacity:2];
    
    NSString *sql = [NSString stringWithFormat:@"select l.line_id, l.weiba_id, l.line_code, l.line_name, u.updown_type, a.st_name as st_start, b.st_name as st_end, u.bus_start, u.bus_end, l.ltd from %@ l, %@ u, %@ a, %@ b where a.st_id = u.st_start_id and b.st_id = u.st_end_id and l.line_id = %d and l.line_id = u.line_id and l.line_status = 0;", TABLE_NAME_LINE, TABLE_NAME_LINE_UPDOWN, TABLE_NAME_STATION, TABLE_NAME_STATION, line_id];
    
    FMResultSet *rs = [self.usingDb executeQuery:sql];
    while ( rs.next )
    {
        LKRoute *route = [[LKRoute alloc] init];
        route.line_id = [rs intForColumn:@"line_id"];
        route.weiba_id = [rs intForColumn:@"weiba_id"];
        route.line_code = [rs intForColumn:@"line_code"];
        route.line_name = [rs stringForColumn:@"line_name"];
        route.ud_type = [rs intForColumn:@"updown_type"];
        route.st_start = [rs stringForColumn:@"st_start"];
        route.st_end = [rs stringForColumn:@"st_end"];
        route.start_time = [rs stringForColumn:@"bus_start"];
        route.end_time = [rs stringForColumn:@"bus_end"];
        route.line_ltd = [rs intForColumn:@"ltd"];
        [routes addObject:route];
        [route release];
    }
    
    return routes;
}

- (double)queryMaxUpdateTimeInTable:(NSString *)tab_name
{
    NSString *updated_column = nil;
    if ( [tab_name is:TABLE_NAME_LINE] ) {
        updated_column = @"line_updated";
    } else if ( [tab_name is:TABLE_NAME_STATION] ) {
        updated_column = @"st_updated";
    } else if ( [tab_name is:TABLE_NAME_LINE_UPDOWN] ) {
        updated_column = @"updown_updated";
    } else {
        updated_column = @"line_st_updated";
    }
    
    NSString *sql = [NSString stringWithFormat:@"select max(%@) from %@;", updated_column, tab_name];
    double max = 0;
    FMResultSet *rs = [self.usingDb executeQuery:sql];
    while ( rs.next ) {
        max = [rs doubleForColumnIndex:0];
    }
    return max;
}

- (void)insertObjects:(NSArray *)objects intoTable:(NSString *)tab_name
{
    NSMutableString *keyStr = [NSMutableString stringWithCapacity:0];
    NSMutableString *valueStr = [NSMutableString stringWithCapacity:0];
    BOOL lastObject = NO;
    BOOL isRollBack = NO;
    
    // 使用事务提交,提高效率
    [self.usingDb beginTransaction];
    
    @try {
        for ( NSDictionary *obj in objects )
        {
            // 重置
            [keyStr setString:@"("];
            [valueStr setString:@"("];
            lastObject = NO;
            
            for ( NSString *key in obj.allKeys )
            {
                lastObject = [[obj.allKeys lastObject] is:key];
                
                [keyStr appendString:key];
                [keyStr appendString:(!lastObject ? @"," : @")")];
                
                NSString *objValue = [obj[key] asNSString];
                if ( [key rangeOfString:@"name"].location != NSNotFound || [key is:@"bus_start"] || [key is:@"bus_end"] ) {
                    objValue = [NSString stringWithFormat:@"\'%@\'", [obj[key] asNSString]];
                }
                
                [valueStr appendString:objValue];
                [valueStr appendString:(!lastObject ? @"," : @")")];
            }
            
            NSString *insertSql = [NSString stringWithFormat:@"replace into %@ %@ values %@;", tab_name, keyStr, valueStr];
            NSLog(@"insertSql :%@", insertSql);
            [self.usingDb executeUpdate:insertSql];
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        NSLog(@"rollback");
        [self.usingDb rollback];
    }
    @finally {
        if (!isRollBack) {
            NSLog(@"table %@ commit", tab_name);
            [self.usingDb commit];
        }
    }
}

- (BOOL)removeObjects:(NSArray *)objects fromTable:(NSString *)tab_name
{
    NSMutableString *valueStr = [NSMutableString stringWithString:@"("];
    
    NSString *key = nil;
    if ( [tab_name is:TABLE_NAME_LINE] ) {
        key = @"line_id";
    } else if ( [tab_name is:TABLE_NAME_STATION] ) {
        key = @"st_id";
    } else if ( [tab_name is:TABLE_NAME_LINE_UPDOWN] ) {
        key = @"updown_id";
    } else {
        key = @"line_station_id";
    }
    
    for ( NSDictionary *obj in objects )
    {
        [valueStr appendString:obj[key]];
        [valueStr appendString:@","];
    }
    
    [valueStr replaceCharactersInRange:NSMakeRange(valueStr.length-1, 1) withString:@")"];
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ in %@;", tab_name, key, valueStr];
    return [self.usingDb executeUpdate:deleteSql];
}

- (void)updateObjects:(NSArray *)objects intoTable:(NSString *)tab_name
{
    if ( [self removeObjects:objects fromTable:tab_name] )
    {
        [self insertObjects:objects intoTable:tab_name];
    }
}

- (void)checkTable:(NSString *)tab_name
{
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@;", tab_name];
    NSLog(@"There is %d datas in %@", [self.usingDb intForQuery:sql], tab_name);
}

@end
