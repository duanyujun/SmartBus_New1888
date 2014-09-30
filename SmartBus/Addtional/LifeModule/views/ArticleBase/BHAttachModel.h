//
//  BHAttachModel.h
//  SmartBus
//
//  Created by launching on 13-11-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHAttachModel : NSObject

/* 附件类型 */
@property (nonatomic, retain) NSString *category;

/* 附件图片的描述 */
@property (nonatomic, retain) NSString *summary;

/* 附件内容 */
@property (nonatomic, retain) NSString *text;

/* 附件图片 */
@property (nonatomic, retain) NSString *link;

/* 视频播放地址 */
@property (nonatomic, retain) NSString *play;

/* 图片大小 */
@property (nonatomic, assign) CGSize size;

@end
