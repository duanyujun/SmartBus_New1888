//
//  BHSeekBoard.m
//  SmartBus
//
//  Created by launching on 13-10-8.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <AMapSearchKit/AMapSearchAPI.h>
#import "BHSeekBoard.h"
#import "BHStationBoard.h"
#import "BHRouteBoard.h"
#import "BHTransPlanBoard.h"
#import "BHArroundSitesMapBoard.h"
#import "BHResultPopView.h"
#import "BHSearchPopoups.h"
#import "BHSegmentedMenu.h"
#import "BHStationsTable.h"
#import "BHSearchBar.h"
#import "BHTransferBar.h"
#import "BUSDBHelper.h"
#import "MALocationHelper.h"

@interface BHSeekBoard ()<UITableViewDataSource, UITableViewDelegate, MALocationDelegate, BHSearchPopoupsDelegate, AMapSearchDelegate>
{
    BHSegmentedMenu *_menu;
    BHSearchBar *_searchBar;
    BHTransferBar *_transferBar;
    BeeUITableView *_tableView;
    BHStationsTable *_stationsTable;
    
    AMapSearchAPI *_search;
    NSMutableArray *_records;
}

@property (nonatomic, retain) NSArray *nearbyStations;
@property (nonatomic, retain) AMapPOI *startPoi;
@property (nonatomic, retain) AMapPOI *endPoi;
@property (nonatomic) BOOL startReady;
@property (nonatomic) BOOL endReady;

- (void)initBusRouteSearchOption;
- (void)searchPlace:(NSString *)from to:(NSString *)to;
- (void)getTransitRoutes;

@end

@implementation BHSeekBoard

@synthesize nearbyStations = _nearbyStations;
@synthesize startPoi, endPoi;
@synthesize startReady, endReady;

- (void)load
{
    _search = [[AMapSearchAPI alloc] initWithSearchKey:MASearchKey Delegate:self];
    _records = [[NSMutableArray alloc] initWithCapacity:0];
    [self initBusRouteSearchOption];
    [super load];
}

