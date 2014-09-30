//
//  BHUserBoard.h
//  SmartBus
//
//  Created by user on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSampleBoard.h"
#import "EGOTableBoard.h"

@interface BHUserBoard : EGOTableBoard

AS_SIGNAL( MAP_MODE );
AS_SIGNAL( POP_ALL );

@property (nonatomic, assign) NSInteger targetUserId; // 目标用户ID

@end
