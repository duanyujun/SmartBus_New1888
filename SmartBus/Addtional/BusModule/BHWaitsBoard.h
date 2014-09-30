//
//  BHWaitsBoard.h
//  SmartBus
//
//  Created by launching on 13-10-29.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "EGOTableBoard.h"

@interface BHWaitsBoard : EGOTableBoard

AS_SIGNAL( MODE_SWITCH );

- (id)initWithStationID:(NSInteger)staid;

@end
