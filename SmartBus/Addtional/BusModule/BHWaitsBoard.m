//
//  BHWaitsBoard.m
//  SmartBus
//
//  Created by launching on 13-10-29.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHWaitsBoard.h"
#import "BHUserBoard.h"
#import "BHWaitsCell.h"
#import "BHWaitsGirdCell.h"
#import "BHBusHelper.h"

@interface BHWaitsBoard ()<UITableViewDataSource, UITableViewDelegate>
{
    BHBusHelper *_busHelper;
    NSInteger _stationID;
}
- (void)pushUserBoard:(BHUserModel *)user;
@end

#define kMenuBtnTag  5717

@implementation BHWaitsBoard

DEF_SIGNAL( MODE_SWITCH );

- (id)initWithStationID:(NSInteger)staid
{
    if ( self = [super init] )
    {
        _stationID = staid;
    }
    return self;
}

- (void)load
{
    _busHelper = [[BHBusHelper alloc] init];
    [_busHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_busHelper removeObserver:self];
    SAFE_RELEASE(_busHelper);
    [super unload];
}

- (void)handleMenu
{
    [_busHelper removeObserver:self];
    SAFE_RELEASE(_busHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_station.png"] title:@"一起等车的人"];
        [self setEnableRefreshHeader:YES];
        
        BeeUIButton *displayButton = [BeeUIButton new];
        displayButton.frame = CGRectMake(320.f-44.f, 0.f, 44.f, 44.f);
        displayButton.backgroundColor = [UIColor clearColor];
        displayButton.tag = kMenuBtnTag;
        displayButton.stateNormal.image = [UIImage imageNamed:@"icon_gridmodel.png"];
        displayButton.stateSelected.image = [UIImage imageNamed:@"icon_listmodel.png"];
        [displayButton addSignal:self.MODE_SWITCH forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:displayButton];
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [self egoAllRequest];
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.MODE_SWITCH] )
    {
        BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kMenuBtnTag];
        button.selected = !button.selected;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3f ;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        [self.view.layer addAnimation:animation forKey:@"animation"];
        
        [self reloadDataSucceed:YES];
    }
}

- (void)pushUserBoard:(BHUserModel *)user
{
    if ( [BHUserModel sharedInstance].uid <= 0 )
    {
        BHLoginBoard *board = [BHLoginBoard board];
        BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
        [self presentViewController:stack animated:YES completion:nil];
        return;
    }
    
    if ( user.uid == 0 || user.uid == [BHUserModel sharedInstance].uid )
    {
        [self presentMessageTips:@"该用户没有注册"];
        return;
    }
    
    BHUserBoard *board = [BHUserBoard board];
    board.targetUserId = user.uid;
    [self.stack pushBoard:board animated:YES];
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
        [self reloadDataSucceed:YES];
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
    BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kMenuBtnTag];
    if ( button.selected )
    {
        return ceil((double)_busHelper.nodes.count / kNumberPerRow);
    }
    else
    {
        return _busHelper.nodes.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kMenuBtnTag];
    
    if ( button.selected )
    {
        static NSString *identifier = @"grid_identifier";
        BHWaitsGirdCell *cell = (BHWaitsGirdCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if ( !cell ) {
            cell = [[[BHWaitsGirdCell alloc] initWithReuseIdentifier:identifier] autorelease];
        }
        
        NSMutableArray *users = [NSMutableArray arrayWithCapacity:0];
        int startIndex = indexPath.row * kNumberPerRow;
        int endIndex = (startIndex + kNumberPerRow) > _busHelper.nodes.count ? _busHelper.nodes.count : (startIndex + kNumberPerRow);
        for (int i = startIndex; i < endIndex; i++) {
            [users addObject:_busHelper.nodes[i]];
        }
        [cell setUsers:users];
        [cell gridCellSelectionBlock:^(BHUserModel *user) {
            [self pushUserBoard:user];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *identifier = @"cell_identifier";
        BHWaitsCell *cell = (BHWaitsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if ( !cell ) {
            cell = [[[BHWaitsCell alloc] initWithReuseIdentifier:identifier] autorelease];
        }
        [cell setUser:[_busHelper.nodes objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kMenuBtnTag];
    return button.selected ? kWaitsGridHeight : kWaitsCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kMenuBtnTag];
    if ( button.selected ) return;
    
    BHUserModel *user = [_busHelper.nodes objectAtIndex:indexPath.row];
    [self pushUserBoard:user];
}


#pragma mark -
#pragma mark refresh / reload data source

- (void)refreshTableViewDataSource
{
    [_busHelper getWaitsForStation:_stationID];
}

@end
