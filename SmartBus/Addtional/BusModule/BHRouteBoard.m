//
//  BHRouteBoard.m
//  SmartBus
//
//  Created by launching on 13-10-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHRouteBoard.h"
#import "BHStationBoard.h"
#import "BHRouteMapBoard.h"
#import "BHAdvWebBoard.h"
#import "BHPublishBoard.h"
#import "BHGroupDescBoard.h"
#import "BHRouteDetail.h"
#import "BHRouteHeader.h"
#import "BHRouteFooter.h"
#import "BHStationTableCell.h"
#import "BHBusTableCell.h"
#import "BHSitesPopoupView.h"
#import "BHRoutePopoupView.h"
#import "BHRealTimeData.h"
#import "BHFavoriteHelper.h"
#import "BHAppHelper.h"
#import "BUSDBHelper.h"
#import "BHBusHelper.h"
#import "UILabelExt.h"
#import "BHErrorPicker.h"

@interface BHRouteBoard ()
<BHRoutePopoupDelegate, BHRouteHeaderDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
{
    UIWebView *_webView;
    BeeUITableView *_tableView;
    BHRouteFooter *_routeFooter;
    
    LKRoute *_route;
    NSInteger _index;
    NSMutableArray *_stationsInRoute;  // 线路经过的所有站台
    NSMutableArray *_routeDatas;       // 线路数据(包括站台信息和实时数据)
    NSMutableArray *_unoverBuses;      // 未经过的所有车辆
    BOOL _loadRouteSucceed;            // 加载线路信息成功标志
    BOOL _needScrolled;                // 是否需要滚动到当前站台行
    
    BHBusHelper *_busHelper;
    BHFavoriteHelper *_favHelper;
}
- (void)startGettingRealTimeDatas;
- (NSArray *)realTimeDatasByStations:(NSArray *)stations andBuses:(NSArray *)buses;
- (NSArray *)busesBySorted:(NSArray *)buses;
- (void)setCurrentLevelInRoute:(LKRoute *)route;  // 设置所在站台的LEVEL
- (NSArray *)getUnOverBuses:(NSArray *)buses;   // 获取未经过当前站台的所有车辆信息
- (void)reloadRealtimeData;
@end


#define kRouteHeaderTag    6821
#define kFavoirteBtnTag    6822
#define kDurationLabelTag  6823
#define kSubtitleLabelTag  6824


@implementation BHRouteBoard

DEF_SIGNAL( EXCHANGE );
DEF_SIGNAL( REFRESH );
DEF_SIGNAL( MORE );
DEF_SIGNAL( COLLECT );
DEF_SIGNAL( POINT_ERROR );

- (id)initWithRoute:(id)route
{
    if ( self = [super init] ) {
        _route = [(LKRoute *)route retain];
    }
    return self;
}

- (void)load
{
    _favHelper = [[BHFavoriteHelper alloc] init];
    [_favHelper addObserver:self];
    
    _busHelper = [[BHBusHelper alloc] init];
    [_busHelper addObserver:self];
    
    _stationsInRoute = [[NSMutableArray alloc] initWithCapacity:0];
    _routeDatas = [[NSMutableArray alloc] initWithCapacity:0];
    _unoverBuses = [[NSMutableArray alloc] initWithCapacity:0];
    _needScrolled = YES;
    [super load];
}

