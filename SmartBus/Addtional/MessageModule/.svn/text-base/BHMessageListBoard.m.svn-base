//
//  BHMessageListBoard.m
//  SmartBus
//
//  Created by 王 正星 on 13-12-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHMessageListBoard.h"
#import "BHMsgHelper.h"
#import "BHTalkBoard.h"


@interface BHMessageListBoard ()
{
    NSInteger _page;
    BHMsgHelper *_msgHelper;
    NSMutableArray *m_dataSource;
}
@property (nonatomic,retain) TPGestureTableViewCell *currentCell;
@end

@implementation BHMessageListBoard


- (void)load
{
    _msgHelper = [[BHMsgHelper alloc]init];
    [_msgHelper addObserver:self];
    m_dataSource = [[NSMutableArray alloc] initWithCapacity:5];
    _page = 1;
    [super load];
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
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_msg.png"] title:@"私信"];
        
        [self setEnableRefreshHeader:YES];
        [self setEnableLoadMoreFooter:YES];
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
		[self.egoTableView setFrame:self.beeView.bounds];
    }
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
        [self egoAllRequest];
	}
    else if ([signal is:BeeUIBoard.LOAD_DATAS])
    {
//        [_msgHelper getMessageListAtPage:_page];
    }
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    BHMessageListCell *cell = (BHMessageListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BHMessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    BHMsgModel *model = [m_dataSource objectAtIndex:indexPath.row];
    [cell setCellData:model withIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BHMsgModel *model = [m_dataSource objectAtIndex:indexPath.row];
    BHTalkBoard *vc = [BHTalkBoard board];
    vc.msgId = model.mstid;
    vc.targetUser = model.receiver;
    [self.stack pushBoard:vc animated:YES];
}

#pragma mark -
#pragma mark refresh / reload data source

- (void)refreshTableViewDataSource
{
    _page = 1;
    [_msgHelper getMessageListAtPage:_page];
}

- (void)loadTableViewDataSource
{
    ++ _page;
    [_msgHelper getMessageListAtPage:_page];
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
        if ( [request.userInfo is:@"getMessageList"] )
        {
            if (_page == 1) {
                [m_dataSource removeAllObjects];
            }
            [m_dataSource addObjectsFromArray:_msgHelper.nodes];
            
            [self reloadDataSucceed:YES];
        }
	}
	else if ( request.failed )
	{
        [self dismissTips];
	}
}

#pragma mark
#pragma mark TPGestureTableViewCellDelegate

- (void)cellDidBeginPan:(TPGestureTableViewCell *)cell
{
    
}

- (void)cellDidReveal:(TPGestureTableViewCell *)cell
{
    if(self.currentCell!=cell){
        self.currentCell.revealing=NO;
        self.currentCell=cell;
    }
}

- (void)deleteMsgWithIndex:(int)index
{
    BHMsgModel *model = [m_dataSource objectAtIndex:index];
    [_msgHelper removeMessage:model.mstid];
    [m_dataSource removeObjectAtIndex:index];
    [self reloadDataSucceed:YES];
}

@end
