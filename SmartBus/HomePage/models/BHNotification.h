//
//  BHNotification.h
//  SmartBus
//
//  Created by launching on 14-2-11.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHNotification : NSObject

// 推送ID
@property (nonatomic, assign) NSInteger oid;

// 类型 (10:更新 11:公告 12:广告  20:资讯  30:动态  40:私信)
@property (nonatomic, assign) NSInteger type;

// 链接地址
@property (nonatomic, retain) NSString *url;

// 是否已加载
@property (nonatomic, assign) BOOL loaded;

@end
