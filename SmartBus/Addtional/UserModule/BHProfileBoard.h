//
//  BHProfileBoard.h
//  SmartBus
//
//  Created by kukuasir on 13-11-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSampleBoard.h"

@interface BHProfileBoard : BHSampleBoard

AS_SIGNAL( SUBMIT );

- (id)initWithPhone:(NSString *)phone;

@end
