//
//  AppDelegate.m
//  SmartBus
//
//  Created by launching on 13-9-26.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "AppDelegate.h"
#import "BHMenuBoard.h"
#import "BHLaunchHelper.h"
#import "MALocationMgr.h"
#import "UISplashOverView.h"
#import "BHBoardDefines.h"
#import "BHUserHelper.h"
#import "BaiduMobStat.h"
#import "BHNotification.h"

#import "BHNewsModel.h"
#import "BHAnnouceModel.h"
#import "BHAnnDescBoard.h"
#import "BHAdvWebBoard.h"
#import "BHNewsDescBoard.h"
#import "BHTrendsDescBoard.h"
#import "BHTalkBoard.h"
#import "GTMBase64.h"
#import "BUSDBUpdateHelper.h"
#import "NSDate+Helper.h"
#import "BUSDBHelper.h"
#import "APService.h"

@interface AppDelegate ()<UIAlertViewDelegate,BUSDBUpdateHelperDelegate>
{
    UISplashOverView *splashOverView;
    NSMutableArray *_boardStacks;
    BHLaunchHelper *_launchHelper;
    BHUserHelper *_userHelper;
    BHNotification *_notification;
    BUSDBUpdateHelper *_dbUpdateHelper;/*增量更新*/
    NSTimeInterval _timeIntervalForBegin;
    NSTimeInterval _timeIntervalForEnd;
}

- (void)addRequests;

- (void)observeNotifications;
- (void)removeNotifications;

- (void)loadAllBoards;
- (void)setRootViewController;

- (void)registerBaiduMobStat;

@end


@implementation AppDelegate

DEF_NOTIFICATION( EXIST_NEW_VERSION )

#pragma mark
#pragma mark - public methods

- (void)toggleSlideMenu
{
    if ( self.reveal.focusedController == self.reveal.leftViewController ) {
        [self.reveal showViewController:self.reveal.frontViewController];
    } else {
        [self.reveal showViewController:self.reveal.leftViewController];
    }
}

- (BeeUIBoard *)boardAtIndex:(NSInteger)index
{
    BeeUIBoard *board = [_boardStacks objectAtIndex:index];
    return board;
}


#pragma mark
#pragma mark - private methods

- (void)addRequests
{
    // 判断网络是否可用
    if ( !connectedToNetwork() )
    {
        [self presentMessageTips:@"当前网络不可用"];
        return;
    }
    
    // 获取用户个人中心详情
    if ( [BHUtil userID] > 0 )
    {
        [_userHelper getUserDetail:[BHUtil userID] shower:[BHUtil userID]];
    }
    
    // 每次打开APP,先定位自己的位置
    [[MALocationMgr sharedInstance] start];
    
    // 获取重要通知
    [_launchHelper getImportNotice];
    
    // 获取版本信息NEW
    [_launchHelper SBGetVersion];
}

- (void)registerBaiduMobStat
{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;
    statTracker.shortAppVersion = IosAppVersion;
    [statTracker startWithAppId:@"fecb306f8a"];
}

- (void)setRootViewController
{
    // 打开首页
    BeeUIBoard *appBoard = [_boardStacks objectAtIndex:0];
    if ( !appBoard ) {
        return;
    }
    
    BHMenuBoard *menuBoard = [BHMenuBoard board];
    BeeUIStack *menuStack = [BeeUIStack stackWithFirstBoard:menuBoard];
    BeeUIStack *appStack = [BeeUIStack stackWithFirstBoard:appBoard];
    
    self.reveal = [PKRevealController revealControllerWithFrontViewController:appStack
                                                           leftViewController:menuStack
                                                                      options:nil];
    
    [self.window setRootViewController:self.reveal];
    
    [self checkRemote];
}

- (void)observeNotifications
{
    [self observeNotification:self.LAUNCHED];
    [self observeNotification:self.STATE_CHANGED];
    [self observeNotification:self.ENTER_FOREGROUND];
    [self observeNotification:self.REMOTE_NOTIFICATION];
    [self observeNotification:self.LOCAL_NOTIFICATION];
    [self observeNotification:self.APS_REGISTERED];
    [self observeNotification:self.APS_ERROR];
}

