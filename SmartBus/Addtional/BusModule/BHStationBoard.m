//
//  BHStationBoard.m
//  SmartBus
//
//  Created by launching on 13-10-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHStationBoard.h"
#import "BHSiteMapBoard.h"
#import "BHRouteBoard.h"
//#import "BHLEDDescBoard.h"
#import "BHWaitsBoard.h"
#import "BHPublishBoard.h"
#import "BHAdvWebBoard.h"
#import "BHTrendsBoard.h"
#import "BHGroupDescBoard.h"
#import "QuadCurveMenu.h"
#import "BHAppSectionView.h"
#import "BHRouteSectionView.h"
#import "BHSelectionView.h"
#import "BHCellButton.h"
#import "UIButton+WebCache.h"
#import "BHScrollerView.h"
#import "BHErrorPicker.h"
#import "BUSDBHelper.h"
#import "BHBusHelper.h"
#import "BHFavoriteHelper.h"
#import "BHAppHelper.h"

@interface BHStationBoard ()<UITableViewDataSource, UITableViewDelegate, QuadCurveMenuDelegate, BHRouteSectionDelegate, BHScrollerDataSource, BHScrollerDelegate, BHAppSectionDelegate>
{
    BHScrollerView *_scroller;
    BHRouteSectionView *_routeSectionView;
    BHAppSectionView *_groupSectionView;
    BHCellButton *_button;
    
    LKStation *_station;
    
    BHBusHelper *_busHelper;
    BHFavoriteHelper *_favHelper;
}
- (void)addNavMenus;
- (void)addQuadCurveMenu;
@end

#define kLEDButtonTag     123455
#define kFavoirteBtnTag   123456

@implementation BHStationBoard

DEF_SIGNAL( REMIND_ERROR );
DEF_SIGNAL( LED_SELECT );
DEF_SIGNAL( COLLECT );
DEF_SIGNAL( MAP_MODE );

- (id)initWithDataSource:(id)dataSource
{
    if (self = [super init]) {
        _station = [(LKStation *)dataSource retain];
    }
    return self;
}

- (void)load
{
    _busHelper = [[BHBusHelper alloc] init];
    [_busHelper addObserver:self];
    
    _favHelper = [[BHFavoriteHelper alloc] init];
    [_favHelper addObserver:self];
    
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(_station);
    
    [_favHelper removeObserver:self];
    SAFE_RELEASE(_favHelper);
    
    [_busHelper removeObserver:self];
    SAFE_RELEASE(_busHelper);
    
    [super unload];
}

- (void)handleMenu
{
    [_favHelper removeObserver:self];
    SAFE_RELEASE(_favHelper);
    [_busHelper removeObserver:self];
    SAFE_RELEASE(_busHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.title = _station.st_name;
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_station.png"] title:self.title];
        
        self.egoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setEnableRefreshHeader:NO];
        
        [self addNavMenus];
        [self addQuadCurveMenu];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_scroller);
        SAFE_RELEASE_SUBVIEW(_routeSectionView);
        SAFE_RELEASE_SUBVIEW(_groupSectionView);
        SAFE_RELEASE_SUBVIEW(_button);
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        // 获取线路信息
        [_busHelper getStationInfo:_station.st_id];
        
        // 查询经过该站台所有线路
        if ( _station.st_routes.count == 0 ) {
            [_station.st_routes addObjectsFromArray:[[BUSDBHelper sharedInstance] queryRoutesByStationName:_station.st_name]];
        }
	}
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        // 获取站台最新动态
        [_busHelper getNewDynamic:_station.weiba_id inStation:_station.st_id];
    }
}

ON_SIGNAL2( BHCellButton, signal )
{
    BHWaitsBoard *board = [[BHWaitsBoard alloc] initWithStationID:_station.st_id];
    [self.stack pushBoard:board animated:YES];
    [board release];
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.REMIND_ERROR] )
    {
        NSArray *errors = @[@"路上有站台,软件显示位置不正确", @"路上有站台,软件显示无站台"];
        BHErrorPicker *picker = [[BHErrorPicker alloc] initWithErrors:errors];
        [picker show];
        [picker didSelectBlock:^(int idx) {
            BHIDErrorBoard *board = [[BHIDErrorBoard alloc] initWithError:idx mode:BHPointModeStation];
            [self.stack pushBoard:board animated:YES];
            [board release];
        }];
        [picker release];
    }
    else if ( [signal is:self.LED_SELECT] )
    {
//        BHLEDDescBoard *board = [[BHLEDDescBoard alloc] initWithStation:_station andAdv:_busHelper.sDesc.ledad];
//        [self.stack pushBoard:board animated:YES];
//        [board release];
    }
    else if ( [signal is:self.COLLECT] )
    {
        if ( [BHUserModel sharedInstance].uid == 0 )
        {
            [self presentMessageTips:@"请先登录"];
            return;
        }
        
        BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kFavoirteBtnTag];
        if ( !button.selected ) {
            [_favHelper addStationCollect:_station.st_id];
        } else {
            [_favHelper removeStationCollect:_busHelper.addInfo.collect_id];
        }
    }
    else if ( [signal is:self.MAP_MODE] )
    {
        BHSiteMapBoard *board = [[BHSiteMapBoard alloc] initWithSite:_station];
        [self.stack pushBoard:board animated:YES];
        [board release];
    }
}


