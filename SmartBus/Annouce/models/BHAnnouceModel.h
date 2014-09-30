//
//  BHAnnouceModel.h
//  SmartBus
//
//  Created by user on 13-10-29.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHAnnouceModel : NSObject

/* 公告ID */
@property (nonatomic, assign) NSInteger annid;

/* 标题 */
@property (nonatomic, retain) NSString *title;

/* 内容 */
@property (nonatomic, retain) NSString *content;

/* 内容URL */
@property (nonatomic, retain) NSString *conurl;

/* 图片 */
@property (nonatomic, retain) NSString *conimg;

/* 发布时间 */
@property (nonatomic, assign) NSTimeInterval ctime;

/* 是否已读 */
@property (nonatomic, assign) BOOL read;

@end
