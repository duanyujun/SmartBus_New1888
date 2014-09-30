//
//  BHTalkBoard.m
//  SmartBus
//
//  Created by 王 正星 on 13-12-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTalkBoard.h"
#import "BHMsgLoadMoreHeader.h"
#import "BHInputBar.h"
#import "BHMsgHelper.h"
#import "BHTalkFromCell.h"
#import "BHTalkToCell.h"
#import "BHUserModel.h"

@interface BHTalkBoard ()<UITableViewDataSource, UITableViewDelegate, BHMsgLoadMoreHeaderDelegate, BHInputBarDelegate>
{
    BeeUITableView *_tableView;
    BHMsgLoadMoreHeader *_loadMoreHeader;
    NSInteger _page;
    BOOL _refreshing;
    BHMsgHelper *_msgHelper;
    NSMutableArray *m_dataSource;
}
- (void)reloadMessages;
- (void)doneReloadingTableView;
@end

@implementation BHTalkBoard

DEF_SIGNAL( REFRESH );

- (void)load
{
    [super load];
    _msgHelper = [[BHMsgHelper alloc]init];
    [_msgHelper addObserver:self];
    m_dataSource = [[NSMutableArray alloc]initWithCapacity:5];
    _page = 1;
}

- (void)unload
{
    [_msgHelper removeObserver:self];
    SAFE_RELEASE(_msgHelper);
    SAFE_RELEASE(m_dataSource);
    [super unload];
}

- (void)handleMenu
{
    [_msgHelper removeObserver:self];
    SAFE_RELEASE(_msgHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_msg.png"] title:self.targetUser.uname];
        
        self.beeView.backgroundColor = RGB(240, 240, 240);
        _tableView = [[BeeUITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, self.beeView.height - 56.f)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.beeView addSubview:_tableView];
        
        _loadMoreHeader = [[BHMsgLoadMoreHeader alloc] initWithFrame:CGRectMake(0.f, -_tableView.frame.size.height, _tableView.frame.size.width, _tableView.frame.size.height)];
        _loadMoreHeader.delegate = self;
        [_tableView addSubview:_loadMoreHeader];
        
        BeeUIButton *refreshButton = [BeeUIButton new];
        refreshButton.frame = CGRectMake(320.f-44.f, 0.f, 44.f, 44.f);
        refreshButton.backgroundColor = [UIColor clearColor];
        refreshButton.image = [UIImage imageNamed:@"icon_refresh.png"];
        [refreshButton addSignal:self.REFRESH forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:refreshButton];
        
        BHInputBar *inputBar = [[BHInputBar alloc] initWithFrame:CGRectMake(0.f, self.beeView.frame.size.height-kInputBarHeight, 320.f, kInputBarHeight) delegate:self];
        [self.beeView addSubview:inputBar];
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
        [self reloadMessages];
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.REFRESH] )
    {
        [self reloadMessages];
    }
}


#pragma mark -
#pragma mark private methods

- (void)reloadMessages
{
    _page = 1;
    [_msgHelper getMessageDetail:self.msgId toUserId:self.targetUser.uid atPage:_page];
}

- (void)doneReloadingTableView
{
    [_tableView reloadData];
    [self performSelector:@selector(doneRefreshingTableViewData) withObject:nil afterDelay:0];
}

