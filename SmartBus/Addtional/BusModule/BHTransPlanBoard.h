//
//  BHTransPlanBoard.h
//  SmartBus
//
//  Created by launching on 13-10-14.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSampleBoard.h"
#import <AMapSearchKit/AMapSearchAPI.h>
@interface BHTransPlanBoard : BHSampleBoard
{
    AMapNavigationSearchResponse *_busRouteResult;
}

- (id)initWithResult:(AMapBusLineSearchResponse *)result;

@end