#pragma mark -
#pragma mark private methods

- (void)addNavMenus
{
//    BeeUIButton *ledButton = [BeeUIButton new];
//    ledButton.frame = CGRectMake(320-40*3, 2.f, 40.f, 40.f);
//    ledButton.tag = kLEDButtonTag;
//    ledButton.stateNormal.image = [UIImage imageNamed:@"icon_led.png"];
//    [ledButton addSignal:self.LED_SELECT forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationBar addSubview:ledButton];
    
    BeeUIButton *errorButton = [BeeUIButton new];
    errorButton.frame = CGRectMake(320-40*2-54, 10, 54, 24);
    errorButton.tag = kLEDButtonTag;
    errorButton.backgroundColor = [UIColor redColor];
    errorButton.titleFont = TTFONT_SIZED(12);
    errorButton.titleColor = [UIColor whiteColor];
    errorButton.title = @"有奖报错";
    [errorButton addSignal:self.REMIND_ERROR forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:errorButton];
    
    BeeUIButton *collectButton = [BeeUIButton new];
    collectButton.frame = CGRectMake(320-40*2, 2.f, 40.f, 40.f);
    collectButton.tag = kFavoirteBtnTag;
    collectButton.stateNormal.image = [UIImage imageNamed:@"icon_my_collection.png"];
    collectButton.stateSelected.image = [UIImage imageNamed:@"icon_collectioned.png"];
    [collectButton addSignal:self.COLLECT forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:collectButton];
    
    BeeUIButton *mapButton = [BeeUIButton new];
    mapButton.frame = CGRectMake(320-40, 2.f, 40.f, 40.f);
    mapButton.image = [UIImage imageNamed:@"icon_map.png"];
    [mapButton addSignal:self.MAP_MODE forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:mapButton];
}

- (void)addQuadCurveMenu
{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    // Publish MenuItem.
    QuadCurveMenuItem *publishMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                 highlightedImage:storyMenuItemImagePressed
                                                                     ContentImage:[UIImage imageNamed:@"icon_write.png"]
                                                          highlightedContentImage:nil];
    // Sign MenuItem.
    QuadCurveMenuItem *signMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                              highlightedImage:storyMenuItemImagePressed
                                                                  ContentImage:[UIImage imageNamed:@"icon_sign.png"]
                                                       highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:publishMenuItem, signMenuItem, nil];
    [publishMenuItem release];
    [signMenuItem release];
    
    CGPoint pt = CGPointMake(30.f, self.beeView.bounds.size.height-30.f);
    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.beeView.bounds start:pt menus:menus];
    menu.delegate = self;
    [self.beeView addSubview:menu];
    [menu release];
}


#pragma mark -
#pragma mark quadcurve menu delegate

- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    if ( idx == 0 )
    {
        BHPublishBoard *board = [BHPublishBoard board];
        board.weibaId = _station.weiba_id;
        [self.stack pushBoard:board animated:YES];
    }
    else if ( idx == 1 )
    {
        [_busHelper checkInStation:_station.st_id];
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.succeed )
	{
        if ( [request.userInfo is:@"getStationInfo"] )
        {
            BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kFavoirteBtnTag];
            button.selected = _busHelper.addInfo.collect_id > 0;
            
            // 刷新广告和一起等车的人模块
            [self reloadDataSucceed:YES];
        }
        else if ( [request.userInfo is:@"getNewWeibaInfo"] )
        {
            // 刷新本站圈子模块
            [self reloadDataSucceed:YES];
        }
        else if ( [request.userInfo is:@"addStation‍Collect"] )
        {
            if ( _favHelper.succeed )
            {
                // 记录收藏ID
                _busHelper.addInfo.collect_id = _favHelper.collect_id;
                
                BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kFavoirteBtnTag];
                button.selected = YES;
            }
        }
        else if ( [request.userInfo is:@"removeStationCollect‍"] )
        {
            if ( _favHelper.succeed )
            {
                BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kFavoirteBtnTag];
                button.selected = NO;
            }
        }
	}
	else if ( request.failed )
	{
		//TODO:
	}
}


#pragma mark -
#pragma mark BHScrollerDataSource

- (UIImage *)backgroundImage
{
    return [UIImage imageNamed:@"bubble.png"];
}

- (NSInteger)numberOfImages
{
    return _busHelper.addInfo.banners.count;
}