- (void)unload
{
    [_favHelper removeObserver:self];
    SAFE_RELEASE(_favHelper);
    [_busHelper removeObserver:self];
    SAFE_RELEASE(_busHelper);
    SAFE_RELEASE(_route);
    SAFE_RELEASE(_stationsInRoute);
    SAFE_RELEASE(_routeDatas);
    SAFE_RELEASE(_unoverBuses);
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
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_bus.png"] title:nil];
        
        if ( _route.line_ltd == 3 )
        {
            _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            _webView.backgroundColor = [UIColor clearColor];
            _webView.scrollView.showsVerticalScrollIndicator = NO;
            _webView.scrollView.contentInset = UIEdgeInsetsMake(IS_IOS7?-20.:0., 0., 0., 0.);
            _webView.scalesPageToFit = YES;
            _webView.delegate = self;
            [self.beeView addSubview:_webView];
        }
        else
        {
            _tableView = [[BeeUITableView alloc] initWithFrame:CGRectZero];
            _tableView.backgroundColor = [UIColor clearColor];
            _tableView.dataSource = self;
            _tableView.delegate = self;
            _tableView.showsVerticalScrollIndicator = NO;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.beeView addSubview:_tableView];
            
            [[BHRoutePopoupView sharedInstance] setDelegate:self];
        }
        
        CGRect rc = CGRectMake(0.f, self.beeView.frame.size.height-kRouteFooterHeight, 320.f, kRouteFooterHeight);
        _routeFooter = [[BHRouteFooter alloc] initWithFrame:rc];
        [_routeFooter addTarget:self action:@selector(footerAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.beeView addSubview:_routeFooter];
        
        [self addNavMenus];
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        CGRect rc = self.beeView.bounds;
        rc.size.height = self.beeView.bounds.size.height - kRouteFooterHeight;
        _webView.frame = rc;
        _tableView.frame = rc;
    }
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_webView);
        SAFE_RELEASE_SUBVIEW(_tableView);
        SAFE_RELEASE_SUBVIEW(_routeFooter);
	}
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        // 获取最新的线路动态
        [_busHelper getNewDynamic:_route.weiba_id inStation:0];
        
        // 取线路经过的站台数据
        [self loadStationsInRoute:_route];
        
        if ( _route.line_ltd == 3 )
        {
            [_busHelper getJNBusInfoByRoute:_route];
        }
        else
        {
            if ( !_route.st_appoint || ![self existCurrentStation:_route.st_appoint] )
            {
                // 默认为上行
                BHSitesPopoupView *popoup = [[BHSitesPopoupView alloc] initWithSites:_stationsInRoute];
                [popoup showInView:self.view completion:^(id site) {
                    if ( site )
                    {
                        // 设置当前站台
                        _route.st_appoint = site;
                        
                        // 获取线路信息
                        [_busHelper getLineInfo:_route.line_id updown:_route.ud_type station:_route.st_appoint.st_id];
                    }
                    else
                    {
                        [self.stack popBoardAnimated:YES];
                    }
                }];
            }
            else
            {
                // 设置当前站台的LEVEL
                [self setCurrentLevelInRoute:_route];
                
                // 获取线路信息
                [_busHelper getLineInfo:_route.line_id updown:_route.ud_type station:_route.st_appoint.st_id];
            }
        }
    }
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.EXCHANGE] )
    {
        _route.ud_type = !_route.ud_type;
        
        // 修改方向(重置线路信息并添加当前站台)
        LKRoute *route = [[BUSDBHelper sharedInstance] queryRouteByID:_route.line_id udType:_route.ud_type];
        route.st_appoint = _route.st_appoint;
        SAFE_RELEASE(_route);
        _route = [route retain];
        
        // 加载线路经过的站台数据
        [self loadStationsInRoute:_route];
        
        if ( _route.line_ltd == 3 )
        {
            [_busHelper getJNBusInfoByRoute:_route];
        }
        else
        {
            // 判断当前站台是否存在,若不存在,让用户选择
            if ( ![self existCurrentStation:_route.st_appoint] )
            {
                BHSitesPopoupView *popoup = [[BHSitesPopoupView alloc] initWithSites:_stationsInRoute];
                [popoup showInView:self.view completion:^(id site) {
                    if ( site )
                    {
                        // 设置当前站台
                        _route.st_appoint = site;
                        
                        // 获取线路信息
                        [_busHelper getLineInfo:_route.line_id updown:_route.ud_type station:_route.st_appoint.st_id];
                    }
                    else
                    {
                        [self.stack popBoardAnimated:YES];
                    }
                }];
            }
            else
            {
                // 设置当前站台
                [self setCurrentLevelInRoute:_route];
                
                // 获取实时数据
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                [self startGettingRealTimeDatas];
            }
        }
    }
    else if ( [signal is:self.REFRESH] )
    {
        _needScrolled = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self startGettingRealTimeDatas];
    }
    else if ( [signal is:self.MORE] )
    {
        if ( [[BHRoutePopoupView sharedInstance] isShowing] ) {
            [[BHRoutePopoupView sharedInstance] hideWithAnimated:YES];
        } else {
            [[BHRoutePopoupView sharedInstance] showInView:self.beeView animated:YES];
        }
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
            [_favHelper addLineCollect:_route.line_id updown:_route.ud_type stationId:_route.st_appoint.st_id];
        } else {
            [_favHelper removeLineCollect:_busHelper.addInfo.collect_id];
        }
    }
    else if ( [signal is:self.POINT_ERROR] )
    {
        NSArray *errors = @[@"路上无车, 软件显示有车", @"路上有车, 软件显示无车"];
        BHErrorPicker *picker = [[BHErrorPicker alloc] initWithErrors:errors];
        [picker show];
        [picker didSelectBlock:^(int idx) {
            BHIDErrorBoard *board = [[BHIDErrorBoard alloc] initWithError:idx mode:BHPointModeRoute];
            [self.stack pushBoard:board animated:YES];
            [board release];
        }];
        [picker release];
    }
}

