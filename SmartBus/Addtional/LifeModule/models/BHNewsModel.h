//
//  BHNewsModel.h
//  SmartBus
//
//  Created by launching on 13-11-20.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHNewsModel : NSObject

/* 新闻ID */
@property (nonatomic, assign) NSInteger nid;

/* 标题 */
@property (nonatomic, retain) NSString *title;

/* 简介 */
@property (nonatomic, retain) NSString *summary;

/* 封面 */
@property (nonatomic, retain) NSString *cover;

/* 发布时间 */
@property (nonatomic, retain) NSString *ctime;

@end
