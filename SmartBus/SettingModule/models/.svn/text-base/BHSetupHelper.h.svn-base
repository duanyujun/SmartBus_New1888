//
//  BHSetupHelper.h
//  SmartBus
//
//  Created by launching on 13-11-26.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_Model.h"

typedef enum {
    PRIVACY_TYPE_TRENDS = 1,
    PRIVACY_TYPE_PROFILE,
    PRIVACY_TYPE_MAP,
    PRIVACY_TYPE_SOCIAL
} PRIVACY_TYPE;

@interface BHSetupHelper : BeeModel

@property (nonatomic, assign) BOOL succeed;
@property (nonatomic, retain) NSMutableArray *status;  // 隐私状态
@property (nonatomic, retain) NSString *tips;  // 说明和帮助内容

// 意见反馈
- (void)feedback:(NSString *)content atPhone:(NSString *)phone username:(NSString *)uname;

// 获取隐私设置
- (void)getPrivacy;

// 隐私设置提交
- (void)setPrivacy:(PRIVACY_TYPE)type value:(NSInteger)value;

// 获取兑换说明/用户帮助
- (void)getInfosByType:(NSInteger)type;

@end