- (UIView *)imageViewAtIndex:(NSInteger)index
{
    BHBannerModel *banner = _busHelper.addInfo.banners[index];
    
    BeeUIImageView *imageView = [[BeeUIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 310.f, 100.f)];
    imageView.backgroundColor = [UIColor flatBlueColor];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [imageView GET:banner.cover useCache:YES];
    return [imageView autorelease];
}


#pragma mark -
#pragma mark BHScrollerDelegate

- (void)photoView:(BHScrollerView *)photoView didSelectAtIndex:(NSInteger)index
{
    BHBannerModel *banner = _busHelper.addInfo.banners[index];
    
    [BHAppHelper submitAdvInfoById:banner.bid andType:3];
    
    BHAdvWebBoard *board = [BHAdvWebBoard board];
    board.urlString = banner.direct;
    [self.stack pushBoard:board animated:YES];
}


#pragma mark -
#pragma mark BHRouteSectionDelegate

- (void)routeSectionView:(UIView *)sectionView didSelectAtIndex:(NSInteger)index
{
    LKRoute *r = _station.st_routes[index];
    
    NSArray *routes = [[BUSDBHelper sharedInstance] queryRoutesByID:r.line_id];
    
    if ( routes.count > 1 )
    {
        BHSelectionView *selectionView = [[BHSelectionView alloc] initWithRoutes:routes];
        [selectionView show];
        [selectionView didSelectBlock:^(LKRoute *route) {
            route.st_appoint = _station;
            BHRouteBoard *borad = [[BHRouteBoard alloc] initWithRoute:route];
            [self.stack pushBoard:borad animated:YES];
            [borad release];
        }];
        [selectionView release];
    }
    else
    {
        r.st_appoint = _station;
        BHRouteBoard *board = [[BHRouteBoard alloc] initWithRoute:r];
        [self.stack pushBoard:board animated:YES];
        [board release];
    }
}


#pragma mark -
#pragma mark BHAppSectionDelegate

- (void)appSectionViewDidTapped:(UIView *)view
{
    if ( _busHelper.addInfo.section.summary.length == 0 )
    {
        BHPublishBoard *board = [BHPublishBoard board];
        board.weibaId = _station.weiba_id;
        [self.stack pushBoard:board animated:YES];
    }
    else
    {
        BHGroupDescBoard *board = [BHGroupDescBoard board];
        board.gpid = _station.weiba_id;
        [self.stack pushBoard:board animated:YES];
    }
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    BeeUITableViewCell *cell = (BeeUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell )
    {
        cell = [[[BeeUITableViewCell alloc] initWithReuseIdentifier:identifier] autorelease];
        
        if ( indexPath.section == 0 )
        {
            _scroller = [[BHScrollerView alloc] initWithFrame:CGRectMake(5.f, 5.f, 310.f, 100.f)];
            _scroller.layer.masksToBounds = YES;
            _scroller.layer.cornerRadius = 5.f;
            _scroller.dataSource = self;
            _scroller.delegate = self;
            [cell.contentView addSubview:_scroller];
        }
        else if ( indexPath.section == 1 )
        {
            _routeSectionView = [[BHRouteSectionView alloc] initWithPosition:CGPointMake(5.f, 5.f) delegate:self];
            [cell.contentView addSubview:_routeSectionView];
        }
        else if ( indexPath.section == 2 )
        {
            _button = [[BHCellButton alloc] initWithFrame:CGRectMake(5.f, 5.f, 310.f, 44.f) title:@"一起等车的人"];
            [_button addSignal:@"cellDidSelect" forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_button];
        }
        else
        {
            _groupSectionView = [[BHAppSectionView alloc] initWithPosition:CGPointMake(5.f, 5.f) delegate:self];
            _groupSectionView.tintColor = [UIColor flatRedColor];
            _groupSectionView.image = [UIImage imageNamed:@"icon_station.png"];
            _groupSectionView.title = @"本站圈子";
            [cell.contentView addSubview:_groupSectionView];
        }
    }
    
    if ( indexPath.section == 0 )
    {
        [_scroller reloadData];
    }
    else if ( indexPath.section == 1 )
    {
        [_routeSectionView setStationInfo:_station];
    }
    else if ( indexPath.section == 2 )
    {
        _button.number = _busHelper.addInfo.wait;
    }
    else
    {
        _groupSectionView.hideMore = YES;
        [_groupSectionView setStyle:AppStyleTrends dataSource:_busHelper.addInfo.section];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 0.f;
    switch ( indexPath.section ) {
        case 0:
            heightForRow = 105.f;
            break;
        case 1: {
            int count = _station.st_routes.count;
            heightForRow = count > 0 ? (35.f+16.f+ceil((float)count/5)*30.f) : (46.f+35.f);
        }
            break;
        case 2:
            heightForRow = 49.f;
            break;
        case 3:
            heightForRow = kSectionHeaderHeight + 20.f + 52.f + 5.f;
            break;
        default:
            break;
    }
    return heightForRow;
}

@end
