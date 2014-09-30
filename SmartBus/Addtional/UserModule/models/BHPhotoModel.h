//
//  BHPhotoModel.h
//  SmartBus
//
//  Created by launching on 13-11-13.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHPhotoModel : NSObject

/* 上传时间 */
@property (nonatomic, retain) NSString *dtime;

/* 图片URL列表 */
@property (nonatomic, retain) NSMutableArray *links;

- (CGFloat)getHeight;

@end
