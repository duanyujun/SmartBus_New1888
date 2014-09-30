//
//  LKRoute.h
//  SmartBus
//
//  Created by launching on 14-6-19.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UPDOWN_TYPE_UP = 0,
    UPDOWN_TYPE_DOWN
} UPDOWN_TYPE;

@class LKStation;

@interface LKRoute : NSObject

// 线路ID
@property (nonatomic, assign) int line_id;

// 线路代码
@property (nonatomic, assign) int line_code;

// 微吧ID(也就是原始的线路ID)
@property (nonatomic, assign) int weiba_id;

// 线路名称
@property (nonatomic, retain) NSString *line_name;

// 起点站
@property (nonatomic, retain) NSString *st_start;

// 终点站
@property (nonatomic, retain) NSString *st_end;

// 运营开始时间
@property (nonatomic, retain) NSString *start_time;

// 运营结束时间
@property (nonatomic, retain) NSString *end_time;

// 上下行标志(0:上行  1:下行)
@property (nonatomic, assign) UPDOWN_TYPE ud_type;

// 当前站台(LKStation)
@property (nonatomic, retain) LKStation *st_appoint;

// 是否为江宁线路(ltd=3表示江宁的线路)
@property (nonatomic, assign) int line_ltd;

@end
