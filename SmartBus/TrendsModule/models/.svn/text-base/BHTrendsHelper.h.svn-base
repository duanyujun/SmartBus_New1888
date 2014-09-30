//
//  BHTrendsHelper.h
//  SmartBus
//
//  Created by launching on 13-10-8.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_Model.h"
#import "BHTrendsModel.h"

@interface BHTrendsHelper : BeeModel

@property (nonatomic, retain) NSMutableArray *nodes;
@property (nonatomic, assign) NSInteger postid;
@property (nonatomic, assign) BOOL succeed;

// 获取我的帖子列表
- (void)getUserPosts:(NSInteger)uid atPage:(NSInteger)page;

// 获取我关注的人的帖子列表
- (void)getFriendPosts:(NSInteger)mid atPage:(NSInteger)page;

// 热门动态列表
- (void)getHotContentsAtPage:(NSInteger)page;

// 最新动态列表
- (void)getNewContentsAtPage:(NSInteger)page;

// 获取站台/线路圈子
- (void)getWeibaList:(NSInteger)wid;

// 赞一下
- (void)addPraise:(NSInteger)fid operatorId:(NSInteger)oid;

// 获取帖子详情
- (void)getPostInfo:(NSInteger)pid shower:(NSInteger)mid;

// 发布帖子
- (void)publishPosts:(BHTrendsModel *)posts;

// 上传图片
- (void)uploadImages:(NSArray *)images withGroupId:(NSInteger)gid;

// 发评论
- (void)pushComment:(NSString *)comment inRowId:(NSInteger)rid atUser:(NSInteger)uid meid:(NSInteger)mid;

// 转发
- (void)relayComment:(NSString *)comment withTargetComment:(BHTrendsModel *)posts;

// 获取这个用户评论的列表
- (void)getUserComments:(NSInteger)uid atPage:(NSInteger)page;

// 获取这条微博的评论列表
- (void)getWeiboComments:(NSInteger)wid atPage:(NSInteger)page;

@end
