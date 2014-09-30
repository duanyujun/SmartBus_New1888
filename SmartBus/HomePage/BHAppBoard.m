//
//  BHAppBoard.m
//  SmartBus
//
//  Created by launching on 13-9-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAppBoard.h"
#import "BHTaskRegBoard.h"
#import "BHTrendsBoard.h"
#import "BHNewsBoard.h"
#import "BHSeekBoard.h"
#import "BHFavoriteBoard.h"
#import "BHAdvWebBoard.h"
#import "BHAppSectionView.h"
#import "BHScrollerView.h"
#import "BHAppHelper.h"
#import "BHLaunchHelper.h"
#import "BHLaunchModel.h"
#import "BHAppAlert.h"

@interface BHAppBoard ()
<BHScrollerDataSource, BHScrollerDelegate, BHAppSectionDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    BHScrollerView *_scroller;
    BHAppSectionView *_trendsSectionView;
    BHAppSectionView *_newsSectionView;
    BHAppHelper *_appHelper;
}
@end

#define kTableHeaderHeight   32.f

@implementation BHAppBoard

DEF_SIGNAL( CHECK_IN );
DEF_SIGNAL( FAVORITE );
DEF_SIGNAL( BUS_SEARCH );

- (void)load
{
    _appHelper = [[BHAppHelper alloc] init];
    [_appHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_appHelper removeObserver:self];
    SAFE_RELEASE(_appHelper);
    [self unobserveAllNotifications];
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:YES image:[UIImage imageNamed:@"nav_home.png"] title:@"南京掌上公交"];
        
        BeeUIButton *signInButton = [BeeUIButton new];
        signInButton.frame = CGRectMake(320.f-44.f, 0.f, 44.f, 44.f);
        signInButton.image = [UIImage imageNamed:@"icon_qiandao.png"];
        [signInButton addSignal:self.CHECK_IN forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:signInButton];
        
        self.egoTableView.showsVerticalScrollIndicator = NO;
        [self setEnableRefreshHeader:YES];
        
        // 注册新版本更新通知
        [self observeNotification:AppDelegate.EXIST_NEW_VERSION];
        [self observeNotification:BHLaunchHelper.TIPS_IMPORTANT];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_scroller);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		self.egoTableView.frame = self.beeView.bounds;
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [_appHelper getAppHomeInfo];
        [_appHelper performSelector:@selector(getAppAdverts) withObject:nil afterDelay:3];
	}
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        //
    }
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.CHECK_IN] )
    {
        if ( [BHUserModel sharedInstance].uid <= 0 )
        {
            BHLoginBoard *board = [BHLoginBoard board];
            BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
            [self presentViewController:stack animated:YES completion:nil];
            return;
        }
        
        BHTaskRegBoard *board = [BHTaskRegBoard board];
        [self.stack pushBoard:board animated:YES];
    }
    else if ( [signal is:self.FAVORITE] )
    {
        if ( [BHUserModel sharedInstance].uid <= 0 )
        {
            BHLoginBoard *board = [BHLoginBoard board];
            BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
            [self presentViewController:stack animated:YES completion:nil];
            return;
        }
        
        BeeUIBoard *board = [BHFavoriteBoard board];
        [self.stack pushBoard:board animated:YES];
    }
    else if ( [signal is:self.BUS_SEARCH] )
    {
        BHSeekBoard *board = [BHSeekBoard board];
        board.leaf = YES;
        [self.stack pushBoard:board animated:YES];
    }
}

ON_NOTIFICATION2( AppDelegate, notification )
{
    if ( [notification is:AppDelegate.EXIST_NEW_VERSION] )
    {
        NSString *msg = [NSString stringWithFormat:@"马上升级新版本吧: %@", [BHLaunchModel sharedInstance].tips];
        if ( [BHLaunchModel sharedInstance].forced )
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
        else
        {
            NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_VERSION"];
            if ( !version || ![version is:[BHLaunchModel sharedInstance].version] )
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"稍候提醒", @"不再提醒", nil];
                [alertView show];
                [alertView release];
            }
        }
    }
}

ON_NOTIFICATION2( BHLaunchHelper, notification )
{
    if ( [notification is:BHLaunchHelper.TIPS_IMPORTANT] )
    {
        [[BHAppAlert sharedInstance] showMessage:notification.object inView:self.view];
    }
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 )
    {
        NSURL *iTunesURL = [NSURL URLWithString:@"https://itunes.apple.com/app/id688262741"];
        [[UIApplication sharedApplication] openURL:iTunesURL];
    }
    else if ( buttonIndex == 2 )
    {
        [[NSUserDefaults standardUserDefaults] setObject:[BHLaunchModel sharedInstance].version forKey:@"APP_VERSION"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
        
        if ( [request.userInfo is:@"getAppInfo"] ) {
            [self reloadDataSucceed:YES];
        } else if ( [request.userInfo is:@"getAdverts"] ) {
            [_scroller reloadData];
        }
	}
	else if ( request.failed )
	{
		[self dismissTips];
        [self reloadDataSucceed:NO];
	}
}


