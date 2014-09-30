//
//  BHTransPlanBoard.m
//  SmartBus
//
//  Created by launching on 13-10-14.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTransPlanBoard.h"
#import "BHPlanCell.h"
#import "BHPlanSectionInfo.h"

@interface BHTransPlanBoard ()<UITableViewDataSource, UITableViewDelegate, BHPlanHeaderDelegate>
{
    BeeUITableView *_tableView;
    NSMutableArray *_sectionInfoArray;
    NSInteger _openSectionIndex;
}
- (void)reloadTransitPlan:(AMapNavigationSearchResponse *)result;
@end

@implementation BHTransPlanBoard

- (void)unload
{
    SAFE_RELEASE(_sectionInfoArray);
    SAFE_RELEASE(_busRouteResult);
    SAFE_RELEASE_SUBVIEW(_tableView);
    [super unload];
}

- (id)initWithResult:(AMapNavigationSearchResponse *)result
{
    if ( self = [super init] )
    {
        _busRouteResult = [result retain];
        _sectionInfoArray = [[NSMutableArray alloc] initWithCapacity:0];
        _openSectionIndex = NSNotFound;
    }
    return self;
}


ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.title = @"换乘方案";
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_search.png"] title:self.title];
        
        _tableView = [[BeeUITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor flatWhiteColor];
		_tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.beeView addSubview:_tableView];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW(_tableView);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_tableView.frame = self.beeView.bounds;
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
        [self reloadTransitPlan:_busRouteResult];
	}
}


#pragma mark -
#pragma mark private methods

//  换乘方案路线分解
- (void)reloadTransitPlan:(AMapNavigationSearchResponse *)result
{
    for ( AMapTransit *bus in result.route.transits )
    {
        BHPlanSectionInfo *sectionInfo = [[BHPlanSectionInfo alloc] init];
        BHPlanResult *planResult = [[BHPlanResult alloc] init];
        planResult.distance = bus.walkingDistance;
        
        // 添加起点
        BHPlanModel *startPlan = [[BHPlanModel alloc] init];
        startPlan.rname = @"起点";
        [planResult addPlan:startPlan];
        [startPlan release];
        
        BOOL hasBusLine = NO;
        for ( int i = 0; i < bus.segments.count; i++ )
        {
            AMapSegment *segment = [bus.segments objectAtIndex:i];
            
            AMapWalking *walking = segment.walking;
            AMapBusLine *busline = segment.busline;
            NSLog(@"busLine -> %@",busline.busStops);
            
            if ( busline != nil )
            {
                if (!busline.busStops.count) {
                    continue;
                }
                BHPlanModel *busPlan = [[BHPlanModel alloc] init];
                busPlan.type = 2;
                busPlan.rname = busline.name;
                busPlan.snumber = busline.busStopsNum;
                busPlan.ename = [(AMapBusStop *)[busline.busStops objectAtIndex:busline.busStops.count - 1] name];
                [planResult addPlan:busPlan];
                [busPlan release];
                
                planResult.number += busline.busStopsNum;
                [planResult.lines addObject:busline.name];
                
                hasBusLine = YES;
            }
            else if ( walking != nil )
            {
                NSString *ename = (i == bus.segments.count - 1) ? @"终点站" : [(AMapStep *)[walking.steps lastObject] road];
                
                BHPlanModel *walkPlan = [[BHPlanModel alloc] init];
                walkPlan.type = 0;
                walkPlan.rname = ename;
                walkPlan.distance = walking.distance;
                [planResult addPlan:walkPlan];
                [walkPlan release];
            }
        }
        
        BHPlanModel *endPlan = [[BHPlanModel alloc] init];
        endPlan.rname = @"终点";
        [planResult addPlan:endPlan];
        [endPlan release];
        
        sectionInfo.result = planResult;
        [planResult release];
        if (hasBusLine) {
            [_sectionInfoArray addObject:sectionInfo];
        }
        [sectionInfo release];
    }
    
    [_tableView reloadData];
}


#pragma mark -
#pragma mark BHPlanHeaderDelegate

- (void)sectionHeaderView:(BHPlanHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section
{
    BHPlanSectionInfo *sectionInfo = _sectionInfoArray[section];
	sectionInfo.expand = YES;
    
    NSInteger countOfRowsToInsert = [sectionInfo.result.plans count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenSectionIndex = _openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		BHPlanSectionInfo *previousOpenSection = _sectionInfoArray[previousOpenSectionIndex];
        previousOpenSection.expand = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.result.plans count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || section < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [_tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [_tableView endUpdates];
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    _openSectionIndex = section;
}

- (void)sectionHeaderView:(BHPlanHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section
{
    BHPlanSectionInfo *sectionInfo = _sectionInfoArray[section];
    sectionInfo.expand = NO;
    
    NSInteger countOfRowsToDelete = [_tableView numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [_tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    _openSectionIndex = NSNotFound;
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BHPlanSectionInfo *sectionInfo = _sectionInfoArray[section];
    NSInteger numStoriesInSection = [[sectionInfo.result plans] count];
    return sectionInfo.expand ? numStoriesInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    BHPlanCell *cell = (BHPlanCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell )
    {
        cell = [[[BHPlanCell alloc] initWithReuseIdentifier:identifier] autorelease];
    }
    
    BHPlanSectionInfo *sectionInfo = _sectionInfoArray[indexPath.section];
    BHPlanModel *plan = [sectionInfo.result planAtIndex:indexPath.row];
    BOOL final = indexPath.row == sectionInfo.result.plans.count - 1;
    
    PlanStyle style;
    if ( indexPath.row == 0 ) {
        style = PlanStyleStart;
    } else if ( indexPath.row > 0 && final ) {
        style = PlanStyleEnd;
    } else {
        style = PlanStyleNormal;
    }
    
    [cell setFinal:final];
    [cell setPlan:plan style:style];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BHPlanSectionInfo *sectionInfo = _sectionInfoArray[section];
    if ( !sectionInfo.headerView ) {
        sectionInfo.headerView = [[BHPlanHeaderView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, kInitHeight) delegate:self];
    }
    
    sectionInfo.headerView.section = section;
    [sectionInfo.headerView setTitle:[NSString stringWithFormat:@"方案%d", section + 1]];
    [sectionInfo.headerView setPlanResult:sectionInfo.result];
    
    return sectionInfo.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kInitHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHPlanSectionInfo *sectionInfo = _sectionInfoArray[indexPath.section];
    if ( (indexPath.row == 0) || (indexPath.row > 0 && indexPath.row == sectionInfo.result.plans.count-1) ) {
        return kPotCellHeight;
    } else {
        return kPlanCellHeight;
    }
}

@end
