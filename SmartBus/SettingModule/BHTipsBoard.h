//
//  BHTipsBoard.h
//  SmartBus
//
//  Created by launching on 14-1-10.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHSampleBoard.h"

typedef enum {
    TIPS_MODE_HELP,
    TIPS_MODE_EXPLAIN
} TIPS_MODE;

@interface BHTipsBoard : BHSampleBoard

@property (nonatomic, assign) TIPS_MODE tipsMode;

@end
