//
//  BHGroupDescBoard.m
//  SmartBus
//
//  Created by launching on 13-12-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHGroupDescBoard.h"
#import "BHUserBoard.h"
#import "BHTrendsDescBoard.h"
#import "BHCommentBoard.h"
#import "BHPublishBoard.h"
#import "BHGroupHeader.h"
#import "BHGroupIntroCell.h"
#import "BHTrendsCell.h"
#import "BHUsersCell.h"
#import "BHTrendsHelper.h"
#import "BHGroupsHelper.h"
#import "XHImageViewer.h"

@interface BHGroupDescBoard ()<BHGroupHeaderDelegate, BHTrendsCellDelegate, BHUsersCellDelegate>
{
    BHGroupHeader *_header;
    BHGroupModel *_group;
    
    BHGroupsHelper *_groupsHelper;
    BHTrendsHelper *_trendsHelper;
    
    NSMutableArray *_elements;
    NSInteger _page;
    NSInteger _selectItemIndex;
    NSInteger _diggIndex;
}
@end

@implementation BHGroupDescBoard

DEF_NOTIFICATION( REMOVE_FOCUS );

- (void)load
{
    _groupsHelper = [[BHGroupsHelper alloc] init];
    [_groupsHelper addObserver:self];
    _trendsHelper = [[BHTrendsHelper alloc] init];
    [_trendsHelper addObserver:self];
    _elements = [[NSMutableArray alloc] initWithCapacity:0];
    [super load];
}

- (void)unload
{
    [_groupsHelper removeObserver:self];
    SAFE_RELEASE(_groupsHelper);
    [_trendsHelper removeObserver:self];
    SAFE_RELEASE(_trendsHelper);
    SAFE_RELEASE(_elements);
    SAFE_RELEASE(_group);
    [super unload];
}

- (void)handleMenu
{
    [_groupsHelper removeObserver:self];
    SAFE_RELEASE(_groupsHelper);
    [_trendsHelper removeObserver:self];
    SAFE_RELEASE(_trendsHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_group.png"] title:@"圈子详情"];
        
        [self setEnableRefreshHeader:NO];
        [self setEnableLoadMoreFooter:YES];
        
        _header = [[BHGroupHeader alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, kGroupHeader) delegate:self];
        [self.egoTableView addSubview:_header];
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        [self.egoTableView setFrame:self.beeView.bounds];
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [_groupsHelper getGroupDescById:self.gpid];
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        [self presentLoadingTips:@"加载中..."];
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        
        if ( [request.userInfo is:@"getGroupDesc"] )
        {
            SAFE_RELEASE(_group);
            _group = [[_groupsHelper.nodes objectAtIndex:0] retain];
            
            [_header reloadGroupData:_group];
            [_header toggleFoucs:_group.focused];
            [_header setSelectedIndex:1];
        }
        else if ( [request.userInfo is:@"getTrends"] || [request.userInfo is:@"getFollows"] )
        {
            if ( !_groupsHelper.succeed )
            {
                [self reloadDataSucceed:NO];
                return;
            }
            
            [_elements addObjectsFromArray:_groupsHelper.nodes];
            
            if ( _groupsHelper.nodes.count < kPageSize ) {
                self.isLoadingOver = YES;
            } else {
                self.isLoadingOver = NO;
            }
            
            [self reloadDataSucceed:YES];
        }
        else if ( [request.userInfo is:@"addDigg"] )
        {
            if ( _trendsHelper.succeed )
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_diggIndex inSection:1];
                BHTrendsCell *cell = (BHTrendsCell *)[self.egoTableView cellForRowAtIndexPath:indexPath];
                [cell addPraise:YES];
            }
        }
        else if ( [request.userInfo is:@"addFavToGroup"] )
        {
            if ( _groupsHelper.succeed )
            {
                [_header toggleFoucs:YES];
            }
        }
        else if ( [request.userInfo is:@"delFavToGroup"] )
        {
            if ( _groupsHelper.succeed )
            {
                [_header toggleFoucs:NO];
                [self postNotification:self.REMOVE_FOCUS];
            }
        }
	}
    else if ( request.failed )
    {
        [self dismissTips];
    }
}


#pragma mark -
#pragma mark BHGroupHeaderDelegate

- (void)groupHeaderDidCreatePosts:(BHGroupHeader *)header
{
    BHPublishBoard *board = [BHPublishBoard board];
    board.weibaId = self.gpid;
    [self.stack pushBoard:board animated:YES];
}

- (void)groupHeader:(BHGroupHeader *)header toggleFoucs:(BOOL)foucs
{
    [_groupsHelper toggleFav:!foucs toGroup:self.gpid];
}

