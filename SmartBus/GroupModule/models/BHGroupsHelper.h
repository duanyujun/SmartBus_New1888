//
//  BHGroupsHelper.h
//  SmartBus
//
//  Created by launching on 13-12-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_Model.h"
#import "BHGroupModel.h"
#import "BHTrendsModel.h"

@interface BHGroupsHelper : BeeModel

@property (nonatomic, retain) NSMutableArray *nodes;
@property (nonatomic, assign) BOOL succeed;

// 获取我的圈子列表
- (void)getMyGroupsAtPage:(NSInteger)page;

// 获取所有圈子列表
- (void)getAllGroupsAtPage:(NSInteger)page;

// 添加/删除圈子的收藏
- (void)toggleFav:(BOOL)toggle toGroup:(NSInteger)wid;

// 获取圈子的信息
- (void)getGroupDescById:(NSInteger)wid;

// 获取圈子动态
- (void)getTrendsById:(NSInteger)wid atPage:(NSInteger)page;

// 获取圈子的所有粉丝
- (void)getFollowsById:(NSInteger)wid atPage:(NSInteger)page;

// 搜索圈子
- (void)searchGroupsInKeyword:(NSString *)key atPage:(NSInteger)page;

@end
