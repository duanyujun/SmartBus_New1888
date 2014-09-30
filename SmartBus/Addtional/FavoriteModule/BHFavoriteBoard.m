//
//  BHFavoriteBoard.m
//  SmartBus
//
//  Created by launching on 13-10-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHFavoriteBoard.h"
#import "BHStationBoard.h"
#import "BHRouteBoard.h"
#import "BHFavoriteHelper.h"
#import "BHFavSectionInfo.h"
#import "BHFavHeaderView.h"
#import "BHFavStationCell.h"
#import "BHFavRouteCell.h"

@interface BHFavoriteBoard ()<UITableViewDelegate, UITableViewDataSource, BHBHFavHeaderDelegate, DAContextMenuCellDelegate>
{
    BeeUITableView *_tableView;
    BHFavoriteHelper *_favHelper;
    NSMutableArray *_sectionInfoArray;
    NSInteger _openSectionIndex;
    NSIndexPath *_indexPath;
}
- (void)reloadSectionInfoArray;
@end

@implementation BHFavoriteBoard

- (void)load
{
    _favHelper = [[BHFavoriteHelper alloc] init];
    [_favHelper addObserver:self];
    _sectionInfoArray = [[NSMutableArray alloc] initWithCapacity:0];
    _openSectionIndex = NSNotFound;
    [super load];
}

- (void)unload
{
    [_favHelper removeObserver:self];
    SAFE_RELEASE(_favHelper);
    SAFE_RELEASE(_sectionInfoArray);
    SAFE_RELEASE(_indexPath);
    [super unload];
}

