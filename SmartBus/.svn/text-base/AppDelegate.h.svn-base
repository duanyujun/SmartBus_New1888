//
//  AppDelegate.h
//  SmartBus
//
//  Created by launching on 13-9-26.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"

@interface AppDelegate : BeeSkeleton

AS_NOTIFICATION( EXIST_NEW_VERSION )

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) PKRevealController *reveal;
@property (assign, nonatomic) NSTimeInterval timeIntervalWithServer;

// 最晚更新时间(时间戳)
@property (nonatomic, assign) double line_updated;
@property (nonatomic, assign) double st_updated;
@property (nonatomic, assign) double updown_updated;
@property (nonatomic, assign) double lst_updated;

- (BeeUIBoard *)boardAtIndex:(NSInteger)index;
- (void)toggleSlideMenu;

@end
