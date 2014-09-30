//
//  BHIDErrorBoard.h
//  SmartBus
//
//  Created by launching on 14-8-1.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "EGOTableBoard.h"

typedef enum {
    BHPointErrorStreet = 0,
    BHPointErrorSoftware = 1
} BHPointError;

typedef enum {
    BHPointModeRoute = 0,
    BHPointModeStation = 2
} BHPointMode;

@interface BHIDErrorBoard : EGOTableBoard

AS_SIGNAL( SUBMIT );

- (id)initWithError:(BHPointError)error mode:(BHPointMode)mode;

@end
