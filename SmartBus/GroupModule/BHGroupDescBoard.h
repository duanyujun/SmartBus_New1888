//
//  BHGroupDescBoard.h
//  SmartBus
//
//  Created by launching on 13-12-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "EGOTableBoard.h"

@interface BHGroupDescBoard : EGOTableBoard

AS_NOTIFICATION( REMOVE_FOCUS );

@property (nonatomic, assign) NSInteger gpid;

@end
