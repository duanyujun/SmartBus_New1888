//
//  BHTaskHelper.h
//  SmartBus
//
//  Created by launching on 13-12-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_Model.h"
#import "BHTaskRegModel.h"

@interface BHTaskHelper : BeeModel

@property (nonatomic, assign) BOOL succeed;
@property (nonatomic, retain) BHTaskRegModel *taskReg;
@property (nonatomic, assign) int con_num;
@property (nonatomic, assign) int coin;

// 首页签到
- (void)sigInTask;

// 获取本月的签到记录
- (void)getCheckList;

// 发布心情
- (void)postStatus:(NSString *)status;

@end
