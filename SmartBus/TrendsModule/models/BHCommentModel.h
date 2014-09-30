//
//  BHCommentModel.h
//  SmartBus
//
//  Created by launching on 13-11-12.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHUserModel.h"

@interface BHCommentModel : NSObject

/* 评论ID */
@property (nonatomic, assign) NSInteger cid;

/* 评论内容 */
@property (nonatomic, retain) NSString *content;

/* 评论时间 */
@property (nonatomic, retain) NSString *ctime;

/* 评论用户 */
@property (nonatomic, retain) BHUserModel *user;

@end
