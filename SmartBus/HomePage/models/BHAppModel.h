//
//  BHAppModel.h
//  SmartBus
//
//  Created by launching on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHBannerModel.h"
#import "BHSectionModel.h"

@interface BHAppModel : NSObject

// 广告图片
@property (nonatomic, retain) NSMutableArray *banners;

// 热门动态
@property (nonatomic, retain) BHSectionModel *recommend;

// 南京生活
@property (nonatomic, retain) BHSectionModel *liveinfo;

- (void)addBanner:(id)banner;
- (id)bannerAtIndex:(NSInteger)index;

@end
