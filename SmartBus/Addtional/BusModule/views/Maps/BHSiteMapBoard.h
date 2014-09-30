//
//  BHSiteMapBoard.h
//  SmartBus
//
//  Created by launching on 13-10-31.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSampleBoard.h"

@class BHStationModel;

@interface BHSiteMapBoard : BHSampleBoard

AS_SIGNAL( TARGET )

@property (nonatomic, retain) BHStationModel *station;
@property (nonatomic, retain) NSArray *displays;

- (void)setDisplays:(NSArray *)displays;

@end