- (void)removeNotifications
{
    [self unobserveAllNotifications];
}

- (void)loadAllBoards
{
    _boardStacks = [[NSMutableArray alloc] initWithCapacity:0];
    
    // 首页
    BHAppBoard *appBoard = [BHAppBoard board];
    [_boardStacks addObject:appBoard];
    
    // 公交
    BHSeekBoard *seekBoard = [BHSeekBoard board];
    [_boardStacks addObject:seekBoard];
    
    // 动态
    BHTrendsBoard *trendsBoard = [BHTrendsBoard board];
    [_boardStacks addObject:trendsBoard];
    
    // 电视
    BHMobileTVBoard *mtvBoard = [BHMobileTVBoard board];
    [_boardStacks addObject:mtvBoard];
    
    // 资讯
    BHNewsBoard *newsBoard = [BHNewsBoard board];
    [_boardStacks addObject:newsBoard];
    
    // 设置
    BHSettingBoard *settingBoard = [BHSettingBoard board];
    [_boardStacks addObject:settingBoard];
}

- (void)checkRemote
{
    if ( self.window.rootViewController && _notification )
    {
        if ( _notification.loaded )
        {
            return;
        }
        
        _notification.loaded = YES;
        
        if ( _notification.type == 11 )
        {
            BHAnnouceModel *annouce = [[BHAnnouceModel alloc] init];
            annouce.conurl = _notification.url;
            BHAnnDescBoard *board = [[BHAnnDescBoard alloc] initWithAnnouce:annouce];
            [(BeeUIStack *)self.reveal.frontViewController pushBoard:board animated:YES];
            [board release];
            [annouce release];
        }
        else if ( _notification.type == 12 )
        {
            BHAdvWebBoard *board = [BHAdvWebBoard board];
            board.urlString = _notification.url;
            [(BeeUIStack *)self.reveal.frontViewController pushBoard:board animated:YES];
        }
        else if ( _notification.type == 20 )
        {
            BHNewsModel *news = [[BHNewsModel alloc] init];
            news.nid = _notification.oid;
            BHNewsDescBoard *board = [[BHNewsDescBoard alloc] initWithNews:news];
            [(BeeUIStack *)self.reveal.frontViewController pushBoard:board animated:YES];
            [board release];
            [news release];
        }
        else if ( _notification.type == 30 )
        {
            BHTrendsDescBoard *board = [[BHTrendsDescBoard alloc] initWithFeedId:_notification.oid];
            [(BeeUIStack *)self.reveal.frontViewController pushBoard:board animated:YES];
            [board release];
        }
        else if ( _notification.type == 40 )
        {
            // 暂无
        }
    }
}


#pragma mark
#pragma mark - life cycle

- (void)load
{
    [MAMapServices sharedServices].apiKey = AMAPKEY;
    
    _launchHelper = [[BHLaunchHelper alloc] init];
    [_launchHelper addObserver:self];
    
    _userHelper = [[BHUserHelper alloc] init];
    [_userHelper addObserver:self];
    
    // 注册通知
    [self observeNotifications];
    
    // 注册百度移动统计
    [self registerBaiduMobStat];
    
    // 加载启动图
    splashOverView = [[UISplashOverView alloc] init];
    [splashOverView show];
    
    // 增量更新
    _dbUpdateHelper = [[BUSDBUpdateHelper alloc] init];
    _dbUpdateHelper.delegate = self;
    
    // 计算最大的更新时间
    self.line_updated = [[BUSDBHelper sharedInstance] queryMaxUpdateTimeInTable:TABLE_NAME_LINE];
    self.st_updated = [[BUSDBHelper sharedInstance] queryMaxUpdateTimeInTable:TABLE_NAME_STATION];
    self.updown_updated = [[BUSDBHelper sharedInstance] queryMaxUpdateTimeInTable:TABLE_NAME_LINE_UPDOWN];
    self.lst_updated = [[BUSDBHelper sharedInstance] queryMaxUpdateTimeInTable:TABLE_NAME_LINE_STATION];
    
    [super load];
}

