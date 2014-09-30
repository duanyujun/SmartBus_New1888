//
//  BHUserModel.m
//  SmartBus
//
//  Created by launching on 13-9-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHUserModel.h"
#import "BHDefines.h"

@implementation BHUserModel

DEF_SINGLETON( BHUserModel )

@synthesize uid, uname, ugender, uphone, uemail, password, avator, birth, profession, signature, token, coordinate;
@synthesize score, bbsnum, fansnum, attnum, picnum, distance, focused;

- (void)dealloc
{
    SAFE_RELEASE(uname);
    SAFE_RELEASE(uphone);
    SAFE_RELEASE(uemail);
    SAFE_RELEASE(password);
    SAFE_RELEASE(avator);
    SAFE_RELEASE(birth);
    SAFE_RELEASE(profession);
    SAFE_RELEASE(signature);
    SAFE_RELEASE(token);
    SAFE_RELEASE(score);
    [super dealloc];
}


@end
