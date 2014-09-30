//
//  SBAnnotation.h
//  SmartBus
//
//  Created by launching on 14-4-23.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

typedef enum {
    SBAnnoModeNone = 0,
    SBAnnoModeStationIndicator,  // 站台标注
    SBAnnoModeUserIndicator,     // 用户标注
    SBAnnoModeRouteIndicator,    // 线路标注
    SBAnnoModeBusIndicator,      // 车辆标注
    SBAnnoModeFeetIndicator      // 足迹标注
} SBAnnoMode;

@interface SBAnnotation : MAPointAnnotation

@property (nonatomic, assign) SBAnnoMode mode;
@property (nonatomic, assign) NSInteger index;  // 记录TAG
@property (nonatomic, assign) BOOL canCallout;  // 是否可显示弹出框

@end
