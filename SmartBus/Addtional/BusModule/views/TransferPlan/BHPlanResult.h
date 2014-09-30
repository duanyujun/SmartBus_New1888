//
//  BHPlanResult.h
//  SmartBus
//
//  Created by launching on 13-10-14.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHPlanModel.h"

@interface BHPlanResult : NSObject

/* 公交路线 */
@property (nonatomic, retain) NSMutableArray *lines;

/* 时长 */
@property (nonatomic, retain) NSString *time;

/* 总共步行距离 */
@property (nonatomic, assign) int distance;

/* 总共坐多少站 */
@property (nonatomic, assign) int number;

/* 方案(BHPlanModel数组) */
@property (nonatomic, retain) NSMutableArray *plans;

- (void)addPlan:(id)anObject;
- (void)insertPlan:(id)anObject atIndex:(int)idx;
- (id)planAtIndex:(int)idx;

@end