- (void)groupHeader:(BHGroupHeader *)header didSelectAtIndex:(NSInteger)idx
{
    _selectItemIndex = idx;
    _page = 1;
    [_elements removeAllObjects];
    
    if ( idx == 0 )
    {
        [self reloadDataSucceed:YES];
        return;
    }
    
    if ( idx == 1 )
    {
        [_groupsHelper getTrendsById:self.gpid atPage:_page];
    }
    else
    {
        [_groupsHelper getFollowsById:self.gpid atPage:_page];
    }
}


#pragma mark -
#pragma mark BHUsersCellDelegate

- (void)usersCellDidSelectAvator:(BHUsersCell *)cell
{
    if ( cell.user.uid > 0 )
    {
        BHUserBoard *board = [BHUserBoard board];
        board.targetUserId = cell.user.uid;
        [self.stack pushBoard:board animated:YES];
    }
}


#pragma mark -
#pragma mark BHTrendsCellDelegate

- (void)trendsCell:(BHTrendsCell *)cell didSelectAtIndex:(NSInteger)idx
{
    BHTrendsModel *trends = _elements[idx];
    BHTrendsDescBoard *board = [[BHTrendsDescBoard alloc] initWithFeedId:trends.feedid];
    [self.stack pushBoard:board animated:YES];
    [board release];
}

- (void)trendsCellDidEnterComment:(BHTrendsCell *)cell
{
    NSIndexPath *indexPath = [self.egoTableView indexPathForCell:cell];
    BHTrendsModel *trends = _elements[indexPath.row];
    BHTrendsDescBoard *board = [[BHTrendsDescBoard alloc] initWithFeedId:trends.feedid];
    [self.stack pushBoard:board animated:YES];
    [board release];
    
//    BHCommentBoard *board = [[BHCommentBoard alloc] initWithFeedId:trends.feedid];
//    [self.stack pushBoard:board animated:YES];
//    [board release];
}

- (void)trendsCellDidStartPraise:(BHTrendsCell *)cell
{
    if ( !cell.trends.digg )
    {
        _diggIndex = cell.row;
        [_trendsHelper addPraise:cell.trends.feedid operatorId:[BHUserModel sharedInstance].uid];
    }
}

- (void)trendsCell:(BHTrendsCell *)cell didSelectImageView:(UIImageView *)view
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    [imageViewer showWithImageViews:[NSArray arrayWithObject:view] selectedView:view];
    [imageViewer release];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 1;
    } else {
        return _selectItemIndex == 0 ? 1 : _elements.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        static NSString *identifier = @"identifier0";
        BeeUITableViewCell *cell = (BeeUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if ( !cell )
        {
            cell = [[[BeeUITableViewCell alloc] initWithReuseIdentifier:identifier] autorelease];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        if ( _selectItemIndex == 0 )
        {
            static NSString *identifier = @"intro_identifier";
            BHGroupIntroCell *cell = (BHGroupIntroCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if ( !cell )
            {
                cell = [[[BHGroupIntroCell alloc] initWithReuseIdentifier:identifier] autorelease];
            }
            [cell setIntro:_group.intro andNotify:_group.notify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ( _selectItemIndex == 1 )
        {
            static NSString *identifier = @"trends_identifier";
            BHTrendsCell *cell = (BHTrendsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if ( !cell ) {
                cell = [[[BHTrendsCell alloc] initWithReuseIdentifier:identifier bSelf:YES] autorelease];
                cell.delegate = self;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTrends:_elements[indexPath.row]];
            [cell setRow:indexPath.row];
            return cell;
        }
        else if ( _selectItemIndex == 2 )
        {
            static NSString *identifier = @"fans_identifier";
            BHUsersCell *cell = (BHUsersCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if ( !cell ) {
                cell = [[[BHUsersCell alloc] initWithReuseIdentifier:identifier hideFocus:YES] autorelease];
                cell.delegate = self;
            }
            [cell setUser:_elements[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    return nil;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        return kGroupHeader + 5.f;
    }
    else
    {
        if ( _selectItemIndex == 0 )
        {
            return [_group getGroupIntroHeight] + 20;
        }
        else if ( _selectItemIndex == 1 )
        {
            BHTrendsModel *trends = _elements[indexPath.row];
            return [trends getHeight] + 5.f;
        }
        else
        {
            return kUsersCellHeight + 5.f;
        }
    }
    
    return 0.f;
}


#pragma mark -
#pragma mark ego table methods

- (void)loadTableViewDataSource
{
    ++ _page;
    
    if ( _selectItemIndex == 1 )
    {
        [_groupsHelper getTrendsById:self.gpid atPage:_page];
    }
    else
    {
        [_groupsHelper getFollowsById:self.gpid atPage:_page];
    }
}

@end
