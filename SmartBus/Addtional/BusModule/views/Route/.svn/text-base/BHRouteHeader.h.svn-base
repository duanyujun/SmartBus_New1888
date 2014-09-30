//
//  BHRouteHeader.h
//  SmartBus
//
//  Created by launching on 13-10-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_Model.h"
#import "LKRoute.h"

#define kRouteHeaderHeight  135.f

@protocol BHRouteHeaderDelegate <NSObject>
@optional
- (void)routeHeader:(UIView *)view didSelectWithAdv:(id)adv;
@end

@interface BHRouteHeader : BeeUIView

- (id)initWithFrame:(CGRect)frame delegate:(id<BHRouteHeaderDelegate>)delegate;

// 设置广告
- (void)setBanners:(NSArray *)banners;

// 设置状态
- (void)setStatus:(NSInteger)status text:(NSString *)text;

// 设置最近一班车和下一班车的数据
- (void)refreshData:(NSArray *)datas andCurrentLevel:(NSInteger)level;

@end
