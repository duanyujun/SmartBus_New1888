//
//  BHProductModel.h
//  SmartBus
//
//  Created by launching on 13-12-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHProductModel : NSObject

/* 商品ID */
@property (nonatomic, assign) NSInteger prodid;

/* 商品名称 */
@property (nonatomic, retain) NSString *pname;

/* 商品的封面 */
@property (nonatomic, retain) NSString *pcover;

/* 商品浏览图片 */
@property (nonatomic, retain) NSMutableArray *photos;

/* 兑换银币数 */
@property (nonatomic, assign) NSInteger coin;

/* 单价 */
@property (nonatomic, assign) CGFloat price;

/* 描述 */
@property (nonatomic, retain) NSString *pdesc;

/* 剩余个数 */
@property (nonatomic, assign) NSInteger total;

@end