- (void)footerAction:(id)sender
{
    NSString *summary = _busHelper.addInfo.section.summary;
    if ( !summary || summary.length == 0 )
    {
        BHPublishBoard *board = [BHPublishBoard board];
        board.weibaId = _route.weiba_id;
        [self.stack pushBoard:board animated:YES];
    }
    else
    {
        BHGroupDescBoard *board = [BHGroupDescBoard board];
        board.gpid = _route.weiba_id;
        [self.stack pushBoard:board animated:YES];
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        if ( [request.userInfo is:@"getRealtimeData"] ) {
            [self presentLoadingTips:@"正在刷新..."];
        }
    }
    else if ( request.succeed )
	{
        if ( [request.userInfo is:@"getNewWeibaInfo"] )
        {
            NSString *summary = _busHelper.addInfo.section.summary;
            if ( summary && summary.length > 0 ) {
                [_routeFooter setSummary:summary cover:_busHelper.addInfo.section.cover];
            }
        }
        else if ( [request.userInfo is:@"getLineInfo"] )
        {
            [[BHRoutePopoupView sharedInstance] setCollected:(_busHelper.addInfo.collect_id > 0)];
            BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kFavoirteBtnTag];
            button.selected = (_busHelper.addInfo.collect_id > 0);
            
            // 开始获取实时数据
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self startGettingRealTimeDatas];
        }
        else if ( [request.userInfo is:@"getRealtimeData"] )
        {
            // 按照level和距离排序
            NSArray *sortedBuses = [self busesBySorted:_busHelper.buses];
            
            [_unoverBuses removeAllObjects];
            [_unoverBuses addObjectsFromArray:[self getUnOverBuses:sortedBuses]];
            
            [_routeDatas removeAllObjects];
            [_routeDatas addObjectsFromArray:[self realTimeDatasByStations:_stationsInRoute andBuses:sortedBuses]];
            
            [self reloadRealtimeData];
            [self dismissTips];
            
            // 10s后重新获取
            [self performSelector:@selector(startGettingRealTimeDatas) withObject:nil afterDelay:10];
        }
        else if ( [request.userInfo is:@"getJiangNing"] )
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:_busHelper.jnURL];
            [_webView loadRequest:request];
        }
        else if ( [request.userInfo is:@"addLineCollect‍"] )
        {
            if ( _favHelper.succeed )
            {
                // 记录收藏ID
                _busHelper.addInfo.collect_id = _favHelper.collect_id;
                
                [[BHRoutePopoupView sharedInstance] setCollected:YES];
                
                BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kFavoirteBtnTag];
                button.selected = YES;
            }
        }
        else if ( [request.userInfo is:@"removeLineCollect"] )
        {
            if ( _favHelper.succeed )
            {
                [[BHRoutePopoupView sharedInstance] setCollected:NO];
                
                BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kFavoirteBtnTag];
                button.selected = NO;
            }
        }
	}
}


#pragma mark -
#pragma mark private methods