- (void)unload
{
    _search.delegate = nil;
    SAFE_RELEASE(_records);
    SAFE_RELEASE(_nearbyStations)
    SAFE_RELEASE(_search);
    SAFE_RELEASE(startPoi);
    SAFE_RELEASE(endPoi);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:!self.leaf image:[UIImage imageNamed:@"nav_search.png"] title:@"公交查询"];
        
        _menu = [[BHSegmentedMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
        _menu.backgroundColor = [UIColor flatGrayColor];
        _menu.font = BOLD_FONT_SIZE(16);
        _menu.textColor = [UIColor flatBlackColor];
        _menu.selectionIndicatorColor = [UIColor flatDarkRedColor];
        _menu.selectionIndicatorMode = HMSelectionIndicatorFillsSegment;
        _menu.sectionTitles = [NSArray arrayWithObjects:@"站台", @"线路", @"地点", @"换乘", nil];
        [_menu addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [self.beeView addSubview:_menu];
        
        _tableView = [BeeUITableView new];
        _tableView.backgroundColor = [UIColor clearColor];
		_tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.beeView addSubview:_tableView];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_menu);
        SAFE_RELEASE_SUBVIEW(_searchBar);
        SAFE_RELEASE_SUBVIEW(_tableView);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        CGRect rc = self.beeView.bounds;
        rc.origin.y = 44.f;
        rc.size.height = self.beeView.bounds.size.height - 44.f;
		_tableView.frame = rc;
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [self performSelector:@selector(loadNearbyStations) withObject:nil afterDelay:0];
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:@"search"] )
    {
        if ( _menu.selectedIndex == 2 )
        {
            [_searchBar setActive:NO];
            BHResultPopView *popView = [[BHResultPopView alloc] initWithTitle:@"选择地点..." key:[_searchBar content]];
            [popView showInView:self.view selected:^(AMapPOI *poi) {
                CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
                self.nearbyStations = [[BUSDBHelper sharedInstance] queryNearbyStations:coor];
                [_tableView reloadData];
            } completion:^(BOOL complete) {
                //TODO:
            }];
            [popView release];
        }
    }
    else if ( [signal is:@"item"] )
    {
        int idx = [(NSNumber *)signal.object intValue];
        LKStation *station = self.nearbyStations[idx];
        BHStationBoard *board = [[BHStationBoard alloc] initWithDataSource:station];
        [self.stack pushBoard:board animated:YES];
        [board release];
    }
    else if ( [signal is:@"transfer"] )
    {
        NSString *startfrom = _transferBar.startTextField.text;
        NSString *destination = _transferBar.endTextField.text;
        if ( !destination || destination.length == 0 )
        {
            [self presentMessageTips:@"请输入目的地"];
            return;
        }
        [_transferBar disActiveAllKeyboard];
        [self searchPlace:startfrom to:destination];
    }
    else if ( [signal is:BHStationsTable.MAP_MODE] )
    {
        BHArroundSitesMapBoard *board = [BHArroundSitesMapBoard board];
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL2( BeeUITextField, signal )
{
    if ( [signal is:BeeUITextField.WILL_ACTIVE] )
    {
        if (_menu.selectedIndex == 0 || _menu.selectedIndex == 1)
        {
            [_searchBar setActive:NO];
            
            NSString *placeholder = _menu.selectedIndex == 0 ? @"站点名称" : @"线路名称";
            BHSearchPopoups *searchPopoups = [[BHSearchPopoups alloc] initWithPlaceholder:placeholder delegate:self];
            searchPopoups.his_mode = _menu.selectedIndex;
            [searchPopoups showInView:self.beeView animated:YES];
            [searchPopoups release];
        }
    }
    else if ( [signal is:BeeUITextField.TEXT_CHANGED] )
    {
        if ( [signal.source isEqual:_transferBar.startTextField] )
        {
            self.startReady = NO;
        }
        
        if ( [signal.source isEqual:_transferBar.endTextField] )
        {
            self.startReady = NO;
        }
    }
}


#pragma mark - 
#pragma mark private methods

- (void)loadNearbyStations
{
    if ( _menu.selectedIndex == 0 ) {
        self.nearbyStations = [[BUSDBHelper sharedInstance] queryNearbyStations:[BHUserModel sharedInstance].coordinate];
    }
    
    [_tableView reloadData];
}

- (void)initBusRouteSearchOption
{
    startPoi = [[AMapPOI alloc] init];
    AMapGeoPoint *loc = [[AMapGeoPoint alloc]init];
    startPoi.location = loc;
    
    endPoi = [[AMapPOI alloc] init];
    loc = [[AMapGeoPoint alloc]init];
    endPoi.location = loc;
}

- (void)searchPlace:(NSString *)from to:(NSString *)to
{
    if ( self.startReady && self.endReady )
    {
        //clear search state
        self.startReady = NO;
        self.endReady = NO;
        
        [self getTransitRoutes];
    }
    else
    {
        // 如果当前是我的位置,直接搜索目的地
        if ( from && from.length > 0 )
        {
            BHStartResPopView *startPopView = [[BHStartResPopView alloc] initWithTitle:@"我的位置..." key:from];
            [startPopView showInView:self.view selected:^(AMapPOI *poi) {
                _transferBar.startTextField.text = poi.name;
                self.startPoi.location.latitude = poi.location.latitude;
                self.startPoi.location.longitude = poi.location.longitude;
            } completion:^(BOOL complete) {
                self.startReady = YES;
                [self searchPlace:nil to:to];  // 继续查找目的地
            }];
            [startPopView release];
        }
        else if ( to && to.length > 0 )
        {
            if ( !from || from.length == 0 )
            {
                self.startReady = YES;
                self.startPoi.location.latitude = [BHUserModel sharedInstance].coordinate.latitude;
                self.startPoi.location.longitude = [BHUserModel sharedInstance].coordinate.longitude;
            }
            
            BHEndResPopView *endPopView = [[BHEndResPopView alloc] initWithTitle:@"我想去..." key:to];
            [endPopView showInView:self.view selected:^(AMapPOI *poi) {
                _transferBar.endTextField.text = poi.name;
                self.endPoi.location.latitude = poi.location.latitude;
                self.endPoi.location.longitude = poi.location.longitude;
                
            } completion:^(BOOL complete) {
                self.endReady = YES;
                [self getTransitRoutes];  // 获取换乘方案
            }];
            [endPopView release];
        }
    }
}

- (void)getTransitRoutes
{
    NSLog(@"start:(%f, %f) - end:(%f, %f)", self.startPoi.location.latitude, self.startPoi.location.longitude, self.endPoi.location.latitude, self.endPoi.location.longitude);
    
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviBus;
    navi.requireExtension = YES;
    navi.city             = @"nanjing";
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startPoi.location.latitude
                                           longitude:self.startPoi.location.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.endPoi.location.latitude
                                                longitude:self.endPoi.location.longitude];
    
    [_search AMapNavigationSearch:navi];
}

