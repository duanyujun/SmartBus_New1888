//
//  BHSectionModel.h
//  SmartBus
//
//  Created by launching on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHSectionModel : NSObject

// 帖子ID
@property (nonatomic, assign) NSInteger tid;

// 标题
@property (nonatomic, retain) NSString *subject;

// 内容
@property (nonatomic, retain) NSString *summary;

// 图片
@property (nonatomic, retain) NSString *cover;

// 微吧ID
@property (nonatomic, assign) NSInteger wid;

@end
