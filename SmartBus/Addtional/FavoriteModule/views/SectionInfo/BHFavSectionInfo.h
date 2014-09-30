//
//  BHFavSectionInfo.h
//  SmartBus
//
//  Created by launching on 13-10-15.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHFavHeaderView.h"
#import "LKStation.h"
#import "LKRoute.h"

@interface BHFavSectionInfo : NSObject

@property (nonatomic, assign) BOOL expand;
@property (nonatomic, retain) BHFavHeaderView *headerView;
@property (nonatomic, retain) NSMutableArray *datas;

- (void)addData:(id)data;
- (void)addDatas:(NSArray *)datas;
- (void)removeDataAtIndex:(NSInteger)idx;
- (id)dataAtIndex:(NSInteger)idx;
- (NSInteger)countOfDatas;

@end
