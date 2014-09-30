//
//  BHFavoriteHelper.h
//  SmartBus
//
//  Created by launching on 13-10-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHFavoriteModel.h"

@interface BHFavoriteHelper : BeeModel

@property (nonatomic, retain) NSMutableArray *favorites;
@property (nonatomic, assign) BOOL succeed;  // 操作是否成功
@property (nonatomic, assign) int collect_id;

// 添加站台收藏
- (void)addStationCollect:(int)st_id;

// 取消站台收藏
- (void)removeStationCollect:(int)collect_id;

// 添加线路收藏
- (void)addLineCollect:(int)line_id updown:(int)ud_type stationId:(int)st_id;

// 取消线路收藏
- (void)removeLineCollect:(int)collect_id;

// 获取收藏列表
- (void)getFavorites;

@end