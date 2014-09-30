//
//  BHTrendsModel.h
//  SmartBus
//
//  Created by launching on 13-11-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHTrendsModel : NSObject

/* ID */
@property (nonatomic, assign) NSInteger feedid;

/* 圈子ID */
@property (nonatomic, assign) NSInteger weibaId;

/* 圈子 */
@property (nonatomic, retain) NSString *weiba;

/* title */
@property (nonatomic, retain) NSString *title;

/* 内容 */
@property (nonatomic, retain) NSString *content;

/* 发布者信息 */
@property (nonatomic, retain) BHUserModel *user;

/* 发布时间 */
@property (nonatomic, retain) NSString *ctime;

/* 经纬度 */
@property (nonatomic, assign) CLLocationCoordinate2D coor;

/* 地址 */
@property (nonatomic, retain) NSString *address;

/* 图片数组 */
@property (nonatomic, retain) NSMutableArray *images;

/* 评论个数 */
@property (nonatomic, assign) NSInteger cnum;

/* 被赞个数 */
@property (nonatomic, assign) NSInteger dnum;

/* 是否已赞 */
@property (nonatomic, assign) BOOL digg;

/* 是否为隐藏状态 */
@property (nonatomic, assign) BOOL hide;

/* 是否来源于个人中心 */
@property (nonatomic, assign) BOOL fromSelf;

- (void)addImage:(id)image;
- (id)imageAtIndex:(NSInteger)idx;
- (NSInteger)countOfImages;

- (CGFloat)getHeight;
- (CGFloat)getDescHeight;

@end