- (void)unload
{
    // 关闭定位
    [[MALocationMgr sharedInstance] stop];
    
    // 取消注册
    [self removeNotifications];
    
    [_launchHelper removeObserver:self];
    SAFE_RELEASE(_launchHelper);
    
    [_userHelper removeObserver:self];
    SAFE_RELEASE(_userHelper);
    
    SAFE_RELEASE(self.reveal);
    SAFE_RELEASE(_boardStacks);
    
    [super unload];
}


#pragma mark - DBUpdateHelperDelegate

- (void)DBUpdateFinish
{
    _timeIntervalForEnd = [[NSDate date] timeIntervalSince1970];
    [splashOverView dismissTips];
    
    [UIView animateWithDuration:3.f animations:^{
        [splashOverView.progressView setWidth:320];
    } completion:^(BOOL finished) {
        [splashOverView hide];
    }];
}

- (void)DBUpdateInfo:(NSString *)info
{
    [splashOverView presentLoadingTips:@"正在更新线路数据..."];
    _timeIntervalForBegin = [[NSDate date] timeIntervalSince1970];
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.succeed )
	{
        if ( [request.userInfo is:@"getUserDetail"] )
        {
            [BHUserModel sharedInstance].uid = _userHelper.user.uid;
            [BHUserModel sharedInstance].uname = _userHelper.user.uname;
            [BHUserModel sharedInstance].avator = _userHelper.user.avator;
            [BHUserModel sharedInstance].birth = _userHelper.user.birth;
            [BHUserModel sharedInstance].ugender = _userHelper.user.ugender;
            [BHUserModel sharedInstance].signature = _userHelper.user.signature;
            [BHUserModel sharedInstance].profession = _userHelper.user.profession;
            [BHUserModel sharedInstance].location = _userHelper.user.location;
            [BHUserModel sharedInstance].score = _userHelper.user.score;
        }
        else if ( [request.userInfo is:@"SBGetVersion"] )
        {
            NSDictionary *result = [request.responseString objectFromJSONString];
            
            // 加载广告
            splashOverView.adid = [BHLaunchModel sharedInstance].adv_id;
            [splashOverView setOverImageWithURL:[NSURL URLWithString:[BHLaunchModel sharedInstance].splash]
                                     withAdvUrl:[BHLaunchModel sharedInstance].adv];
            
            // 如果存在版本更新，通知首页提示更新
            if ( [BHUtil existNewVersion] ) {
                [self postNotification:self.EXIST_NEW_VERSION];
            }
            
            if ([_dbUpdateHelper checkUpdate:result[@"updated"]]) {
                // TODO:
            }
        }
	}
	else if ( request.failed )
	{
		NSLog(@"[ERROR] %@", request.error);
	}
}


ON_NOTIFICATION( notification )
{
    if ( [notification is:self.LAUNCHED] )
    {
        // 加入请求
        [self addRequests];
        
        // 加载所有模块
        [self loadAllBoards];
        
        // 设置首页
        [self setRootViewController];
        
        // 打开通知
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
        });
        
        // Required
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)];
        // Required
        NSDictionary *launchOptions = notification.object;
        [APService setupWithOption:launchOptions];
    }
    else if ( [notification is:self.STATE_CHANGED] )
    {
        //hide the badge
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        // 判断推送类型做相应处理
        [self checkRemote];
    }
    else if ( [notification is:self.ENTER_FOREGROUND] )
    {
        //[self addRequests];
    }
    else if ( [notification is:self.REMOTE_NOTIFICATION] )
    {
        NSLog(@"notification :%@", notification.object);
        
        [UIApplication sharedApplication].applicationIconBadgeNumber ++;
        
        // Required
        NSDictionary *launchOptions = notification.object;
        [APService handleRemoteNotification:launchOptions[@"userInfo"]];
        
        [self handleRemoteNotification:launchOptions];
    }
    else if ( [notification is:self.APS_REGISTERED] )
    {
        NSLog(@"DEVICE TOKEN : %@", notification.object);
        
        // Required
        [APService registerDeviceToken:notification.object];
    }
    else if ( [notification is:self.APS_ERROR] )
    {
        // 错误,不发送token到服务器
    }
}

