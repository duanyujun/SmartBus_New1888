//
//  BHTrendsBoard.m
//  SmartBus
//
//  Created by launching on 13-9-30.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTrendsBoard.h"
#import "BHTrendsDescBoard.h"
#import "BHGroupsBoard.h"
#import "BHUserBoard.h"
#import "BHCommentBoard.h"
#import "BHTrendsCell.h"
#import "BHTrendsHelper.h"
#import "LCSegmentedControl.h"
#import "XHImageViewer.h"

@interface BHTrendsBoard ()<BHTrendsCellDelegate>
{
    NSInteger _page;
    NSMutableArray *_trends;
    BHTrendsHelper *_trendsHelper;
    NSInteger _diggIndex;
}
@end

@implementation BHTrendsBoard

DEF_SIGNAL( MODE_SELECT );
DEF_SIGNAL( SWITCH_GROUP );

@synthesize movingMode = _movingMode;

- (void)load
{
    _trendsHelper = [[BHTrendsHelper alloc] init];
    [_trendsHelper addObserver:self];
    _trends = [[NSMutableArray alloc] initWithCapacity:0];
    [super load];
}

- (void)unload
{
    [_trendsHelper removeObserver:self];
    SAFE_RELEASE(_trendsHelper);
    SAFE_RELEASE(_trends);
    [super unload];
}

- (void)handleMenu
{
    if ( self.leaf ) {
        [_trendsHelper removeObserver:self];
        SAFE_RELEASE(_trendsHelper);
    }
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:!self.leaf image:[UIImage imageNamed:@"nav_trends.png"] title:nil];
        
        if ( self.movingMode != BHMovingModeStation && self.movingMode != BHMovingModeRoute )
        {
            NSArray *items = @[@{@"text":@"热门"}, @{@"text":@"关注"}, @{@"text":@"最新"}];
            LCSegmentedControl *segmented = [[LCSegmentedControl alloc] initWithFrame:CGRectMake(70, 9, 180, 26) items:items];
            [segmented segmentDidSelectBlock:^(NSUInteger segmentIndex) {
                
                if ( segmentIndex == BHMovingModeAttent && [BHUserModel sharedInstance].uid == 0 ) {
                    [self presentMessageTips:@"请登录"];
                    [_trends removeAllObjects];
                    [self reloadDataSucceed:YES];
                    return;
                }
                
                self.movingMode = segmentIndex;
                [self egoAllRequest];
            }];
            [self.navigationBar addSubview:segmented];
            [segmented release];
            
            BeeUIButton *switchButton = [BeeUIButton new];
            switchButton.frame = CGRectMake(268.f, 10.f, 42.f, 24.f);
            switchButton.layer.masksToBounds = YES;
            switchButton.layer.cornerRadius = 3.f;
            switchButton.backgroundColor = RGB(240.f, 117.f, 75.f);
            switchButton.title = @"圈子";
            [switchButton addSignal:self.SWITCH_GROUP forControlEvents:UIControlEventTouchUpInside];
            [self.navigationBar addSubview:switchButton];
        }
        
        [self setEnableRefreshHeader:YES];
        [self setEnableLoadMoreFooter:YES];
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        [self.egoTableView setFrame:self.beeView.bounds];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        //
    }
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [self egoAllRequest];
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.SWITCH_GROUP] )
    {
        BHGroupsBoard *board = [BHGroupsBoard board];
        [self.stack pushBoard:board animated:YES];
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        if ( [request.userInfo is:@"getFriendPosts"] ||
            [request.userInfo is:@"getHotTrends"] ||
            [request.userInfo is:@"getNewTrends"] ||
            [request.userInfo is:@"bbslist"] )
        {
            [self presentLoadingTips:@"加载中..."];
        }
    }
	else if ( request.succeed )
	{
        if ( [request.userInfo is:@"getFriendPosts"] ||
            [request.userInfo is:@"getHotTrends"] ||
            [request.userInfo is:@"getNewTrends"] ||
            [request.userInfo is:@"bbslist"] )
        {
            [self dismissTips];
            
            if ( _page == 1 ) {
                [_trends removeAllObjects];
            }
            [_trends addObjectsFromArray:_trendsHelper.nodes];
            
            if ( _trendsHelper.nodes.count < kPageSize ) {
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
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_diggIndex inSection:0];
                BHTrendsCell *cell = (BHTrendsCell *)[self.egoTableView cellForRowAtIndexPath:indexPath];
                [cell addPraise:YES];
            }
        }
	}
    else if ( request.failed )
    {
        [self dismissTips];
    }
}


#pragma mark -
#pragma mark BHTrendsCellDelegate

- (void)trendsCell:(BHTrendsCell *)cell didSelectAtIndex:(NSInteger)idx
{
    BHTrendsModel *trends = _trends[idx];
    BHTrendsDescBoard *board = [[BHTrendsDescBoard alloc] initWithFeedId:trends.feedid];
    [self.stack pushBoard:board animated:YES];
    [board release];
}

- (void)trendsCell:(BHTrendsCell *)cell didSelectUser:(BHUserModel *)user
{
    if ( [BHUserModel sharedInstance].uid <= 0 )
    {
        BHLoginBoard *board = [BHLoginBoard board];
        BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
        [self presentViewController:stack animated:YES completion:nil];
        return;
    }
    
    BHUserBoard *board = [BHUserBoard board];
    board.targetUserId = user.uid;
    [self.stack pushBoard:board animated:YES];
}

- (void)trendsCellDidEnterComment:(BHTrendsCell *)cell
{
    NSIndexPath *indexPath = [self.egoTableView indexPathForCell:cell];
    BHTrendsModel *trends = _trends[indexPath.row];
    BHTrendsDescBoard *board = [[BHTrendsDescBoard alloc] initWithFeedId:trends.feedid];
    [self.stack pushBoard:board animated:YES];
    [board release];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _trends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifer";
    
    BHTrendsCell *cell = (BHTrendsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell ) {
        cell = [[[BHTrendsCell alloc] initWithReuseIdentifier:identifier bSelf:NO] autorelease];
        cell.delegate = self;
    }
    [cell setTrends:_trends[indexPath.row]];
    [cell setRow:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHTrendsModel *trends = _trends[indexPath.row];
    return [trends getHeight] + 6.f;
}


#pragma mark -
#pragma mark refresh / reload data source

- (void)refreshTableViewDataSource
{
    _page = 1;
    
    if ( self.movingMode == BHMovingModeHOT )
    {
        [_trendsHelper getHotContentsAtPage:_page];
    }
    else if ( self.movingMode == BHMovingModeAttent )
    {
        [_trendsHelper getFriendPosts:[BHUserModel sharedInstance].uid atPage:_page];
    }
    else if ( self.movingMode == BHMovingModeNew )
    {
        [_trendsHelper getNewContentsAtPage:_page];
    }
    else
    {
        [_trendsHelper getWeibaList:self.weiba];
    }
}

- (void)loadTableViewDataSource
{
    _page ++;
    
    if ( self.movingMode == BHMovingModeHOT )
    {
        [_trendsHelper getHotContentsAtPage:_page];
    }
    else if ( self.movingMode == BHMovingModeNew )
    {
        [_trendsHelper getNewContentsAtPage:_page];
    }
    else if ( self.movingMode == BHMovingModeAttent )
    {
        [_trendsHelper getFriendPosts:[BHUserModel sharedInstance].uid atPage:_page];
    }
    else
    {
        [_trendsHelper getWeibaList:self.weiba];
    }
}


@end
