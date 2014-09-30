//
//  BHPublishBoard.h
//  SmartBus
//
//  Created by launching on 13-10-31.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSampleBoard.h"

@interface BHPublishBoard : BHSampleBoard

@property (nonatomic, assign) NSInteger weibaId;

AS_SIGNAL( PUBLISH );
AS_SIGNAL( TOGGLE_PUBLIC );

@end
