//
//  BHOnSiteModel.h
//  SmartBus
//
//  Created by launching on 13-11-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHAttachModel.h"

@interface BHOnSiteModel : NSObject

/* 爆料内容ID */
@property (nonatomic, assign) NSInteger disId;

/* 爆料人 */
@property (nonatomic, retain) NSString *author;

/* 标题 */
@property (nonatomic, retain) NSString *title;

/* 内容 */
@property (nonatomic, retain) NSString *remark;

/* 爆料时间 */
@property (nonatomic, retain) NSString *date;

/* 记者类型(0:公民记者 1:大学生记者 2:全媒体记者 3:部门编辑 4:通讯员) */
@property (nonatomic, assign) NSInteger level;

/* 用户组 */
@property (nonatomic, retain) NSString *ugroup;

/* 所在城市 */
@property (nonatomic, retain) NSString *ucity;

/* 附件列表 */
@property (nonatomic, retain) NSMutableArray *attachs;

- (void)addAttach:(id)attach;
- (id)attachAtIndex:(NSInteger)index;
- (NSInteger)countOfAttachs;

- (CGFloat)discloseTableCellHeight;

@end
