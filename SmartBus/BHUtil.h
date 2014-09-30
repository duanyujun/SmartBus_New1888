//
//  BHUtil.h
//  SmartBus
//
//  Created by launching on 13-9-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BHUserModel;

// 判断网络是否连接正常
extern BOOL connectedToNetwork(void);

typedef void (^ReturnDataCallBackBlock)(NSString *);

@interface BHUtil : NSObject

// 判断是否有更新
+ (BOOL)existNewVersion;

// 判断是否需要提示重要公告信息
+ (BOOL)judgeTipsMessage:(int)msgId;

// 判断手机号码格式是否正确
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

// 设置/读取用户ID
+ (void)saveUserID:(int)uid;
+ (int)userID;

// 保存用户名和密码
+ (void)saveUserPhone:(NSString *)uphone andPassword:(NSString *)pwd;
+ (NSString *)getUserPhoneFromCache;
+ (NSString *)getPasswordFromCache;

// 获取校正后的时间
+ (NSDate *)correctDate;
+ (NSString *)correctDateString;

// URL拼接
+ (NSString *)urlStringWithMethod:(NSString *)method parameters:(NSDictionary *)parameters;

// 加密算法
+ (NSString *)encrypt:(NSString *)str method:(NSString *)method;

// 清除数据库缓存
+ (void)clearDBCache;

@end
