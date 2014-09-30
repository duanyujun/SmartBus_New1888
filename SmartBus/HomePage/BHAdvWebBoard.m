//
//  BHAdvWebBoard.m
//  SmartBus
//
//  Created by launching on 13-12-4.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAdvWebBoard.h"

@interface BHAdvWebBoard ()<UIWebViewDelegate>
{
    BeeUIWebView *_webView;
}
@end

@implementation BHAdvWebBoard

@synthesize urlString = _urlString;

- (void)unload
{
    SAFE_RELEASE(_urlString);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_home.png"] title:@"广告"];
        
        _webView = [[BeeUIWebView alloc] initWithFrame:CGRectZero];
        _webView.scalesPageToFit = YES;
//		[_webView setDelegate:self];
		[self.beeView addSubview:_webView];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_webView);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_webView.frame = self.beeView.bounds;
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        _webView.url = [_urlString trim];
	}
}

- (void)handleMenu
{
    if ( self.mode == AdvLaunchingMode_Launch )
    {
        self.splashView.adShow = NO;
        [self.splashView hide];
    }
    else
    {
        [self.stack popBoardAnimated:YES];
    }
}


//#pragma mark -
//#pragma mark UIWebViewDelegate
//
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    [self presentLoadingTips:@"正在加载..."];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [self dismissTips];
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    NSLog(@"[ERROR]%@", [error localizedDescription]);
//    [self dismissTips];
//}

@end
