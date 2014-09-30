//
//  LKAdditionInfo.h
//  SmartBus
//
//  Created by launching on 13-10-24.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHSectionModel.h"
#import "BHBannerModel.h"

@interface LKAdditionInfo : NSObject

// 一起等车的人
@property (nonatomic, assign) NSInteger wait;

// 收藏ID(如果未收藏为0)
@property (nonatomic, assign) int collect_id;

// 线路公告
@property (nonatomic, retain) NSString *notice;

// 广告(BHBannerModel)
@property (nonatomic, retain) NSMutableArray *banners;

// 圈子
@property (nonatomic, retain) BHSectionModel *section;

// LED广告
@property (nonatomic, retain) NSString *ledad;

- (void)addBanner:(id)banner;
- (id)bannerAtIndex:(NSInteger)idx;
- (void)removeAllBanners;

@end
