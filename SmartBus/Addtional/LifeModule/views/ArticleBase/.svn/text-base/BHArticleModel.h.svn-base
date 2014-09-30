//
//  BHArticleModel.h
//  SmartBus
//
//  Created by launching on 13-11-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHArticleBase.h"
#import "BHAttachModel.h"

@interface BHArticleModel : NSObject

/* 文章基本信息 */
@property (nonatomic, retain) BHArticleBase *base;

/* 附件列表 */
@property (nonatomic, retain) NSMutableArray *attachs;

- (void)addAttach:(id)attach;
- (id)attachAtIndex:(NSInteger)index;
- (NSInteger)countOfAttachs;

// 计算高度
- (CGFloat)heightOfSubject;
- (CGFloat)heightOfSummary;

@end