- (BOOL)hasTime:(int)index
{
    BHMsgModel *model = [m_dataSource objectAtIndex:index];
    if (!index)
    {
        return YES;
    }
    else
    {
        BHMsgModel *forwoardModel = [m_dataSource objectAtIndex:index-1];
        if (model.dtime - forwoardModel.dtime > 60*5) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}


#pragma mark -
#pragma mark BHInputBarDelegate

- (void)inputBar:(BHInputBar *)inputBar keyBoardWillShow:(NSNotification *)notitication
{
    CGRect keyboardBounds;
    [[notitication.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view.superview convertRect:keyboardBounds toView:nil];
    
    [UIView animateWithDuration:0.3f animations:^{
        _tableView.height = self.beeView.height-56.f -keyboardBounds.size.height;
    }];
    
    if (_page == 1) {
        if ( m_dataSource.count > 0 )
        {
            NSInteger lastRow = m_dataSource.count - 1;
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

- (void)inputBar:(BHInputBar *)inputBar keyBoardWillHide:(NSNotification *)notitication
{
    CGRect keyboardBounds;
    [[notitication.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view.superview convertRect:keyboardBounds toView:nil];
    
    [UIView animateWithDuration:0.3f animations:^{
        _tableView.height = self.beeView.height-56.f;
    }];
}

- (void)inputBar:(BHInputBar *)inputBar sendMessage:(NSString *)message
{
    BHMsgModel *msg = [[BHMsgModel alloc] init];
    msg.sender.uid = [BHUserModel sharedInstance].uid;
    msg.sender.uname = [BHUserModel sharedInstance].uname;
    msg.sender.avator = [BHUserModel sharedInstance].avator;
    msg.receiver.uid = self.targetUser.uid;
    msg.receiver.uname = self.targetUser.uname;
    msg.receiver.avator = self.targetUser.avator;
    msg.dtime = [[NSDate date] timeIntervalSince1970];
    msg.content = message;
    [m_dataSource addObject:msg];
    [_msgHelper postMessage:msg];
    [msg release];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierTalkto = @"talkto";
    static NSString *identifierTalkfrom = @"talkfrom";
    
    BHMsgModel *model = [m_dataSource objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = nil;
    if (model.sender.uid != [BHUserModel sharedInstance].uid)
    {
        cell = (BHTalkFromCell *)[tableView dequeueReusableCellWithIdentifier:identifierTalkfrom];
        if (!cell) {
            cell = [[BHTalkFromCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierTalkfrom];
        }
        
        [(BHTalkFromCell *)cell setCellData:model hasTime:[self hasTime:indexPath.row]];
    }
    else
    {
        cell = (BHTalkToCell *)[tableView dequeueReusableCellWithIdentifier:identifierTalkto];
        if (!cell) {
            cell = [[BHTalkToCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierTalkto];
        }
        
        
        [(BHTalkToCell *)cell setCellData:model hasTime:[self hasTime:indexPath.row]];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHMsgModel *model = [m_dataSource objectAtIndex:indexPath.row];
    if ([self hasTime:indexPath.row]) {
        return model.msgContentHeight+10.f +20.f;
    }
    return model.msgContentHeight+10.f;
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        NSString *tips = [request.userInfo is:@"postMessage"] ? @"正在发送..." : @"加载中...";
        [self presentLoadingTips:tips];
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        
        if ( [request.userInfo is:@"getMessageDetail"] )
        {
            if (_page == 1) {
                [m_dataSource removeAllObjects];
            }
            
            for (int i = _msgHelper.nodes.count-1 ;i>=0 ; i--) {
                BHMsgModel *model = [_msgHelper.nodes objectAtIndex:i];
                [m_dataSource insertObject:model atIndex:0];
            }
            
            if ( _msgHelper.nodes.count == 0 ) {
                _loadMoreHeader.over = YES;
            } else {
                _loadMoreHeader.over = NO;
            }
            
            [self doneReloadingTableView];
            
            if ( _page == 1 && m_dataSource.count > 0 )
            {
                NSInteger lastRow = m_dataSource.count - 1;
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]
                                  atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
        else if ( [request.userInfo is:@"postMessage"] )
        {
            if ( _msgHelper.succeed )
            {
                [self doneReloadingTableView];
                
                if ( m_dataSource.count > 0 )
                {
                    NSInteger lastRow = m_dataSource.count - 1;
                    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]
                                      atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
        }
	}
	else if ( request.failed )
	{
        [self dismissTips];
	}
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)refreshTableViewDataSource
{
	_refreshing = YES;
    ++ _page;
    [_msgHelper getMessageDetail:self.msgId toUserId:0 atPage:_page];
}

- (void)doneRefreshingTableViewData
{
	_refreshing = NO;
    [_loadMoreHeader egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_loadMoreHeader egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_loadMoreHeader egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [_loadMoreHeader egoRefreshScrollViewDidEndScrollAnimation:scrollView];
}


#pragma mark -
#pragma mark BHMsgLoadMoreHeaderDelegate Methods

- (void)msgLoadMoreDidTriggerRefresh:(BHMsgLoadMoreHeader *)view {
	[self refreshTableViewDataSource];
}

- (BOOL)msgLoadMoreDataSourceIsLoading:(BHMsgLoadMoreHeader *)view {
	return _refreshing; // should return if data source model is reloading
}

@end
