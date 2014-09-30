//
//  BHRouteBoard.h
//  SmartBus
//
//  Created by launching on 13-10-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSampleBoard.h"

@interface BHRouteBoard : BHSampleBoard

AS_SIGNAL( EXCHANGE );
AS_SIGNAL( REFRESH );
AS_SIGNAL( MORE );
AS_SIGNAL( COLLECT );
AS_SIGNAL( POINT_ERROR );

- (id)initWithRoute:(id)route;

@end
