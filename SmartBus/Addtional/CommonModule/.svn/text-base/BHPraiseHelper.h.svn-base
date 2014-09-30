//
//  BHPraiseHelper.h
//  SmartBus
//
//  Created by user on 13-10-30.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_Model.h"

typedef void ((^PraiseCallBackBlock)) (NSString *status);

@interface BHPraiseHelper : BeeModel


@property (nonatomic, copy) PraiseCallBackBlock praiseCallBackBlock;

- (void) commintPraise:(NSString*)feedid andMid:(NSString *)mid withReturnCallBlock:(PraiseCallBackBlock)block;

@end