- (void)segmentedControlChangedValue:(id)sender
{
    [_searchBar clear];
    [self performSelector:@selector(loadNearbyStations) withObject:nil afterDelay:0];
}

- (void)pushTransPlan:(id)result
{
    BHTransPlanBoard *board = [[BHTransPlanBoard alloc] initWithResult:result];
    [self.stack pushBoard:board animated:YES];
    [board release];
}


#pragma mark -
#pragma mark BHSearchPopoupsDelegate

- (void)searchPopoups:(UIView *)view didSelectWithData:(id)data
{
    if ( _menu.selectedIndex == 0 )
    {
        LKStation *station = (LKStation *)data;
        BHStationBoard *board = [[BHStationBoard alloc] initWithDataSource:station];
        [self.stack pushBoard:board animated:YES];
        [board release];
    }
    else if ( _menu.selectedIndex == 1 )
    {
        LKRoute *route = (LKRoute *)data;
        BHRouteBoard *board = [[BHRouteBoard alloc] initWithRoute:route];
        [self.stack pushBoard:board animated:YES];
        [board release];
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
		[_tableView reloadData];
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
    return (_menu.selectedIndex == 0 || _menu.selectedIndex == 2) ? 2 : 1;
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
        
        if ( indexPath.section == 1 )
        {
            _stationsTable = [[BHStationsTable alloc] initWithFrame:CGRectMake(10.f, 0.f, 300.f, 100.f)];
            _stationsTable.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:_stationsTable];
        }
    }
    
    if ( indexPath.section == 0 )
    {
        [_transferBar removeFromSuperview];
        [_searchBar removeFromSuperview];
        
        if ( _menu.selectedIndex == 3 )
        {
            if (!_transferBar) {
                _transferBar = [[BHTransferBar alloc] initWithFrame:CGRectMake(0.f, 8.f, 320.f, kTransferBarHeight)];
            }
            [cell.contentView addSubview:_transferBar];
        }
        else
        {
            if (!_searchBar) {
                _searchBar = [[BHSearchBar alloc] initWithFrame:CGRectMake(0.f, 8.f, 320.f, kSearchBarHeight)];
            }
            switch (_menu.selectedIndex)
            {
                case 0:
                    _searchBar.placeholder = @"公交站台名称,如:鼓楼";
                    break;
                case 1:
                    _searchBar.placeholder = @"公交线路名称,如:46";
                    break;
                case 2:
                    _searchBar.placeholder = @"输入地点名称,如:丹凤街";
                    break;
                default:
                    break;
            }
            [cell.contentView addSubview:_searchBar];
        }
    }
    
    if ( indexPath.section == 1 && _menu.selectedIndex < 3 )
    {
        CGFloat height = kItemHeaderHeight + self.nearbyStations.count * kItemCellHeight;
        _stationsTable.frame = CGRectMake(10.f, 3.f, 300.f, height);
        _stationsTable.stations = self.nearbyStations;
        _stationsTable.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        return _menu.selectedIndex == 3 ? kTransferBarHeight + 8.f : 50.f;
    } else {
        return kItemHeaderHeight + self.nearbyStations.count * kItemCellHeight + 13.f;
    }
}


#pragma mark -
#pragma mark scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar setActive:false];
}


#pragma mark - Bus Route Delegate

- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)result
{
    AMapRoute *route = result.route;
    
    if ( !result || route.transits.count == 0 )
    {
        [self presentMessageTips:@"没有搜索到结果"];
        return;
    }
    
    [self performSelector:@selector(pushTransPlan:) withObject:result afterDelay:0.f];
}

- (void)search:(id)searchOption Error:(NSString*)errCode
{
    NSLog(@"errCode :%@", errCode);
}

@end
