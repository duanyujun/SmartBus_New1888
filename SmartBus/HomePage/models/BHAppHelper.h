//
//  BHAppHelper.h
//  SmartBus
//
//  Created by launching on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_Model.h"
#import "BHAppModel.h"

@interface BHAppHelper : BeeModel

@property (nonatomic, assign) BOOL succeed;
@property (nonatomic, retain) BHAppModel *app;

// 获取首页信息
- (void)getAppHomeInfo;

// 获取广告列表
- (void)getAppAdverts;

// 广告统计(TYPE取值: 1-启动图 2-首页 3-站台 4-线路)
+ (void)submitAdvInfoById:(NSInteger)adid andType:(NSInteger)type;

@end