- (void)addNavMenus
{
    CGSize size = [_route.line_name sizeWithFont:FONT_SIZE(15) constrainedToSize:CGSizeMake(320.0, 44.0)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(48.f, 5.f, size.width, 20.f)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = FONT_SIZE(15);
    titleLabel.text = _route.line_name;
    [self.navigationBar addSubview:titleLabel];
    [titleLabel release];
    
    UILabelExt *durationLabel = [[UILabelExt alloc] initWithFrame:CGRectMake(54.f+size.width, 5.f, 200.f, 20.f)];
    durationLabel.backgroundColor = [UIColor clearColor];
    durationLabel.tag = kDurationLabelTag;
    durationLabel.font = FONT_SIZE(12);
    durationLabel.textColor = [UIColor lightGrayColor];
    [self.navigationBar addSubview:durationLabel];
    [durationLabel release];
    
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(48.f, 25.f, 200.f, 18.f)];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.tag = kSubtitleLabelTag;
    subtitleLabel.font = FONT_SIZE(12);
    subtitleLabel.textColor = [UIColor lightGrayColor];
    [self.navigationBar addSubview:subtitleLabel];
    [subtitleLabel release];
    
    BeeUIButton *exchangeButton = [BeeUIButton new];
    exchangeButton.frame = CGRectMake(320-40*(_route.line_ltd==3?1:3), 2.f, 40.f, 40.f);
    exchangeButton.image = [UIImage imageNamed:@"icon_exchange.png"];
    [exchangeButton addSignal:self.EXCHANGE forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:exchangeButton];
    
    if ( _route.line_ltd == 3 )
    {
//        BeeUIButton *collectButton = [BeeUIButton new];
//        collectButton.frame = CGRectMake(320-40, 2.f, 40.f, 40.f);
//        collectButton.tag = kFavoirteBtnTag;
//        collectButton.stateNormal.image = [UIImage imageNamed:@"icon_my_collection.png"];
//        collectButton.stateSelected.image = [UIImage imageNamed:@"icon_collectioned.png"];
//        [collectButton addSignal:self.COLLECT forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationBar addSubview:collectButton];
    }
    else
    {
        BeeUIButton *refreshButton = [BeeUIButton new];
        refreshButton.frame = CGRectMake(320-40*2, 2.f, 40.f, 40.f);
        refreshButton.image = [UIImage imageNamed:@"icon_refresh.png"];
        [refreshButton addSignal:self.REFRESH forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:refreshButton];
        
        BeeUIButton *moreButton = [BeeUIButton new];
        moreButton.frame = CGRectMake(320-40, 2.f, 40.f, 40.f);
        moreButton.image = [UIImage imageNamed:@"icon_more.png"];
        [moreButton addSignal:self.MORE forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:moreButton];
        
        BeeUIButton *pointButton = [BeeUIButton new];
        pointButton.frame = CGRectMake(260, 140, 60, 40);
        pointButton.backgroundColor = RGBA(0, 0, 0, 0.6);
        pointButton.title = @"有奖纠错";
        pointButton.titleFont = TTFONT_SIZED(12);
        [pointButton addSignal:self.POINT_ERROR forControlEvents:UIControlEventTouchUpInside];
        [self.beeView addSubview:pointButton];
    }
}

- (BOOL)existCurrentStation:(LKStation *)st_appoint
{
    BOOL ret = NO;
    for ( LKStation *station in _stationsInRoute ) {
        if ( [st_appoint.st_name is:station.st_name] ) {
            ret = YES;
            break;
        }
    }
    return ret;
}

