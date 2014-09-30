//
//  BHPlanModel.h
//  SmartBus
//
//  Created by launching on 13-10-14.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHPlanModel : NSObject

/* 换乘方式(0:步行 1:驾车 2:公交 3:地铁) */
@property (nonatomic, assign) int type;

/* 站台名或者线路名 */
@property (nonatomic, retain) NSString *rname;

/* 距离(type为1时有用) */
@property (nonatomic, assign) int distance;

/* 公交或者地铁多少站(type为2、3时可用) */
@property (nonatomic, assign) int snumber;

/* 下车站台名(type为2、3时可用) */
@property (nonatomic, retain) NSString *ename;

@end
