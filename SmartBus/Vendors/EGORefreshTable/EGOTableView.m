//
//  EGOTableView.m
//  JstvNews
//
//  Created by kukuasir on 13-7-7.
//  Copyright (c) 2013年 kukuasir. All rights reserved.
//

#import "EGOTableView.h"

@implementation EGOTableView

@synthesize egoTableView = _egoTableView;
@synthesize enableRefreshHeader, enableLoadMoreFooter;
@synthesize isLoadingOver = _isLoadingOver;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _egoTableView = [[BeeUITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _egoTableView.backgroundColor = [UIColor clearColor];
        _egoTableView.dataSource = self;
        _egoTableView.delegate = self;
        [self addSubview:_egoTableView];
    }
    return self;
}


#pragma mark - public methods

- (void)setEnableRefreshHeader:(BOOL)enable
{
    enableRefreshHeader = enable;
    
    if (!_refreshHeaderView) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.f, 0.f - _egoTableView.bounds.size.height, _egoTableView.frame.size.width, _egoTableView.frame.size.height)];
        _refreshHeaderView.delegate = self;
    }
    [_egoTableView addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
    _refreshHeaderView.hidden = !enable;
}

- (void)setEnableLoadMoreFooter:(BOOL)enable
{
    enableLoadMoreFooter = enable;
    
    if (!_loadMoreFooterView) {
        _loadMoreFooterView = [[EGOLoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.f, _egoTableView.frame.size.height, _egoTableView.bounds.size.width, _egoTableView.bounds.size.height)];
        _loadMoreFooterView.delegate = self;
    }
    [_egoTableView addSubview:_loadMoreFooterView];
    _loadMoreFooterView.hidden = !enable;
}

- (void)egoAllRequest {
    self.isLoadingOver = NO;
    [_egoTableView setContentOffset:CGPointMake(0.f, -70.f) animated:YES];
}

- (void)reloadDataSucceed:(BOOL)succeed
{
    [self performSelector:@selector(doneRefreshingTableViewData) withObject:nil afterDelay:0];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
    
    if (succeed) {
        [_egoTableView reloadData];
    }
    
    if (_egoTableView.contentSize.height < _egoTableView.frame.size.height) {
        self.isLoadingOver = YES;
        return;
    }
    
    CGFloat y = MAX(_egoTableView.frame.size.height, _egoTableView.contentSize.height);
    CGRect rc = _loadMoreFooterView.frame;
    rc.origin.y = y;
    [_loadMoreFooterView setFrame:rc];
}

- (void)setIsLoadingOver:(BOOL)over {
    [_loadMoreFooterView setLoadOver:over];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    return cell;
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)refreshTableViewDataSource {
    [self setIsLoadingOver:NO];
	_refreshing = YES;
}

- (void)doneRefreshingTableViewData {
	_refreshing = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_egoTableView];
}

- (void)loadTableViewDataSource {
    _loading = YES;
}

- (void)doneLoadingTableViewData {
    _loading = NO;
    [_loadMoreFooterView egoLoadMoreScrollViewDataSourceDidFinishedLoading:_egoTableView];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_loadMoreFooterView egoLoadMoreScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_loadMoreFooterView egoLoadMoreScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [_refreshHeaderView egoRefreshScrollViewDidEndScrollAnimation:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
	[self refreshTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
	return _refreshing; // should return if data source model is reloading
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
	return [NSDate date]; // should return date data source was last changed
}

- (BOOL)enableEGORefreshTableHeaderView {
    return enableRefreshHeader;
}


#pragma mark -
#pragma mark EGOLoadMoreTableFooterDelegate Methods

- (void)egoLoadMoreTableFooterDidTriggerLoad:(EGOLoadMoreTableFooterView *)view {
	[self loadTableViewDataSource];
}

- (BOOL)egoLoadMoreTableFooterDataSourceIsLoading:(EGOLoadMoreTableFooterView *)view {
	return _loading;
}

- (BOOL)enableEGOLoadMoreTableFooterView {
    return enableLoadMoreFooter;
}


#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[_refreshHeaderView release], _refreshHeaderView = nil;
    [_loadMoreFooterView release], _loadMoreFooterView = nil;
    [_egoTableView release], _egoTableView = nil;
    [super dealloc];
}

@end