- (void)loadStationsInRoute:(LKRoute *)route
{
    // 重置NavBar上下行数据
    UILabel *subtitleLabel = (UILabel *)[self.navigationBar viewWithTag:kSubtitleLabelTag];
    [subtitleLabel setText:[NSString stringWithFormat:@"%@-%@", route.st_start, route.st_end]];
    
    UILabel *durationLabel = (UILabel *)[self.navigationBar viewWithTag:kDurationLabelTag];
    if ( _route.start_time.length > 0 && _route.end_time.length > 0 ) {
        [durationLabel setText:[NSString stringWithFormat:@"(%@-%@)", _route.start_time, _route.end_time]];
    }
    
    if ( route.line_ltd != 3 )
    {
        // 加载线路经过的所有站台数据
        NSArray *stations = [[BUSDBHelper sharedInstance] queryStationsInRouteByRouteID:route.line_id andUDType:route.ud_type];
        [_stationsInRoute removeAllObjects];
        [_stationsInRoute addObjectsFromArray:stations];
        
        // 刷新数据
        [_tableView reloadData];
    }
}

- (void)setCurrentLevelInRoute:(LKRoute *)route
{
    int level_appo_sta = 0;
    
    for (int i = 0; i < _stationsInRoute.count; i++)
    {
        LKStation *station = _stationsInRoute[i];
        if ( [station.st_name is:route.st_appoint.st_name] )
        {
            level_appo_sta = station.st_level;
            break;
        }
    }
    
    [route.st_appoint setSt_level:level_appo_sta];
}

- (void)startGettingRealTimeDatas
{
    if ( _route.line_ltd == 3 ) {
        [_busHelper getJNBusInfoByRoute:_route];
    } else {
        [_busHelper getRealTimeDataByRouteId:_route.line_id andUDType:_route.ud_type];
    }
}

- (NSArray *)realTimeDatasByStations:(NSArray *)stations andBuses:(NSArray *)buses
{
    NSMutableArray *realTimeDatas = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < stations.count; i++)
    {
        BHRealTimeData *realtime = [[BHRealTimeData alloc] init];
        realtime.mode = RealTimeModeStation;
        realtime.data = [stations objectAtIndex:i];
        [realTimeDatas addObject:realtime];
        [realtime release];
    }
    
    for (int k = 0; k < buses.count; k++)
    {
        LKBus *bus = buses[k];
        for (int x = 0; x < realTimeDatas.count; x++)
        {
            BHRealTimeData *realtime = realTimeDatas[x];
            if ( realtime.mode == RealTimeModeStation )
            {
                LKStation *station = (LKStation *)realtime.data;
                
                if ( bus.st_level == station.st_level )
                {
                    BHRealTimeData *realtime = [[BHRealTimeData alloc] init];
                    realtime.mode = RealTimeModeBus;
                    realtime.st_name = station.st_name;
                    realtime.data = bus;
                    [realTimeDatas insertObject:realtime atIndex:x];
                    [realtime release];
                    
                    break;
                }
            }
        }
    }
    
    return realTimeDatas;
}

- (NSArray *)busesBySorted:(NSArray *)buses
{
    // 先按照按车辆的level进行排序,如果level相同在按照距离进行排序
    NSArray *sortedBuses = [buses sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        LKBus *bus1 = (LKBus *)obj1;
        LKBus *bus2 = (LKBus *)obj2;
        
        if ( bus1.st_level < bus2.st_level ) {
            return NSOrderedDescending;
        }
        
        if ( bus1.st_level > bus2.st_level ) {
            return NSOrderedAscending;
        }
        
        if ( bus1.st_level == bus2.st_level )
        {
            if ( bus1.st_dis < bus2.st_dis ) {
                return NSOrderedDescending;
            }
            
            if ( bus1.st_dis > bus2.st_dis ) {
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }
        return NSOrderedSame;
    }];
    
    return sortedBuses;
}

- (NSArray *)getUnOverBuses:(NSArray *)buses
{
    NSMutableArray *unovers = [NSMutableArray arrayWithCapacity:0];
    
    // 取level小于当前站台的所有车辆
    for ( LKBus *bus in buses )
    {
        if ( bus.st_level <= _route.st_appoint.st_level ) {
            [unovers addObject:bus];
        }
    }
    
    return unovers;
}

