//
//  BHFavSectionInfo.m
//  SmartBus
//
//  Created by launching on 13-10-15.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHFavSectionInfo.h"

@implementation BHFavSectionInfo

@synthesize expand, headerView;
@synthesize datas = _datas;

- (void)dealloc
{
    SAFE_RELEASE(headerView);
    SAFE_RELEASE(_datas);
    [super dealloc];
}

- (id)init {
	
	self = [super init];
	if (self) {
		self.datas = [NSMutableArray arrayWithCapacity:0];
	}
	return self;
}

- (void)addData:(id)data
{
    [self.datas addObject:data];
}

- (void)addDatas:(NSArray *)datas
{
    [self.datas addObjectsFromArray:datas];
}

- (void)removeDataAtIndex:(NSInteger)idx
{
    [self.datas removeObjectAtIndex:idx];
}

- (id)dataAtIndex:(NSInteger)idx;
{
    return [self.datas objectAtIndex:idx];
}

- (NSInteger)countOfDatas
{
    return [self.datas count];
}

@end