- (void)handleMenu
{
    [_favHelper removeObserver:self];
    SAFE_RELEASE(_favHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_collect.png"] title:@"收藏"];
        
        _tableView = [[BeeUITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
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
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [_favHelper getFavorites];
	}
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
		[[BHAPP reveal] setAllowsReveal:NO];
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
        [[BHAPP reveal] setAllowsReveal:YES];
	}
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        if ( [request.userInfo is:@"getCollects"] )
        {
            [self presentLoadingTips:@"加载中..."];
        }
    }
    else if ( request.succeed )
	{
        [self dismissTips];
        
        if ( [request.userInfo is:@"getCollects"] )
        {
            [self reloadSectionInfoArray];
        }
		else if ( [request.userInfo is:@"removeStationCollect‍"] || [request.userInfo is:@"removeLineCollect"] )
        {
            if ( _favHelper.succeed )
            {
                BHFavSectionInfo *sectionInfo = _sectionInfoArray[_indexPath.section];
                [sectionInfo removeDataAtIndex:_indexPath.row];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
	}
    else if ( request.failed )
    {
        [self dismissTips];
    }
}


#pragma mark -
#pragma mark private methods

- (void)reloadSectionInfoArray
{
    for (int i = 0; i < _favHelper.favorites.count; i++)
    {
        BHFavSectionInfo *sectionInfo = [[BHFavSectionInfo alloc] init];
        [sectionInfo addDatas:_favHelper.favorites[i]];
        [_sectionInfoArray addObject:sectionInfo];
        [sectionInfo release];
    }
    
    [_tableView reloadData];
    
    // 默认打开第一个section
    [self performSelector:@selector(openFirstSection) withObject:nil afterDelay:0.2];
}

- (void)openFirstSection
{
    BHFavSectionInfo *sectionInfo = _sectionInfoArray[0];
    [sectionInfo.headerView toggleOpenWithUserAction:YES];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BHFavSectionInfo *sectionInfo = _sectionInfoArray[section];
    NSInteger numStoriesInSection = [[sectionInfo datas] count];
    return sectionInfo.expand ? numStoriesInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        static NSString *identifier = @"BHFavStationCell";
        BHFavStationCell *cell = (BHFavStationCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if ( !cell )
        {
            cell = [[[BHFavStationCell alloc] initWithReuseIdentifier:identifier] autorelease];
            [cell setDelegate:self];
        }
        
        BHFavSectionInfo *sectionInfo = _sectionInfoArray[indexPath.section];
        BHFavoriteModel *favorite = [sectionInfo dataAtIndex:indexPath.row];
        [cell setStation:favorite.entity];
        
        BubbleVerticalAlignment valignment = BubbleVerticalAlignmentMiddle;
        if ( indexPath.row == sectionInfo.datas.count - 1 ) {
            valignment = BubbleVerticalAlignmentBottom;
        }
        [cell setVerticalAlignment:valignment];
        
        return cell;
    }
    else
    {
        static NSString *identifier = @"BHFavRouteCell";
        BHFavRouteCell *cell = (BHFavRouteCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if ( !cell )
        {
            cell = [[[BHFavRouteCell alloc] initWithReuseIdentifier:identifier] autorelease];
            [cell setDelegate:self];
        }
        
        BHFavSectionInfo *sectionInfo = _sectionInfoArray[indexPath.section];
        BHFavoriteModel *favorite = [sectionInfo dataAtIndex:indexPath.row];
        [cell setRoute:favorite.entity];
        
        BubbleVerticalAlignment valignment = BubbleVerticalAlignmentMiddle;
        if ( indexPath.row == sectionInfo.datas.count - 1 ) {
            valignment = BubbleVerticalAlignmentBottom;
        }
        [cell setVerticalAlignment:valignment];
        
        return cell;
    }
}


#pragma mark -
#pragma mark table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BHFavSectionInfo *sectionInfo = _sectionInfoArray[section];
    if ( !sectionInfo.headerView ) {
        sectionInfo.headerView = [[BHFavHeaderView alloc] initWithFrame:CGRectMake(10.f, 0.f, 300.f, 46.f) delegate:self];
    }
    
    sectionInfo.headerView.section = section;
    [sectionInfo.headerView setHeaderStyle:section];
    
    return sectionInfo.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.f;
}


#pragma mark -
#pragma mark BHBHFavHeaderDelegate

- (void)sectionHeaderView:(BHFavHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section
{
    BHFavSectionInfo *sectionInfo = _sectionInfoArray[section];
	sectionInfo.expand = YES;
    
    NSInteger countOfRowsToInsert = [sectionInfo.datas count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
//    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
//    NSInteger previousOpenSectionIndex = _openSectionIndex;
//    if (previousOpenSectionIndex != NSNotFound) {
//		BHFavSectionInfo *previousOpenSection = _sectionInfoArray[previousOpenSectionIndex];
//        previousOpenSection.expand = NO;
//        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
//        NSInteger countOfRowsToDelete = [previousOpenSection.datas count];
//        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
//            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
//        }
//    }
    
    // Style the animation so that there's a smooth flow in either direction.
//    UITableViewRowAnimation insertAnimation;
//    UITableViewRowAnimation deleteAnimation;
//    if (previousOpenSectionIndex == NSNotFound || section < previousOpenSectionIndex) {
//        insertAnimation = UITableViewRowAnimationTop;
//        deleteAnimation = UITableViewRowAnimationBottom;
//    } else {
//        insertAnimation = UITableViewRowAnimationBottom;
//        deleteAnimation = UITableViewRowAnimationTop;
//    }
    
    // Apply the updates.
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
//    [_tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [_tableView endUpdates];
    
    [_tableView reloadData];
    
    _openSectionIndex = section;
}

- (void)sectionHeaderView:(BHFavHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section
{
    BHFavSectionInfo *sectionInfo = _sectionInfoArray[section];
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
#pragma mark DAContextMenuCellDelegate

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    SAFE_RELEASE(_indexPath);
    _indexPath = [indexPath retain];
    
    BHFavSectionInfo *sectionInfo = [_sectionInfoArray objectAtIndex:indexPath.section];
    BHFavoriteModel *favorite = [sectionInfo dataAtIndex:indexPath.row];
    
    if ( favorite.type == FAVORITE_TYPE_STATION ) {
        [_favHelper removeStationCollect:favorite.favid];
    } else {
        [_favHelper removeLineCollect:favorite.favid];
    }
}

- (void)contextMenuCellDidSelectRow:(DAContextMenuCell *)cell
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    BHFavSectionInfo *sectionInfo = [_sectionInfoArray objectAtIndex:indexPath.section];
    BHFavoriteModel *favorite = [sectionInfo dataAtIndex:indexPath.row];
    
    BHSampleBoard *board = nil;
    if ( indexPath.section == 0 ) {
        board = [[BHStationBoard alloc] initWithDataSource:favorite.entity];
    } else {
        board = [[BHRouteBoard alloc] initWithRoute:favorite.entity];
    }
    
    [self.stack pushBoard:board animated:YES];
    [board release];
}


@end
