//
//  BHMsgModel.h
//  SmartBus
//
//  Created by launching on 13-12-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHMsgModel : NSObject

/* 私信列表ID */
@property (nonatomic, assign) NSInteger mstid;

/* 私信ID */
@property (nonatomic, assign) NSInteger msgid;

/* 发送者 */
@property (nonatomic, retain) BHUserModel *sender;

/* 接收者 */
@property (nonatomic, retain) BHUserModel *receiver;

/* 发送/接收时间 */
@property (nonatomic, assign) NSTimeInterval dtime;

/* 私信内容 */
@property (nonatomic, retain) NSString *content;

/* 新消息的个数 */
@property (nonatomic, assign) NSInteger newnum;

@property (nonatomic, assign) float msgContentWidth;

@property (nonatomic, assign) float msgContentHeight;

- (CGFloat)heightForMsgList;
- (CGFloat)heightForMessage;

@end
