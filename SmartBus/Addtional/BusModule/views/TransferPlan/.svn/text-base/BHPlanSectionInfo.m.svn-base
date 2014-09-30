//
//  BHPlanSectionInfo.m
//  SmartBus
//
//  Created by launching on 13-10-15.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPlanSectionInfo.h"

@implementation BHPlanSectionInfo

@synthesize expand, headerView, result;
@synthesize rowHeights = _rowHeights;

- (void)dealloc
{
    SAFE_RELEASE(headerView);
    SAFE_RELEASE(result);
    SAFE_RELEASE(_rowHeights);
    [super dealloc];
}

- (id)init {
	
	self = [super init];
	if (self) {
		_rowHeights = [[NSMutableArray alloc] init];
	}
	return self;
}


- (NSUInteger)countOfRowHeights {
	return [self.rowHeights count];
}

- (id)objectInRowHeightsAtIndex:(NSUInteger)idx {
	return self.rowHeights[idx];
}

- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx {
	[self.rowHeights insertObject:anObject atIndex:idx];
}

- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes {
	[self.rowHeights insertObjects:rowHeightArray atIndexes:indexes];
}

- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx {
	[self.rowHeights removeObjectAtIndex:idx];
}

- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes {
	[self.rowHeights removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject {
	self.rowHeights[idx] = anObject;
}

- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray {
	[self.rowHeights replaceObjectsAtIndexes:indexes withObjects:rowHeightArray];
}

@end
