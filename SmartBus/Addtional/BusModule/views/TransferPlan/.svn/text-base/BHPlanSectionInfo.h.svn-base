//
//  BHPlanSectionInfo.h
//  SmartBus
//
//  Created by launching on 13-10-15.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHPlanHeaderView.h"
#import "BHPlanResult.h"

@interface BHPlanSectionInfo : NSObject

@property (nonatomic, assign) BOOL expand;
@property (nonatomic, retain) BHPlanHeaderView *headerView;
@property (nonatomic, retain) BHPlanResult *result;

@property (nonatomic, retain) NSMutableArray *rowHeights;

- (NSUInteger)countOfRowHeights;
- (id)objectInRowHeightsAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx;
- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject;
- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes;
- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray;

@end
