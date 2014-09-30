//
//  TCWBAuthorizeView.h
//  JstvNews
//
//  Created by kukuasir on 13-6-16.
//  Copyright (c) 2013年 kukuasir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCWBGlobalUtil.h"

@class TCWBAuthorizeView;

@protocol TCWBAuthorizeViewDelegate <NSObject>
@required
- (void)authorize:(TCWBAuthorizeView *)authorize didSucceedWithAccessToken:(NSString *)code;
- (void)authorize:(TCWBAuthorizeView *)authorize didFailuredWithError:(NSError *)error;
@end

@interface TCWBAuthorizeView : UIView<UIWebViewDelegate, UIAlertViewDelegate>
{
@private
    UIView                             *panelView;
    UIView                             *containerView;
    UIActivityIndicatorView            *indicatorView;
	UIWebView                          *webView;
    UIInterfaceOrientation             previousOrientation;
    id<TCWBAuthorizeViewDelegate>      delegate;
}

@property (nonatomic, assign) id<TCWBAuthorizeViewDelegate>   delegate;

- (void)loadRequestWithURL:(NSURL *)url;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
