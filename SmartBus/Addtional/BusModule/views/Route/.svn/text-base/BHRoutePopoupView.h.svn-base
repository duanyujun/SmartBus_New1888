//
//  BHRoutePopoupView.h
//  SmartBus
//
//  Created by launching on 13-11-18.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BHRoutePopoupDelegate <NSObject>
- (void)routePopoupView:(UIView *)view didSelectAtIndex:(NSInteger)idx;
@end

@interface BHRoutePopoupView : UIView

AS_SINGLETON( BHRoutePopoupView );

@property (nonatomic, assign) id<BHRoutePopoupDelegate> delegate;

// 显示和隐藏
- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)hideWithAnimated:(BOOL)animated;

// 是否正在显示
- (BOOL)isShowing;

// 设置收藏状态
- (BOOL)isCollected;
- (void)setCollected:(BOOL)collected;

@end
