//
//  BHAnnouceBoard.m
//  SmartBus
//
//  Created by user on 13-10-29.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAnnouceBoard.h"
#import "BHAnnDescBoard.h"
#import "BHAnnouceCell.h"
#import "BHAnnouceHelper.h"
#import "CacheDBHelper.h"
#import "BHNewsModel.h"

@interface BHAnnouceBoard ()
{
    BHAnnouceHelper *_annouceHelper;
}
- (BOOL)annouceIsRead;
@end

@implementation BHAnnouceBoard

- (void)load
{
    _annouceHelper = [[BHAnnouceHelper alloc] init];
    [_annouceHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_annouceHelper removeObserver:self];
    SAFE_RELEASE(_annouceHelper);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:YES image:[UIImage imageNamed:@"nav_notice.png"] title:@"公告"];
        [self setEnableRefreshHeader:YES];
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
		[self.egoTableView setFrame:self.beeView.bounds];
    }
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [self egoAllRequest];
	}
}

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        [self presentLoadingTips:@"加载中..."];
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        
        if ( [request.userInfo is:@"noticeList"] )
        {
            if ( [self annouceIsRead] )
            {
                [self reloadDataSucceed:YES];
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

- (BOOL)annouceIsRead
{
    NSArray *ids = [[CacheDBHelper sharedInstance] queryHistoriesAt:HISTORY_MODE_ANNOUCE];
    for (int i = 0; i < ids.count; i++)
    {
        NSInteger annid = [[ids objectAtIndex:i] intValue];
        for (int j = 0; j < _annouceHelper.nodes.count; j++)
        {
            BHAnnouceModel *ann = [_annouceHelper.nodes objectAtIndex:j];
            if ( ann.annid == annid )
            {
                ann.read = YES;
                [_annouceHelper.nodes replaceObjectAtIndex:j withObject:ann];
                continue;
            }
        }
    }
    
    return true;
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_annouceHelper.nodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    BHAnnouceCell *cell = (BHAnnouceCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[BHAnnouceCell alloc] initWithReuseIdentifier:identifier] autorelease];
    }
    cell.annouce = [_annouceHelper.nodes objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kAnnouceCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 插入已读记录
    BHAnnouceModel *annouce = [_annouceHelper.nodes objectAtIndex:indexPath.row];
    annouce.read = YES;
    [[CacheDBHelper sharedInstance] insertIntoHistories:annouce.annid at:HISTORY_MODE_ANNOUCE];
    
    // 设置Cell为已读
    BHAnnouceCell *cell = (BHAnnouceCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setAnnouce:annouce];
    
    BHAnnDescBoard *board = [[BHAnnDescBoard alloc] initWithAnnouce:annouce];
    [self.stack pushBoard:board animated:YES];
    [board release];
}


#pragma mark -
#pragma mark refresh / reload data source

- (void)refreshTableViewDataSource
{
    [_annouceHelper getNoticeList];
}

@end
