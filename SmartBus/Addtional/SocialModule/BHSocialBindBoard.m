//
//  BHSocialBindBoard.m
//  SmartBus
//
//  Created by launching on 13-11-4.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSocialBindBoard.h"
#import "WBShareKey.h"
#import "WBEngine.h"
#import "TCWBEngine.h"

@interface BHSocialBindBoard ()<UITableViewDataSource, UITableViewDelegate, WBEngineDelegate>
{
    BeeUITableView *weiboTable;
    NSArray *weiboNames;
    NSArray *weiboIcons;
    WBEngine *sinaWeiboEngine;
    TCWBEngine *tcWeiboEngine;
}
- (void)initWeiboAPI;
- (BOOL)isLoggedInAtMode:(NSInteger)mode;
- (void)updateWeiboStatus:(BOOL)logged atRow:(NSInteger)row;
@end

#define SETTINGS_BIND_BUTTON_TAG     8000
#define kTitleLabelTag  9571
#define SETTINGS_BIND_ICON_TAG   9572

@implementation BHSocialBindBoard

- (void)load
{
    weiboNames = [[NSArray alloc] initWithObjects:@"新浪微博", @"腾讯微博", nil];
    weiboIcons = [[NSArray alloc] initWithObjects:@"icon_sina_big.png", @"icon_tencent_big.png", nil];
    [self initWeiboAPI];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(weiboNames);
    SAFE_RELEASE(weiboIcons);
    SAFE_RELEASE(sinaWeiboEngine);
    SAFE_RELEASE(tcWeiboEngine);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_social.png"] title:@"社交绑定"];
        
        weiboTable = [[BeeUITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        weiboTable.backgroundColor = [UIColor clearColor];
        weiboTable.dataSource = self;
        weiboTable.delegate = self;
        weiboTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.beeView addSubview:weiboTable];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(weiboTable);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		weiboTable.frame = self.beeView.bounds;
	}
}


#pragma mark -
#pragma mark private methods

- (void)initWeiboAPI
{
    // 新浪微博
    sinaWeiboEngine = [[WBEngine alloc] initWithAppKey:kSinaAppKey
                                             appSecret:kSinaAppSecret];
    [sinaWeiboEngine setRootViewController:self];
    [sinaWeiboEngine setDelegate:self];
    [sinaWeiboEngine setRedirectURI:kSinaAppRedirectURI];
    [sinaWeiboEngine setIsUserExclusive:YES];
    
    // 腾讯微博
    tcWeiboEngine = [[TCWBEngine alloc] initWithAppKey:kTCWBAppKey
                                             andSecret:kTCWBAppSecret
                                        andRedirectUrl:kTCWBAppRedirectURI];
    [tcWeiboEngine setRootViewController:self];
}

- (BOOL)isLoggedInAtMode:(NSInteger)mode
{
    BOOL login = NO;
    
    switch (mode) {
        case 0:
            login = [sinaWeiboEngine isLoggedIn] && ![sinaWeiboEngine isAuthorizeExpired];
            break;
        case 1:
            login = [tcWeiboEngine isLoggedIn] && ![tcWeiboEngine isAuthorizeExpired];
            break;
        default:
            break;
    }
    
    return login;
}

- (void)updateWeiboStatus:(BOOL)logged atRow:(NSInteger)row
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    UITableViewCell *cell = [weiboTable cellForRowAtIndexPath:indexPath];
    
    UIImageView *iconImageView = (UIImageView *)[cell.contentView viewWithTag:SETTINGS_BIND_ICON_TAG];
    iconImageView.alpha = logged ? 1.f : 0.4f;
    
    UIButton *toggleButton = (UIButton *)[cell.contentView viewWithTag:SETTINGS_BIND_BUTTON_TAG + row];
    toggleButton.selected = logged;
}


#pragma mark - button events

