//
//  BHTrendsDescBoard.m
//  SmartBus
//
//  Created by launching on 13-12-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTrendsDescBoard.h"
#import "BHGroupDescBoard.h"
#import "BHUserBoard.h"
#import "BHTrendsDesCell.h"
#import "BHCommentCell.h"
#import "BHTrendsHelper.h"
#import "BHInputBar.h"
#import "BHTrendsRelayBoard.h"
#import "XHImageViewer.h"

@interface BHTrendsDescBoard ()<BHInputBarDelegate, BHTrendsDesCellDelegate>
{
    BHInputBar *_inputBar;
    
    BHTrendsHelper *_trendsHelper;
    NSInteger _feedId;
    NSInteger _page;
    NSMutableArray *_comments;
    BHTrendsModel *_trendsModel;
}
@end

@implementation BHTrendsDescBoard

- (id)initWithFeedId:(NSInteger)feedid
{
    if ( self = [super init] )
    {
        _feedId = feedid;
    }
    return self;
}

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

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_trends.png"] title:@"动态详情"];
        
        /*转发*/
        BeeUIButton *relayBtn = [[BeeUIButton alloc]initWithFrame:CGRectMake(280.f, 4.f, 36.f, 36.f)];
        [relayBtn setSignal:@"relay"];
        relayBtn.image = [UIImage imageNamed:@"icon_resend.png"];
        [self.navigationBar addSubview:relayBtn];
        [relayBtn release];
        
        _inputBar = [[BHInputBar alloc] initWithFrame:CGRectMake(0.f, self.beeView.frame.size.height-kInputBarHeight, 320.f, kInputBarHeight) delegate:self];
        [self.beeView addSubview:_inputBar];
        
        [self setEnableRefreshHeader:YES];
        [self setEnableLoadMoreFooter:YES];
        //[self.egoTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_inputBar);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
		[self.egoTableView setFrame:CGRectMake(0.f, 0.f, 320.f, self.beeView.frame.size.height-kInputBarHeight)];
    }
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [_trendsHelper getPostInfo:_feedId shower:[BHUserModel sharedInstance].uid];
	}
}

ON_SIGNAL2(BeeUIButton, signal)
{
    if ([signal is:@"relay"])
    {
        if ( [BHUserModel sharedInstance].uid <= 0 )
        {
            BHLoginBoard *board = [BHLoginBoard board];
            BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
            [self presentViewController:stack animated:YES completion:nil];
            return;
        }
        
        BHTrendsRelayBoard *vc = [BHTrendsRelayBoard board];
        vc.targetTrends = _trendsModel;
        [self.stack pushBoard:vc animated:YES];
    }
}

#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        NSString *tips = [request.userInfo is:@"weiboComments"] ? @"加载中..." : @"提交中...";
        [self presentLoadingTips:tips];
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        
        if ( [request.userInfo is:@"getPostInfo"] )
        {
            if ( _trendsHelper.succeed )
            {
                SAFE_RELEASE(_trendsModel);
                _trendsModel = [[_trendsHelper.nodes objectAtIndex:0] retain];
                [_trendsHelper getWeiboComments:_trendsModel.feedid atPage:_page];
            }
        }
        else if ( [request.userInfo is:@"weiboComments"] )
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
        else if ( [request.userInfo is:@"pushComment"] )
        {
            if ( _trendsHelper.succeed )
            {
                // 评论数加1
                _trendsModel.cnum ++;
                [self performSelector:@selector(egoAllRequest) withObject:nil afterDelay:0.5];
            }
        }
        else if ( [request.userInfo is:@"addDigg"] )
        {
            if ( _trendsHelper.succeed )
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                BHTrendsDesCell *cell = (BHTrendsDesCell *)[self.egoTableView cellForRowAtIndexPath:indexPath];
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
#pragma mark table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : _comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        static NSString *identifier = @"identifier0";
        BHTrendsDesCell *cell = (BHTrendsDesCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if ( !cell ) {
            cell = [[[BHTrendsDesCell alloc] initWithReuseIdentifier:identifier] autorelease];
        }
        [cell setTrends:_trendsModel];
        [cell setDelegate:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *identifier = @"identifier1";
        BHCommentCell *cell = (BHCommentCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if ( !cell ) {
            cell = [[[BHCommentCell alloc] initWithReuseIdentifier:identifier] autorelease];
        }
        [cell setComment:_comments[indexPath.row]];
        [cell setFinal:(indexPath.row == _comments.count - 1)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        return [_trendsModel getDescHeight] + (_comments.count > 0 ? 0.f : 10.f);
    }
    else
    {
        return kCommentCellHeight;
    }
}


#pragma mark -
#pragma mark refresh / reload data source

- (void)refreshTableViewDataSource
{
    _page = 1;
    [_trendsHelper getWeiboComments:_trendsModel.feedid atPage:_page];
}

- (void)loadTableViewDataSource
{
    ++ _page;
    [_trendsHelper getWeiboComments:_trendsModel.feedid atPage:_page];
}


#pragma mark -
#pragma mark BHInputBarDelegate

- (void)inputBar:(BHInputBar *)inputBar sendMessage:(NSString *)message
{
    [_trendsHelper pushComment:message
                       inRowId:_trendsModel.feedid
                        atUser:[BHUserModel sharedInstance].uid
                          meid:[BHUserModel sharedInstance].uid];
}


#pragma mark -
#pragma mark BHTrendsDesCellDelegate

- (void)trendsDesCell:(BHTrendsDesCell *)cell didSelectUser:(BHUserModel *)user
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

- (void)trendsDesCellDidEnterWeiba:(BHTrendsDesCell *)cell
{
    BHGroupDescBoard *board = [BHGroupDescBoard board];
    board.gpid = _trendsModel.weibaId;
    [self.stack pushBoard:board animated:YES];
}

- (void)trendsDesCellDidStartPraise:(BHTrendsDesCell *)cell
{
    if ( !cell.trends.digg )
    {
        [_trendsHelper addPraise:cell.trends.feedid operatorId:[BHUserModel sharedInstance].uid];
    }
}

- (void)trendsDesCell:(BHTrendsDesCell *)cell didSelectImageView:(UIImageView *)view
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    [imageViewer showWithImageViews:[NSArray arrayWithObject:view] selectedView:view];
    [imageViewer release];
}

@end
