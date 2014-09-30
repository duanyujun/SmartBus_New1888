//
//  BHCommentBoard.m
//  SmartBus
//
//  Created by launching on 13-11-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHCommentBoard.h"
#import "BHCommentCell.h"
#import "BHTrendsModel.h"
#import "BHTrendsHelper.h"

@interface BHCommentBoard ()
{
    BHTrendsHelper *_trendsHelper;
    NSInteger _page;
    NSMutableArray *_comments;
    NSInteger _feedId;
}
@end

@implementation BHCommentBoard

- (void)load
{
    _trendsHelper = [[BHTrendsHelper alloc] init];
    [_trendsHelper addObserver:self];
    _comments = [[NSMutableArray alloc] initWithCapacity:0];
    [super load];
}

- (void)unload
{
    [_trendsHelper removeObserver:self];
    SAFE_RELEASE(_trendsHelper);
    SAFE_RELEASE(_comments);
    [super unload];
}

- (void)handleMenu
{
    [_trendsHelper removeObserver:self];
    SAFE_RELEASE(_trendsHelper);
    [super handleMenu];
}

- (id)initWithFeedId:(NSInteger)fid
{
    if ( self = [super init] )
    {
        _feedId = fid;
    }
    return self;
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_trends.png"] title:@"评论"];
        [self setEnableRefreshHeader:YES];
        [self setEnableLoadMoreFooter:YES];
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
        [self egoAllRequest];
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
        
        if ( [request.userInfo is:@"weiboComments"] )
        {
            if ( _page == 1 ) {
                [_comments removeAllObjects];
            }
            [_comments addObjectsFromArray:_trendsHelper.nodes];
            
            if ( _trendsHelper.nodes.count < kPageSize ) {
                self.isLoadingOver = YES;
            } else {
                self.isLoadingOver = NO;
            }
            
            [self reloadDataSucceed:YES];
        }
	}
    else if ( request.failed )
    {
        [self dismissTips];
    }
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    BHCommentCell *cell = (BHCommentCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell ) {
        cell = [[[BHCommentCell alloc] initWithReuseIdentifier:identifier] autorelease];
    }
    [cell setComment:_comments[indexPath.row]];
    [cell setFinal:(indexPath.row == _comments.count - 1)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCommentCellHeight;
}


#pragma mark -
#pragma mark refresh / reload data source

- (void)refreshTableViewDataSource
{
    _page = 1;
    [_trendsHelper getWeiboComments:_feedId atPage:_page];
}

- (void)loadTableViewDataSource
{
    ++ _page;
    [_trendsHelper getWeiboComments:_feedId atPage:_page];
}

@end
