//
//  BHNewsHelper.h
//  SmartBus
//
//  Created by launching on 13-11-20.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_Model.h"
#import "BHMenuModel.h"
#import "BHNewsModel.h"
#import "BHOnSiteModel.h"
#import "BHArticleModel.h"

@interface BHNewsHelper : BeeModel

@property (nonatomic, retain) NSMutableArray *menus;   // 分类
@property (nonatomic, retain) NSMutableArray *tops;    // 大图
@property (nonatomic, retain) NSMutableArray *nodes;   // 新闻列表
@property (nonatomic, retain) BHArticleModel *article; // 新闻详情
@property (nonatomic, assign) BOOL succeed;

// 获取分类
- (void)getNewsCategory;

// 获取资讯大图
- (void)getNewsTops:(NSInteger)wid;

// 获取新闻列表
- (void)getNews:(NSInteger)wid atPage:(NSInteger)page;

// 获取在现场列表
- (void)getOnSitesAtPage:(NSInteger)page;

// 获取新闻详情
- (void)getNewsDetail:(NSInteger)nid;

// 获取在现场详情
- (void)getOnSiteDetail:(NSInteger)sid;

@end
