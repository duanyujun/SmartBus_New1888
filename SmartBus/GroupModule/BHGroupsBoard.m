//
//  BHGroupsBoard.m
//  SmartBus
//
//  Created by launching on 13-12-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHGroupsBoard.h"
#import "BHGroupDescBoard.h"
#import "BHGroupCell.h"
#import "LCSegmentedControl.h"
#import "BHGroupsHelper.h"

@interface BHGroupsBoard ()<UISearchBarDelegate, UISearchDisplayDelegate>
{
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
    
    NSMutableArray *_groups;     // 圈子数组
    NSMutableArray *_results;    // 搜索记录
    NSInteger _page;
    BHGroupsHelper *_groupsHelper;
    GROUP_MODE _mode;
    
    BOOL isNeedRefresh;  // 是否需要刷新
    BOOL isSearchStatus;
    NSString *searchText;  // 搜索内容
}
@end


@implementation BHGroupsBoard

DEF_SIGNAL( GROUP_SELECT );

- (void)load
{
    _groups = [[NSMutableArray alloc] initWithCapacity:0];
    _results = [[NSMutableArray alloc] initWithCapacity:0];
    _groupsHelper = [[BHGroupsHelper alloc] init];
    [_groupsHelper addObserver:self];
    [self observeNotification:BHGroupDescBoard.REMOVE_FOCUS];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(_groups);
    SAFE_RELEASE(_results);
    [_groupsHelper removeObserver:self];
    SAFE_RELEASE(_groupsHelper);
    SAFE_RELEASE(searchText);
    [self unobserveAllNotifications];
    [super unload];
}

- (void)handleMenu
{
    [_groupsHelper removeObserver:self];
    SAFE_RELEASE(_groupsHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_group.png"] title:nil];
        
        [self setEnableRefreshHeader:YES];
        [self setEnableLoadMoreFooter:YES];
        
        NSArray *items = @[@{@"text":@"我的圈子"}, @{@"text":@"所有圈子"}];
        LCSegmentedControl *segmented = [[LCSegmentedControl alloc] initWithFrame:CGRectMake(70, 9, 180, 26) items:items];
        [segmented segmentDidSelectBlock:^(NSUInteger segmentIndex) {
            
            if ( segmentIndex == GROUP_MODE_SELF && [BHUserModel sharedInstance].uid == 0 ) {
                [self presentMessageTips:@"请登录"];
                [_groups removeAllObjects];
                [self reloadDataSucceed:YES];
                return;
            }
            
            _mode = segmentIndex;
            [self egoAllRequest];
        }];
        [self.navigationBar addSubview:segmented];
        [segmented release];
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
        _searchBar.tintColor = [UIColor whiteColor];
        _searchBar.placeholder = @"搜索圈子";
        _searchBar.delegate = self;
        [self.beeView addSubview:_searchBar];
        [_searchBar sizeToFit];
        self.egoTableView.tableHeaderView = _searchBar;
        
        _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
        self.searchDisplayController.searchResultsDelegate = self;
        self.searchDisplayController.searchResultsDataSource = self;
        self.searchDisplayController.delegate = self;
        self.searchDisplayController.searchResultsTableView.contentInset = UIEdgeInsetsZero;
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        SAFE_RELEASE_SUBVIEW(_searchBar);
    }
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        [self.egoTableView setFrame:self.beeView.bounds];
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
        if ( isNeedRefresh )
        {
            [self egoAllRequest];
        }
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [self egoAllRequest];
	}
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
        SAFE_RELEASE(_groups);
    }
}

ON_NOTIFICATION2( BHGroupDescBoard, notification )
{
    if ( [notification is:BHGroupDescBoard.REMOVE_FOCUS] )
    {
        isNeedRefresh = YES;
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
        
        if ( [request.userInfo is:@"getMyGroups"] || [request.userInfo is:@"getAllGroups"] )
        {
            if ( _page == 1 ) {
                [_groups removeAllObjects];
            }
            [_groups addObjectsFromArray:_groupsHelper.nodes];
            
            if ( _groupsHelper.nodes.count < kPageSize ) {
                self.isLoadingOver = YES;
            } else {
                self.isLoadingOver = NO;
            }
            
            [self reloadDataSucceed:YES];
        }
        else if ( [request.userInfo is:@"searchGroups"] )
        {
            if ( _page == 1 ) {
                [_results removeAllObjects];
            }
            [_results addObjectsFromArray:_groupsHelper.nodes];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
	}
    else if ( request.failed )
    {
        [self dismissTips];
    }
}


#pragma mark -
#pragma mark search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    isSearchStatus = YES;
    _page = 1;
    
    SAFE_RELEASE(searchText);
    searchText = [searchBar.text retain];
    
    [_groupsHelper searchGroupsInKeyword:searchBar.text atPage:_page];
}


#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self toggleChrome:YES];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    isSearchStatus = NO;
    [self toggleChrome:NO];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( [tableView isEqual:self.searchDisplayController.searchResultsTableView] )
    {
        return _results.count;
    }
    else
    {
        return _groups.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifer";
    BHGroupCell *cell = (BHGroupCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell )
    {
        cell = [[[BHGroupCell alloc] initWithReuseIdentifier:identifier] autorelease];
    }
    
    [cell setIndex:indexPath.row];
    
    if ( [tableView isEqual:self.searchDisplayController.searchResultsTableView] )
    {
        [cell setGroup:_results[indexPath.row]];
    }
    else
    {
        [cell setGroup:_groups[indexPath.row]];
    }
    
    return cell;
}


#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kGroupCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *objects = nil;
    if ( [tableView isEqual:self.searchDisplayController.searchResultsTableView] )
    {
        objects = [NSArray arrayWithArray:_results];
    }
    else
    {
        objects = [NSArray arrayWithArray:_groups];
    }
    BHGroupModel *group = [objects objectAtIndex:indexPath.row];
    BHGroupDescBoard *board = [BHGroupDescBoard board];
    board.gpid = group.gpid;
    [self.stack pushBoard:board animated:YES];
}


#pragma mark -
#pragma mark refresh / reload data source

- (void)refreshTableViewDataSource
{
    _page = 1;
    
    if ( _mode == GROUP_MODE_SELF )
    {
        [_groupsHelper getMyGroupsAtPage:_page];
    }
    else
    {
        [_groupsHelper getAllGroupsAtPage:_page];
    }
}

- (void)loadTableViewDataSource
{
    _page ++;
    
    if ( isSearchStatus )
    {
        [_groupsHelper searchGroupsInKeyword:searchText atPage:_page];
    }
    else
    {
        if ( _mode == GROUP_MODE_SELF )
        {
            [_groupsHelper getMyGroupsAtPage:_page];
        }
        else
        {
            [_groupsHelper getAllGroupsAtPage:_page];
        }
    }
}

@end
