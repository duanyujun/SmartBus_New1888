//
//  BHUserBoard.m
//  SmartBus
//
//  Created by user on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHUserBoard.h"
#import "BHPrintsMapBoard.h"
#import "BHTrendsDescBoard.h"
#import "BHMessageListBoard.h"
#import "BHTalkBoard.h"
#import "BHCommentBoard.h"
#import "BHModifyUserBoard.h"
#import "XHImageViewer.h"
#import "BHProfileHeader.h"
#import "BHTrendsCell.h"
#import "BHPhotoCell.h"
#import "BHUsersCell.h"
#import "BHTrendsModel.h"
#import "BHUserHelper.h"
#import "BHTrendsHelper.h"
#import "UIImageView+WebCache.h"

@interface BHUserBoard ()<BHProfileDelegate, BHTrendsCellDelegate, BHPhotoCellDelegate, BHUsersCellDelegate>
{
    BHProfileHeader *_header;
    
    BHUserHelper *_userHelper;
    BHTrendsHelper *_trendsHelper;
    NSInteger _page;
    NSInteger _selectItemIndex;  // 已选择的ITEM
    NSInteger _diggIndex;        // 点击赞的INDEX
    NSMutableArray *_elements;
    BOOL _updated;  // 是否修改了用户资料
}
@end

#define kTrendsContainerTag  120121

@implementation BHUserBoard

DEF_SIGNAL( MAP_MODE );
DEF_SIGNAL( POP_ALL );

- (void)load
{
    _selectItemIndex = 0;
    _userHelper = [[BHUserHelper alloc] init];
    [_userHelper addObserver:self];
    _trendsHelper = [[BHTrendsHelper alloc] init];
    [_trendsHelper addObserver:self];
    _elements = [[NSMutableArray alloc] initWithCapacity:0];
    [self observeNotification:BHModifyUserBoard.HAVE_UPDATE];
    [super load];
}

- (void)unload
{
    [_userHelper removeObserver:self];
    SAFE_RELEASE(_userHelper);
    [_trendsHelper removeObserver:self];
    SAFE_RELEASE(_trendsHelper);
    SAFE_RELEASE(_elements);
    [self unobserveAllNotifications];
    [super unload];
}

- (void)handleMenu
{
    [_userHelper removeObserver:self];
    SAFE_RELEASE(_userHelper);
    [_trendsHelper removeObserver:self];
    SAFE_RELEASE(_trendsHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        BOOL root = (self.targetUserId == [BHUserModel sharedInstance].uid);
        NSString *title = root ? @"个人主页" : @"TA的主页";
        [self indicateIsFirstBoard:root image:[UIImage imageNamed:@"nav_profile.png"] title:title];
        
        _header = [[BHProfileHeader alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, kProfileHeaderHeight) delegate:self];
        [self.egoTableView addSubview:_header];
        
        BeeUIButton *menu = [BeeUIButton new];
        menu.frame = CGRectMake(280.f, 2.f, 40.f, 40.f);
        menu.image = [UIImage imageNamed:@"icon_foot.png"];
        [menu addSignal:self.MAP_MODE forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:menu];
        
        if ( !root )
        {
            BeeUIButton *selfButton = [BeeUIButton new];
            selfButton.frame = CGRectMake(240.f, 2.f, 40.f, 40.f);
            selfButton.image = [UIImage imageNamed:@"icon_me.png"];
            [selfButton addSignal:self.POP_ALL forControlEvents:UIControlEventTouchUpInside];
            [self.navigationBar addSubview:selfButton];
        }
        
        [self setEnableRefreshHeader:NO];
        [self setEnableLoadMoreFooter:YES];
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		self.egoTableView.frame = self.beeView.bounds;
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [_userHelper getUserInfo:self.targetUserId shower:[BHUserModel sharedInstance].uid];
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        if ( _updated )
        {
            [_userHelper getUserInfo:self.targetUserId shower:[BHUserModel sharedInstance].uid];
            _updated = NO;
        }
        
        [_header setSelectAtIndex:_selectItemIndex];
    }
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.MAP_MODE] )
    {
        BHPrintsMapBoard *board = [BHPrintsMapBoard board];
        [self.stack pushBoard:board animated:YES];
    }
    else if ( [signal is:self.POP_ALL] )
    {
        [self.stack popToFirstBoardAnimated:YES];
    }
}

