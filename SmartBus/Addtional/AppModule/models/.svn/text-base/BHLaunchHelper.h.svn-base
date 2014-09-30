//
//  BHLaunchHelper.h
//  SmartBus
//
//  Created by launching on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_Model.h"
#import "BHLaunchModel.h"

@interface BHLaunchHelper : BeeModel

AS_NOTIFICATION( TIPS_IMPORTANT );

@property (nonatomic, assign) BOOL succeed;

// 获取启动信息
- (void)getLaunchInfo;

// 提交APP TOKEN
- (void)submitAppToken:(NSString *)token;

// 获取重要通知
- (void)getImportNotice;

// 时间校正
- (void)checkTime;

//新接口获取版本信息
- (void)SBGetVersion;
@end
