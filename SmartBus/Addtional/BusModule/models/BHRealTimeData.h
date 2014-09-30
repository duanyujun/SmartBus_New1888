//
//  BHRealTimeData.h
//  SmartBus
//
//  Created by launching on 13-10-29.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKStation.h"
#import "LKBus.h"

typedef enum {
    RealTimeModeStation,
    RealTimeModeBus
} RealTimeMode;

@interface BHRealTimeData : NSObject

// 站台名
@property (nonatomic, retain) NSString *st_name;

// 方式
@property (nonatomic, assign) RealTimeMode mode;

// 关联数据
@property (nonatomic, assign) id data;

@end