ON_NOTIFICATION3( BHModifyUserBoard, HAVE_UPDATE, signal )
{
    _updated = YES;
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        if ( ![request.userInfo is:@"addDigg"] )
        {
            [self presentLoadingTips:@"加载中..."];
        }
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        
        if ( [request.userInfo is:@"getUserInfo"] )
        {
            [_header reloadUserData:_userHelper.user];
            [_header reloadNumbers:_userHelper.user];
            [_header setTargetUser:_userHelper.user.uid];
            [_header toggleFoucs:_userHelper.user.focused];
        }
        else if ( [request.userInfo is:@"getUserPosts"] ||
                [request.userInfo is:@"getUserAlbums"] ||
                [request.userInfo is:@"getFocus"] ||
                [request.userInfo is:@"getFans"] )
        {
            if ( _page == 1 ) {
                [_elements removeAllObjects];
            }
            
            if ( _selectItemIndex == 0 )
            {
                if ( !_trendsHelper.succeed ) {
                    [self reloadDataSucceed:NO];
                    return;
                }
                
                [_elements addObjectsFromArray:_trendsHelper.nodes];
                
                if ( _trendsHelper.nodes.count < kPageSize ) {
                    self.isLoadingOver = YES;
                } else {
                    self.isLoadingOver = NO;
                }
            }
            else
            {
                if ( !_userHelper.succeed ) {
                    [self reloadDataSucceed:NO];
                    return;
                }
                
                [_elements addObjectsFromArray:_userHelper.nodes];
                
                if ( _userHelper.nodes.count < kPageSize ) {
                    self.isLoadingOver = YES;
                } else {
                    self.isLoadingOver = NO;
                }
            }
            
            [self reloadDataSucceed:YES];
        }
        else if ( [request.userInfo is:@"addDigg"] )
        {
            if ( _trendsHelper.succeed )
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_diggIndex inSection:1];
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
#pragma mark BHProfileDelegate

- (void)profileHeaderDidSelectBackDrop:(UIView *)header
{
    //
}

- (void)profileHeaderDidSelectAvator:(UIView *)header
{
    BHModifyUserBoard *board = [[BHModifyUserBoard alloc] initWithUserId:self.targetUserId];
    [self.stack pushBoard:board animated:YES];
    [board release];
}

- (void)profileHeaderDidSelectSelfMessage:(UIView *)header
{
    BHMessageListBoard *board = [BHMessageListBoard board];
    [self.stack pushBoard:board animated:YES];
}

- (void)profileHeaderDidSendMessage:(UIView *)header
{
    BHTalkBoard *board = [BHTalkBoard board];
    board.targetUser = _userHelper.user;
    [self.stack pushBoard:board animated:YES];
}

- (void)profileHeader:(UIView *)header didToggleFoucs:(BOOL)foucs
{
    [_header toggleFoucs:!foucs];
    [_userHelper toggleFocus:!foucs to:self.targetUserId from:[BHUserModel sharedInstance].uid];
}

- (void)profileHeader:(UIView *)header didSelectAtIndex:(NSInteger)idx
{
    _selectItemIndex = idx;
    _page = 1;
    [_elements removeAllObjects];
    
    switch ( idx )
    {
        case 1:
            [_userHelper getUserAlbums:self.targetUserId shower:[BHUserModel sharedInstance].uid atPage:_page];
            break;
        case 2:
            [_userHelper getFocus:self.targetUserId shower:[BHUserModel sharedInstance].uid atPage:_page];
            break;
        case 3:
            [_userHelper getFans:self.targetUserId shower:[BHUserModel sharedInstance].uid atPage:_page];
            break;
        default:
            [_trendsHelper getUserPosts:self.targetUserId atPage:_page];
            break;
    }
}


#pragma mark -
#pragma mark BHUsersCellDelegate

- (void)usersCellDidSelectAvator:(BHUsersCell *)cell
{
    if ( cell.user.uid > 0 )
    {
        BHUserBoard *board = [BHUserBoard board];
        board.targetUserId = cell.user.uid;
        [self.stack pushBoard:board animated:YES];
    }
}

- (void)usersCell:(BHUsersCell *)cell toggleFocus:(BOOL)toggle
{
    NSIndexPath *indexPath = [self.egoTableView indexPathForCell:cell];
    BHUserModel *user = [_elements objectAtIndex:indexPath.row];
    [_userHelper toggleFocus:toggle to:user.uid from:[BHUserModel sharedInstance].uid];
    
    // 修改关注个数
    if ( _selectItemIndex == 2 )
    {
        NSInteger num = [_header numberAtIndex:_selectItemIndex];
        num = toggle ? ++num : --num;
        [_header setNumber:num atIndex:_selectItemIndex];
    }
    
    // 粉丝里添加关注
    if ( _selectItemIndex == 3 )
    {
        NSInteger num = [_header numberAtIndex:2];
        num = toggle ? ++num : --num;
        [_header setNumber:num atIndex:2];
    }
}


#pragma mark -
#pragma mark BHTrendsCellDelegate

- (void)trendsCell:(BHTrendsCell *)cell didSelectAtIndex:(NSInteger)idx
{
    BHTrendsModel *trends = _elements[idx];
    BHTrendsDescBoard *board = [[BHTrendsDescBoard alloc] initWithFeedId:trends.feedid];
    [self.stack pushBoard:board animated:YES];
    [board release];
}

- (void)trendsCellDidEnterComment:(BHTrendsCell *)cell
{
    NSIndexPath *indexPath = [self.egoTableView indexPathForCell:cell];
    BHTrendsModel *trends = _elements[indexPath.row];
    BHTrendsDescBoard *board = [[BHTrendsDescBoard alloc] initWithFeedId:trends.feedid];
    [self.stack pushBoard:board animated:YES];
    [board release];
    
//    BHCommentBoard *board = [[BHCommentBoard alloc] initWithFeedId:trends.feedid];
//    [self.stack pushBoard:board animated:YES];
//    [board release];
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
#pragma mark BHPhotoCellDelegate

- (void)photoCell:(BHPhotoCell *)cell didSelectWithView:(UIImageView *)view
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    [imageViewer showWithImageViews:cell.imageViews selectedView:view];
    [imageViewer release];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : _elements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        static NSString *identifier = @"identifier0";
        BeeUITableViewCell *cell = (BeeUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if ( !cell )
        {
            cell = [[[BeeUITableViewCell alloc] initWithReuseIdentifier:identifier] autorelease];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        if ( _selectItemIndex == 0 )
        {
            static NSString *identifier = @"trends_identifier";
            BHTrendsCell *cell = (BHTrendsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if ( !cell ) {
                cell = [[[BHTrendsCell alloc] initWithReuseIdentifier:identifier bSelf:NO] autorelease];
                cell.delegate = self;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTrends:_elements[indexPath.row]];
            [cell setRow:indexPath.row];
            return cell;
        }
        else if ( _selectItemIndex == 1 )
        {
            static NSString *identifier = @"photo_identifier";
            BHPhotoCell *cell = (BHPhotoCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if ( !cell ) {
                cell = [[[BHPhotoCell alloc] initWithReuseIdentifier:identifier] autorelease];
                cell.delegate = self;
            }
            [cell setPhoto:_elements[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            static NSString *identifier = @"fans_identifier";
            BHUsersCell *cell = (BHUsersCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if ( !cell ) {
                cell = [[[BHUsersCell alloc] initWithReuseIdentifier:identifier] autorelease];
                cell.delegate = self;
            }
            [cell setUser:_elements[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    return nil;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        return kProfileHeaderHeight + 5.f;
    }
    else
    {
        if ( _selectItemIndex == 0 ) {
            BHTrendsModel *trends = _elements[indexPath.row];
            return [trends getHeight] + 5.f;
        } else if ( _selectItemIndex == 1 ) {
            BHPhotoModel *photo = _elements[indexPath.row];
            return [photo getHeight] + 5.f;
        } else {
            return kUsersCellHeight + 5.f;
        }
    }
    
    return 0.f;
}


#pragma mark -
#pragma mark ego table methods

- (void)loadTableViewDataSource
{
    ++ _page;
    
    switch ( _selectItemIndex )
    {
        case 1:
            [_userHelper getUserAlbums:self.targetUserId shower:[BHUserModel sharedInstance].uid atPage:_page];
            break;
        case 2:
            [_userHelper getFocus:self.targetUserId shower:[BHUserModel sharedInstance].uid atPage:_page];
            break;
        case 3:
            [_userHelper getFans:self.targetUserId shower:[BHUserModel sharedInstance].uid atPage:_page];
            break;
        default:
            [_trendsHelper getUserPosts:self.targetUserId atPage:_page];
            break;
    }
}


@end