- (void)reloadRealtimeData
{
    [_tableView reloadData];
    
    if ( _routeDatas.count == 0 ) return;
    
    if ( _needScrolled )
    {
        NSInteger row = 0;
        for (int i = 0; i < _routeDatas.count; i++)
        {
            BHRealTimeData *realtime = _routeDatas[i];
            if ( realtime.mode == RealTimeModeStation)
            {
                LKStation *station = realtime.data;
                if ( station.st_level == _route.st_appoint.st_level )
                {
                    row = i;
                    break;
                }
            }
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        _needScrolled = NO;
    }
}


#pragma mark -
#pragma mark BHRoutePopoupDelegate

- (void)routePopoupView:(UIView *)view didSelectAtIndex:(NSInteger)idx
{
    if ( idx == 0 )
    {
        BHRouteDetail *board = [[BHRouteDetail alloc] initWithRoute:_route];
        [self.stack pushBoard:board animated:YES];
        [board release];
    }
    else if ( idx == 1 )
    {
        if ( [BHUserModel sharedInstance].uid == 0 )
        {
            [self presentMessageTips:@"请先登录"];
            return;
        }
        
        if ( ![[BHRoutePopoupView sharedInstance] isCollected] ) {
            [_favHelper addLineCollect:_route.line_id updown:_route.ud_type stationId:_route.st_appoint.st_id];
        } else {
            [_favHelper removeLineCollect:_busHelper.addInfo.collect_id];
        }
    }
    else
    {
        BHRouteMapBoard *board = [BHRouteMapBoard board];
        board.route = _route;
        [self.stack pushBoard:board animated:YES];
    }
}


#pragma mark -
#pragma mark BHRouteHeaderDelegate

- (void)routeHeader:(UIView *)view didSelectWithAdv:(id)adv
{
    BHBannerModel *banner = (BHBannerModel *)adv;
    
    [BHAppHelper submitAdvInfoById:banner.bid andType:4];
    
    BHAdvWebBoard *board = [BHAdvWebBoard board];
    board.urlString = banner.direct;
    [self.stack pushBoard:board animated:YES];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _routeDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHRealTimeData *realtime = [_routeDatas objectAtIndex:indexPath.row];
    
    if ( realtime.mode == RealTimeModeStation )
    {
        static NSString *identifier = @"station_identifier";
        BHStationTableCell *cell = (BHStationTableCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[BHStationTableCell alloc] initWithReuseIdentifier:identifier] autorelease];
        }
        [cell setStationModel:realtime.data currentLevel:_route.st_appoint.st_level];
        return cell;
    }
    else if ( realtime.mode == RealTimeModeBus )
    {
        static NSString *identifier = @"bus_identifier";
        BHBusTableCell *cell = (BHBusTableCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[BHBusTableCell alloc] initWithReuseIdentifier:identifier] autorelease];
        }
        [cell setRealTimeData:realtime];
        return cell;
    }
    
    return nil;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHRealTimeData *realtime = [_routeDatas objectAtIndex:indexPath.row];
    if ( realtime.mode == RealTimeModeBus ) {
        return kBusTableCellHeight;
    } else {
        return kStationTableCellHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BHRouteHeader *routeHeader = [[BHRouteHeader alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, kRouteHeaderHeight) delegate:self];
    [routeHeader refreshData:_unoverBuses andCurrentLevel:_route.st_appoint.st_level];
    [routeHeader setBanners:_busHelper.addInfo.banners];
    [routeHeader setStatus:0 text:nil];
    return [routeHeader autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kRouteHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BHRealTimeData *realtime = [_routeDatas objectAtIndex:indexPath.row];
    LKStation *station = realtime.data;
    if ( realtime.mode == RealTimeModeStation && (station.st_level != _route.st_appoint.st_level) )
    {
        BHStationBoard *board = [[BHStationBoard alloc] initWithDataSource:station];
        [self.stack pushBoard:board animated:YES];
        [board release];
    }
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self presentLoadingTips:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self dismissTips];
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=1.48"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeFormSubmitted)
    {
        NSURL *url = [request URL];
        NSString *specifier = [url resourceSpecifier];
        if ( [specifier rangeOfString:@"toDiss2"].location != NSNotFound ||   //选择当前站台操作
            [specifier rangeOfString:@"toSta"].location != NSNotFound ) {     //返回上一级操作
            return YES;
        }
        return NO;
    }
    return YES;
}

@end
