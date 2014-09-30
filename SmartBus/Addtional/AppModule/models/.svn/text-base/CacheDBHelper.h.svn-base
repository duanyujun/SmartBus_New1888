//
//  CacheDBHelper.h
//  SmartBus
//
//  Created by launching on 14-5-14.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

typedef enum {
    HISTORY_MODE_STATION = 0,
    HISTORY_MODE_ROUTE,
    HISTORY_MODE_ANNOUCE
} HISTORY_MODE;

@interface CacheDBHelper : NSObject

AS_SINGLETON( CacheDBHelper );

@property (nonatomic, retain) FMDatabase *usingDb;

/**
 *  @brief  插入一条搜索的历史记录(搜索后，点击某一记录才保存), 公告的记录是已读记录
 *
 *  @param  his_id      历史记录ID(递增)
 *  @param  mode        历史记录的模式
 *  @param  add_type    如果是线路的记录,那么add_type表示是上行还是下行(0:下行 1:上行)
 *
 */
- (void)insertIntoHistories:(int)his_id at:(HISTORY_MODE)mode addtion:(int)add_type;
- (void)insertIntoHistories:(int)his_id at:(HISTORY_MODE)mode;

/**
 *  @brief  查询历史记录
 *
 *  @param  mode        历史记录的模式
 *
 *  @return 查询结果(ID数组)
 *
 */
- (NSArray *)queryHistoriesAt:(HISTORY_MODE)mode;

@end
