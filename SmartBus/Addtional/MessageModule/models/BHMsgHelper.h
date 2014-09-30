//
//  BHMsgHelper.h
//  SmartBus
//
//  Created by launching on 13-12-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_Model.h"
#import "BHMsgModel.h"

@interface BHMsgHelper : BeeModel

@property (nonatomic, assign) BOOL succeed;
@property (nonatomic, retain) NSMutableArray *nodes;
@property (nonatomic, assign) BOOL newnum;  // 新消息个数

// 获取我的私信列表
- (void)getMessageListAtPage:(NSInteger)page;

// 获取私信内容
- (void)getMessageDetail:(NSInteger)msgid toUserId:(NSInteger)uid atPage:(NSInteger)page;

// 发送私信
- (void)postMessage:(BHMsgModel *)msg;

// 删除私信
- (void)removeMessage:(NSInteger)msgid;

// 获取新消息个数
- (void)getNewMessage;

@end