#pragma mark -
#pragma mark BHAppSectionDelegate

- (void)appSectionViewDidSelectMore:(UIView *)view
{
    if ( [view isEqual:_trendsSectionView] )
    {
        BHTrendsBoard *board = [BHTrendsBoard board];
        board.movingMode = BHMovingModeHOT;
        board.leaf = YES;
        [self.stack pushBoard:board animated:YES];
    }
    else
    {
        BHNewsBoard *board = [BHNewsBoard board];
        board.leaf = YES;
        [self.stack pushBoard:board animated:YES];
    }
}

- (void)appSectionViewDidTapped:(UIView *)view
{
    if ( [view isEqual:_trendsSectionView] )
    {
        BHTrendsBoard *board = [BHTrendsBoard board];
        board.movingMode = BHMovingModeHOT;
        board.leaf = YES;
        [self.stack pushBoard:board animated:YES];
    }
    else
    {
        BHNewsBoard *board = [BHNewsBoard board];
        board.leaf = YES;
        [self.stack pushBoard:board animated:YES];
    }
}


#pragma mark - 
#pragma mark BHScrollerDataSource

- (UIImage *)backgroundImage
{
    return [UIImage imageNamed:@"bubble.png"];
}

- (CGRect)frameForPageControl
{
    return CGRectMake(90.f, 130.f, 120.f, 20.f);
}

- (NSInteger)numberOfImages
{
    return _appHelper.app.banners.count;
}

- (UIView *)imageViewAtIndex:(NSInteger)index
{
    BHBannerModel *banner = _appHelper.app.banners[index];
    
    BeeUIImageView *imageView = [[BeeUIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 310.f, 150.f)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView GET:banner.cover useCache:YES];
    return [imageView autorelease];
}


#pragma mark -
#pragma mark BHScrollerDelegate

- (void)photoView:(BHScrollerView *)photoView didSelectAtIndex:(NSInteger)index
{
    BHBannerModel *banner = _appHelper.app.banners[index];
    [BHAppHelper submitAdvInfoById:banner.bid andType:2];
    
    BHAdvWebBoard *board = [BHAdvWebBoard board];
    board.urlString = banner.direct;
    [self.stack pushBoard:board animated:YES];
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
            _scroller = [[BHScrollerView alloc] initWithFrame:CGRectMake(5.f, 6.f, 310.f, 150.f)];
            _scroller.layer.masksToBounds = YES;
            _scroller.layer.cornerRadius = 5.f;
            _scroller.dataSource = self;
            _scroller.delegate = self;
            _scroller.autoScrolled = YES;
            [cell.contentView addSubview:_scroller];
        }
        else if ( indexPath.section == 1 )
        {
            BeeUIButton *favoriteButton = [BeeUIButton new];
            favoriteButton.frame = CGRectMake(5.f, 5.f, 150.f, 55.f);
            favoriteButton.image = [UIImage imageNamed:@"btn_collection.png"];
            [favoriteButton addSignal:self.FAVORITE forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:favoriteButton];
            
            BeeUIButton *searchButton = [BeeUIButton new];
            searchButton.frame = CGRectMake(165.f, 5.f, 150.f, 55.f);
            searchButton.image = [UIImage imageNamed:@"btn_search.png"];
            [searchButton addSignal:self.BUS_SEARCH forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:searchButton];
        }
        else if ( indexPath.section == 2 )
        {
            _trendsSectionView = [[BHAppSectionView alloc] initWithPosition:CGPointMake(5.f, 5.f) delegate:self];
            _trendsSectionView.tintColor = [UIColor flatRedColor];
            _trendsSectionView.image = [UIImage imageNamed:@"icon_hot.png"];
            _trendsSectionView.title = @"热门动态";
            [cell.contentView addSubview:_trendsSectionView];
        }
        else
        {
            _newsSectionView = [[BHAppSectionView alloc] initWithPosition:CGPointMake(5.f, 5.f) delegate:self];
            _newsSectionView.tintColor = [UIColor flatGreenColor];
            _newsSectionView.image = [UIImage imageNamed:@"icon_life.png"];
            _newsSectionView.title = @"南京生活";
            [cell.contentView addSubview:_newsSectionView];
        }
    }
    
    if ( indexPath.section == 2 ) {
        [_trendsSectionView setStyle:AppStyleTrends dataSource:_appHelper.app.recommend];
    } else if ( indexPath.section == 3 ) {
        [_newsSectionView setStyle:AppStyleNews dataSource:_appHelper.app.liveinfo];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 0.f;
    switch (indexPath.section) {
        case 0:
            heightForRow = 155.f;
            break;
        case 1:
            heightForRow = 60.f;
            break;
        case 2:
            heightForRow = kSectionHeaderHeight + 16.f + 52.f + 5.f;
            break;
        default:
            heightForRow = kSectionHeaderHeight + 16.f + 52.f + 10.f;
            break;
    }
    return heightForRow;
}


#pragma mark - ego table view refresh

- (void)refreshTableViewDataSource
{
    [_appHelper getAppHomeInfo];
}


@end
