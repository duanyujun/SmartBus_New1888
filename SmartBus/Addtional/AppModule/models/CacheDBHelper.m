//
//  CacheDBHelper.m
//  SmartBus
//
//  Created by launching on 14-5-14.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "CacheDBHelper.h"
#import "BUSDBHelper.h"

#define TABLE_NAME_HISTORY   @"ibus_histories"

@implementation CacheDBHelper

DEF_SINGLETON( CacheDBHelper );

@synthesize usingDb = __usingDb;

- (id)init
{
    if ( self = [super init] ) {
        [self initialize];
    }
    return self;
}

- (void)insertIntoHistories:(int)his_id at:(HISTORY_MODE)mode addtion:(int)add_type
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?, ?, ?);", TABLE_NAME_HISTORY];
    [self.usingDb executeUpdate:sql, [NSNumber numberWithInt:his_id],
                                     [NSNumber numberWithInt:mode],
                                     [NSNumber numberWithInt:add_type]];
}

- (void)insertIntoHistories:(int)his_id at:(HISTORY_MODE)mode
{
    [self insertIntoHistories:his_id at:mode addtion:0];
}

- (NSArray *)queryHistoriesAt:(HISTORY_MODE)mode
{
    NSMutableArray *histories = [NSMutableArray arrayWithCapacity:0];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE his_mode = %d;", TABLE_NAME_HISTORY, mode];
    FMResultSet *rs = [self.usingDb executeQuery:sql];
    while ( rs.next )
    {
        int his_id = [rs intForColumn:@"his_id"];
        
        if ( mode == HISTORY_MODE_STATION )
        {
            LKStation *station = [[BUSDBHelper sharedInstance] queryStationByID:his_id];
            [histories addObject:station];
        }
        else if ( mode == HISTORY_MODE_ROUTE )
        {
            int his_add = [rs intForColumn:@"his_add"];
            LKRoute *route = [[BUSDBHelper sharedInstance] queryRouteByID:his_id udType:his_add];
            [histories addObject:route];
        }
        else
        {
            [histories addObject:[rs stringForColumn:@"his_id"]];
        }
    }
    
    return histories;
}


#pragma mark -
#pragma mark private methods

- (void)initialize
{
    // 首先指定DB文件路径,才能打开文件查询
    __usingDb = [[FMDatabase alloc] initWithPath:[self dbPath]];
    if ( [self.usingDb open] )
    {
        // 创建表
        [self buildTable];
    }
}

- (NSString *)dbPath
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *cacheDirectory = [DOCUMENTS stringByAppendingPathComponent:@"caches"];
    if ( NO == [fileMgr fileExistsAtPath:cacheDirectory] )
	{
		[fileMgr createDirectoryAtPath:cacheDirectory
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
	}
    return [cacheDirectory stringByAppendingPathComponent:@"cache.db"];
}

- (BOOL)buildTable
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS 'ibus_histories' ("
    "his_id INTEGER NOT NULL, "
    "his_mode INTEGER NOT NULL,"
    "his_add INTEGER NOT NULL,"
    "PRIMARY KEY ('his_id', 'his_mode')"
    ");";
    return [__usingDb executeUpdate:sql];
}

@end
