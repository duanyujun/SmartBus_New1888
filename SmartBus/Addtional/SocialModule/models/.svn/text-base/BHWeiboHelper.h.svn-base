//
//  BHWeiboHelper.h
//  SmartBus
//
//  Created by launching on 13-11-1.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BHWeiboHelperDelegate <NSObject>
@optional
- (void)weiboHelperSinaWeiboLoggedIn:(id)helper;
- (void)weiboHelperTCWeiboLoggedIn:(id)helper;
@end

@interface BHWeiboHelper : NSObject

AS_SINGLETON( BHWeiboHelper );

@property (nonatomic, retain) UIViewController *viewController;

- (id)initWithTarget:(id)controller;

- (BOOL)sinaWeiboIsLoggedIn;
- (BOOL)tcWeiboIsLoggedIn;

- (void)logInSinaWeibo;
- (void)logInTCWeibo;

- (void)shareSinaWeibo:(NSString *)content andImage:(UIImage *)image;
- (void)shareTCWeibo:(NSString *)content andImage:(UIImage *)image;

@end
