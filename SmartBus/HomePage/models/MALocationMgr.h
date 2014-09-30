//
//  MALocationMgr.h
//  SmartBus
//
//  Created by launching on 13-12-5.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MALocationMgr : NSObject

AS_SINGLETON( MALocationMgr );

- (void)start;
- (void)pause;
- (void)stop;

@end
