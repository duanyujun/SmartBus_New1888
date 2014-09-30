//
//  BHTrendsBoard.h
//  SmartBus
//
//  Created by launching on 13-9-30.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "EGOTableBoard.h"

typedef enum {
    BHMovingModeHOT = 0,    // 最热动态
    BHMovingModeAttent,     // 关注动态
    BHMovingModeNew,        // 最新动态
    BHMovingModeStation,    // 本站圈子动态
    BHMovingModeRoute       // 线路圈子动态
} BHMovingMode;

@interface BHTrendsBoard : EGOTableBoard

AS_SIGNAL( MODE_SELECT );
AS_SIGNAL( SWITCH_GROUP );

@property (nonatomic, assign) NSInteger weiba;
@property (nonatomic, assign) BHMovingMode movingMode;  // 动态类型
@property (nonatomic, assign) BOOL leaf;

@end