- (void)toggleBind:(id)sender
{
    switch ([sender tag] - SETTINGS_BIND_BUTTON_TAG) {
        case 0:
            if (![self isLoggedInAtMode:0]) {
                [sinaWeiboEngine logIn];
            } else {
                [sinaWeiboEngine logOut];
            }
            break;
        case 1:
            if (![self isLoggedInAtMode:1]) {
                [tcWeiboEngine logInWithDelegate:self
                                       onSuccess:@selector(handleTCWBSuccess:)
                                       onFailure:@selector(handleTCWBFailure:)];
            } else {
                if ([tcWeiboEngine logOut]) {
                    [self updateWeiboStatus:NO atRow:1];
                }
            }
            break;
        default:
            break;
    }
}


#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [weiboNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)]];
        bubbleImageView.frame = CGRectMake(10.f, 8.f, 300.f, 48.f);
        bubbleImageView.userInteractionEnabled = YES;
        [cell.contentView addSubview:bubbleImageView];
        [bubbleImageView release];
        
        UILabel *weiboNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.f, 12.f, 120.f, 40.f)];
        weiboNameLabel.backgroundColor = [UIColor clearColor];
        weiboNameLabel.font = [UIFont systemFontOfSize:16.f];
        weiboNameLabel.textColor = [UIColor darkGrayColor];
        weiboNameLabel.text = [weiboNames objectAtIndex:indexPath.row];
        [cell.contentView addSubview:weiboNameLabel];
        [weiboNameLabel release];
        
        NSString *weiboIcon = [weiboIcons objectAtIndex:indexPath.row];
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:weiboIcon]];
        iconImageView.frame = CGRectMake(20.f, 17.f, 26.f, 26.f);
        iconImageView.tag = SETTINGS_BIND_ICON_TAG;
        iconImageView.alpha = [self isLoggedInAtMode:indexPath.row] ? 1.f : 0.4f;
        
        UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toggleButton.frame = CGRectMake(310.f-30.f, 22.f, 20.f, 20.f);
        toggleButton.tag = SETTINGS_BIND_BUTTON_TAG + indexPath.row;
        [toggleButton setBackgroundImage:[UIImage imageNamed:@"icon_grey.png"] forState:UIControlStateNormal];
        [toggleButton setBackgroundImage:[UIImage imageNamed:@"icon_red.png"] forState:UIControlStateSelected];
        [toggleButton addTarget:self action:@selector(toggleBind:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:toggleButton];
        toggleButton.selected = [self isLoggedInAtMode:indexPath.row];
        
        [cell.contentView addSubview:iconImageView];
        [iconImageView release];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.f;
}


#pragma mark - 新浪微博回调

- (void)engineAlreadyLoggedIn:(WBEngine *)engine {
    NSLog(@"sina already logged in !!!");
}

- (void)engineDidLogIn:(WBEngine *)engine {
    [self updateWeiboStatus:YES atRow:0];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    //
}

- (void)engineDidLogOut:(WBEngine *)engine {
    [self updateWeiboStatus:NO atRow:0];
}

- (void)engineNotAuthorized:(WBEngine *)engine {
    [self updateWeiboStatus:NO atRow:0];
}

- (void)engineAuthorizeExpired:(WBEngine *)engine {
    [self updateWeiboStatus:NO atRow:0];
}


#pragma mark - 腾讯微博回调

- (void)handleTCWBSuccess:(NSDictionary *)info {
    if ([[info objectForKey:@"ret"] integerValue] == 0) {
        [self updateWeiboStatus:YES atRow:1];
    } else {
        NSLog(@"[腾讯微博]登录失败!!!");
    }
}

- (void)handleTCWBFailure:(NSDictionary *)info {
    NSLog(@"[腾讯微博]登录失败!!!");
}


#pragma mark - 人人网回调

- (void)renrenDidLogin:(Renren *)renren {
    [self updateWeiboStatus:YES atRow:2];
}

- (void)renrenDidLogout:(Renren *)renren {
    [self updateWeiboStatus:NO atRow:2];
}

- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error{
	NSLog(@"renren error:%@", error);
}

@end
