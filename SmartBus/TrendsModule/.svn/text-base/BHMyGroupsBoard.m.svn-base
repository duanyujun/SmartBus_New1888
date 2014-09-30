//
//  BHMyGroupsBoard.m
//  SmartBus
//
//  Created by launching on 14-1-14.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHMyGroupsBoard.h"
#import "BHGroupsHelper.h"
#import "BHGroupCell.h"

@interface BHMyGroupsBoard ()
{
    NSMutableArray *_groups;
    BHGroupsHelper *_groupsHelper;
    NSInteger _page;
}
@end

@implementation BHMyGroupsBoard

DEF_NOTIFICATION( SELECT_GROUP );

- (void)load
{
    _groups = [[NSMutableArray alloc] initWithCapacity:0];
    _groupsHelper = [[BHGroupsHelper alloc] init];
    [_groupsHelper addObserver:self];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(_groups);
    [_groupsHelper removeObserver:self];
    SAFE_RELEASE(_groupsHelper);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_group.png"] title:@"我的圈子"];
        [self setEnableRefreshHeader:YES];
        [self setEnableLoadMoreFooter:YES];
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        [self.egoTableView setFrame:self.beeView.bounds];
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
        
        if ( [request.userInfo is:@"getMyGroups"] )
        {
            if ( _page == 1 )
            {
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
    return _groups.count;
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
    [cell setGroup:_groups[indexPath.row]];
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
    
    BHGroupModel *group = _groups[indexPath.row];
    [self postNotification:self.SELECT_GROUP withObject:group];
    
    [self.stack popBoardAnimated:YES];
}


#pragma mark -
#pragma mark refresh / reload data source

- (void)refreshTableViewDataSource
{
    _page = 1;
    [_groupsHelper getMyGroupsAtPage:_page];
}

- (void)loadTableViewDataSource
{
    _page ++;
    [_groupsHelper getMyGroupsAtPage:_page];
}

@end