- (void)handleRemoteNotification:(NSDictionary *)launchOptions
{
    NSDictionary *userInfo = [launchOptions objectForKey:@"userInfo"];
    NSDictionary *data = [userInfo objectForKey:@"data"];
    
    SAFE_RELEASE(_notification);
    _notification = [[BHNotification alloc] init];
    _notification.type = [[data objectForKey:@"type"] intValue];
    _notification.oid = [[data objectForKey:@"id"] intValue];
    
    NSData *baseData = [[data objectForKey:@"url"] data];
    NSString *base64String = [[NSString alloc]initWithData:[GTMBase64 decodeData:baseData] encoding:NSUTF8StringEncoding];
    _notification.url = [NSString stringWithFormat:@"http://%@", base64String];
    
    if ( [[launchOptions objectForKey:@"inApp"] boolValue] == 1 )
    {
        NSString *message = nil;
        switch ( _notification.type )
        {
            case 10:
                message = @"发现新版本,是否立即更新?";
                break;
            case 11:
                message = @"您收到一条新的公告,是否查看?";
                break;
            case 12:
                message = @"您收到一条新的广告,是否查看?";
                break;
            case 20:
                message = @"您收到一条新的资讯,是否查看?";
                break;
            case 30:
                message = @"您收到一条新的动态,是否查看?";
                break;
            case 40:
                message = @"您收到一条新的私信,是否查看?";
                break;
            default:
                break;
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"来自南京掌上公交"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:@"取消", nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        if ( _notification.type == 10 )
        {
            NSURL *iTunesURL = [NSURL URLWithString:@"https://itunes.apple.com/app/id688262741"];
            [[UIApplication sharedApplication] openURL:iTunesURL];
        }
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 )
    {
        return;
    }
    
    if ( _notification.type == 10 )
    {
        NSURL *iTunesURL = [NSURL URLWithString:@"https://itunes.apple.com/app/id688262741"];
        [[UIApplication sharedApplication] openURL:iTunesURL];
    }
    else if ( _notification.type == 11 )
    {
        BHAnnouceModel *annouce = [[BHAnnouceModel alloc] init];
        annouce.conurl = _notification.url;
        BHAnnDescBoard *board = [[BHAnnDescBoard alloc] initWithAnnouce:annouce];
        [(BeeUIStack *)self.reveal.frontViewController pushBoard:board animated:YES];
        [board release];
        [annouce release];
    }
    else if ( _notification.type == 12 )
    {
        BHAdvWebBoard *board = [BHAdvWebBoard board];
        board.urlString = _notification.url;
        [(BeeUIStack *)self.reveal.frontViewController pushBoard:board animated:YES];
    }
    else if ( _notification.type == 20 )
    {
        BHNewsModel *news = [[BHNewsModel alloc] init];
        news.nid = _notification.oid;
        BHNewsDescBoard *board = [[BHNewsDescBoard alloc] initWithNews:news];
        [(BeeUIStack *)self.reveal.frontViewController pushBoard:board animated:YES];
        [board release];
        [news release];
    }
    else if ( _notification.type == 30 )
    {
        BHTrendsDescBoard *board = [[BHTrendsDescBoard alloc] initWithFeedId:_notification.oid];
        [(BeeUIStack *)self.reveal.frontViewController pushBoard:board animated:YES];
        [board release];
    }
    else if ( _notification.type == 40 )
    {
        // 暂无
    }
}


@end
