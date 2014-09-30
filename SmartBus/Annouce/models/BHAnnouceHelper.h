//
//  BHAnnouceHelper.h
//  SmartBus
//
//  Created by user on 13-10-29.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_Model.h"
#import "BHAnnouceModel.h"

@interface BHAnnouceHelper : BeeModel

@property (nonatomic ,retain) NSMutableArray *nodes;

// 获取最新一条公告
- (void)getNewNotice;

// 获取公告列表
- (void)getNoticeList;

@end
