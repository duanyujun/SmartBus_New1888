//
//  BHProductModel.m
//  SmartBus
//
//  Created by launching on 13-12-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHProductModel.h"

@implementation BHProductModel

@synthesize prodid, pname, pcover, photos, coin, price, pdesc, total;

- (void)dealloc
{
    SAFE_RELEASE(pname);
    SAFE_RELEASE(pcover);
    SAFE_RELEASE(photos);
    SAFE_RELEASE(pdesc);
    [super dealloc];
}

- (id)init
{
    if ( self = [super init] )
    {
        self.photos = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

@end
