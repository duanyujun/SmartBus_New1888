//
//  BHWeiboHelper.m
//  SmartBus
//
//  Created by launching on 13-11-1.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHWeiboHelper.h"
#import "WBShareKey.h"

@interface BHWeiboHelper ()<WBEngineDelegate>
{
    UIViewController *_viewController;
    WBEngine *sinaWeiboEngine;
    TCWBEngine *tcWeiboEngine;
    
    NSString *_content;
    UIImage *_image;
    
    id _delegate;
}
- (void)initWeiboApis;
@end

@implementation BHWeiboHelper

DEF_SINGLETON( BHWeiboHelper );

@synthesize viewController = _viewController;

- (id)initWithTarget:(id)controller
{
    if ( self = [super init] )
    {
        _viewController = [controller retain];
        _delegate = (id<BHWeiboHelperDelegate>)controller;
        
        [self initWeiboApis];
    }
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE(_viewController);
    SAFE_RELEASE(sinaWeiboEngine);
    SAFE_RELEASE(tcWeiboEngine);
    [super dealloc];
}

- (BOOL)sinaWeiboIsLoggedIn
{
    return [sinaWeiboEngine isLoggedIn] && ![sinaWeiboEngine isAuthorizeExpired];
}

- (BOOL)tcWeiboIsLoggedIn
{
    return [tcWeiboEngine isLoggedIn] && ![tcWeiboEngine isAuthorizeExpired];
}

- (void)logInSinaWeibo
{
    if ( ![self sinaWeiboIsLoggedIn] )
    {
        [sinaWeiboEngine logIn];
    }
}

- (void)logInTCWeibo
{
    if ( ![self tcWeiboIsLoggedIn] )
    {
        [tcWeiboEngine logInWithDelegate:self
                               onSuccess:@selector(handleTCWBSuccess:)
                               onFailure:@selector(handleTCWBFailure:)];
    }
}

- (void)shareSinaWeibo:(NSString *)content andImage:(UIImage *)image
{
    SAFE_RELEASE(_content);
    _content = [content retain];
    
    SAFE_RELEASE(_image);
    _image = [image retain];
    
    if ( ![self sinaWeiboIsLoggedIn] )
    {
        [sinaWeiboEngine logIn];
    }
    else
    {
        [sinaWeiboEngine sendWeiBoWithText:content image:image];
    }
}

- (void)shareTCWeibo:(NSString *)content andImage:(UIImage *)image
{
    SAFE_RELEASE(_content);
    _content = [content retain];
    
    SAFE_RELEASE(_image);
    _image = [image retain];
    
    if ( ![self tcWeiboIsLoggedIn] )
    {
        [tcWeiboEngine logInWithDelegate:self
                               onSuccess:@selector(handleTCWBSuccess:)
                               onFailure:@selector(handleTCWBFailure:)];
    }
    else
    {
        [tcWeiboEngine postPictureTweetWithFormat:@"json"
                                          content:content
                                         clientIP:nil
                                              pic:UIImageJPEGRepresentation(image, 0.5)
                                   compatibleFlag:nil
                                        longitude:nil
                                      andLatitude:nil
                                      parReserved:nil
                                         delegate:self
                                        onSuccess:@selector(handlePostDataSuccess:)
                                        onFailure:@selector(handlePostDataFaild:)];
    }
}


#pragma mark -
#pragma mark private methods

- (void)initWeiboApis
{
    // 新浪微博
    sinaWeiboEngine = [[WBEngine alloc] initWithAppKey:kSinaAppKey appSecret:kSinaAppSecret];
    [sinaWeiboEngine setRedirectURI:kSinaAppRedirectURI];
    [sinaWeiboEngine setRootViewController:_viewController];
    [sinaWeiboEngine setDelegate:self];
    [sinaWeiboEngine setIsUserExclusive:YES];
    
    // 腾讯微博
    tcWeiboEngine = [[TCWBEngine alloc] initWithAppKey:kTCWBAppKey andSecret:kTCWBAppSecret andRedirectUrl:kTCWBAppRedirectURI];
    [tcWeiboEngine setRootViewController:_viewController];
}


#pragma mark - 新浪微博回调

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    NSLog(@"[新浪微博]已登录");
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    NSLog(@"[新浪微博]登录成功");
    if ( [_delegate respondsToSelector:@selector(weiboHelperSinaWeiboLoggedIn:)] )
    {
        [_delegate weiboHelperSinaWeiboLoggedIn:self];
    }
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"[新浪微博]登录失败");
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    NSLog(@"[新浪微博]未鉴权");
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    NSLog(@"[新浪微博]鉴权失效");
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    NSLog(@"[新浪微博]分享失败.ERROR:%@", error);
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSLog(@"[新浪微博]分享成功");
}


#pragma mark - 腾讯微博回调

- (void)handleTCWBSuccess:(NSDictionary *)info
{
    NSLog(@"[腾讯微博]登录成功");
    if ( [_delegate respondsToSelector:@selector(weiboHelperTCWeiboLoggedIn:)] )
    {
        [_delegate weiboHelperTCWeiboLoggedIn:self];
    }
}

- (void)handleTCWBFailure:(NSDictionary *)info
{
    NSLog(@"[腾讯微博]登录失败");
}

- (void)handlePostDataSuccess:(NSDictionary *)info
{
    if ([[info objectForKey:@"ret"] intValue] == 0) {
        NSLog(@"[腾讯微博]分享成功");
    } else {
        NSLog(@"[腾讯微博]分享失败");
    }
}

- (void)handlePostDataFaild:(NSDictionary *)info
{
    NSLog(@"[腾讯微博]分享失败");
}

@end
