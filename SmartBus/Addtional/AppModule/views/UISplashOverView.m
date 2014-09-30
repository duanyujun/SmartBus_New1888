//
//  UISplashOverView.m
//  SmartBus
//
//  Created by launching on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "UISplashOverView.h"
#import "SDWebImageManager.h"
#import "BHAdvWebBoard.h"
#import "BHAppHelper.h"

@interface UISplashOverView ()<SDWebImageManagerDelegate>
{
    UIWindow *splashWindow;
    UIImageView *overImageView;
    id<UISplashOverViewDelegate> _delegate;
    NSString *advUrl;
}
@end

#define kOverImageViewHeight  380.f+(IS_IPHONE_5?88.f:0.f)
//#define kOverImageViewHeight  380.f

@implementation UISplashOverView

@synthesize progressView = _progressView;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(splashWindow);
    SAFE_RELEASE_SUBVIEW(overImageView);
    SAFE_RELEASE_SUBVIEW(_progressView);
    _delegate = nil;
    [super dealloc];
}

- (id)initWithDelegate:(id<UISplashOverViewDelegate>)delegate
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    if (self = [super initWithFrame:frame])
    {
        _delegate = delegate;
        
        self.backgroundColor = RGB(237.f, 237.f, 232.f);
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:TTIMAGE(IS_IPHONE_5?@"Default-568h.png":@"Default.png")];
        bgImageView.frame = self.bounds;
        [self addSubview:bgImageView];
        [bgImageView release];
        
        // 广告图片
        CGRect rc = self.bounds;
        rc.size.height = kOverImageViewHeight;
        overImageView = [[UIImageView alloc] initWithFrame:rc];
        overImageView.userInteractionEnabled = YES;
        overImageView.contentMode = UIViewContentModeScaleAspectFill;
        overImageView.alpha = 0;
        [self addSubview:overImageView];
        [self bringSubviewToFront:overImageView];
        
        // 加载进度
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0.f, overImageView.height, 0.f, 3.f)];
        [_progressView setBackgroundColor:[UIColor brownColor]];
        [overImageView addSubview:_progressView];
        
        // 添加版本号显示
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(260., 444.+(IS_IOS7?88.:0.), 40., 16.)];
        versionLabel.backgroundColor = [UIColor clearColor];
        versionLabel.font = TTFONT_SIZED(12);
        versionLabel.text = [NSString stringWithFormat:@"v%@", IosAppVersion];
        [self addSubview:versionLabel];
        [versionLabel release];
    }
    return self;
}

- (id)init
{
    return [self initWithDelegate:nil];
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    self.adShow = YES;
    
    [BHAppHelper submitAdvInfoById:self.adid andType:1];
    
    BHAdvWebBoard *vc = [BHAdvWebBoard alloc];
    vc.urlString = advUrl;
    vc.mode = AdvLaunchingMode_Launch;
    vc.splashView = self;
    vc.view.frame = vc.bounds;
    [self addSubview:vc.view];
}

#pragma mark - public methods

- (void)show
{
    // 创建一个高优先级的window,加载启动画面
    splashWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    splashWindow.backgroundColor = [UIColor clearColor];
    splashWindow.windowLevel = UIWindowLevelAlert;
    [splashWindow makeKeyAndVisible];
    
    [splashWindow addSubview:self];
    overImageView.alpha = 0;
    
    [UIView animateWithDuration:1 animations:^{
        overImageView.alpha = 1;
    }];
}

- (void)hide
{
    if (self.adShow) {
        return;
    }
    
    if ( [_delegate respondsToSelector:@selector(splashOverViewDidFinishLoading:)] )
    {
        [_delegate splashOverViewDidFinishLoading:self];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        splashWindow.alpha = 0.f;
    } completion:^(BOOL finished) {
        
        if ( finished )
        {
            // 设置KEY_WINDOW
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.window makeKeyWindow];
            
            [self removeFromSuperview];
            [splashWindow removeFromSuperview];
        }
        
    }];
}

- (void)setOverImageWithURL:(NSURL *)url withAdvUrl:(NSString *)adurl
{
    advUrl = adurl;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    if ( url ) {
        [manager downloadWithURL:url delegate:self options:0];
    }
}


#pragma mark - SDWebImageManagerDelegate

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [overImageView setImage:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [overImageView addGestureRecognizer:tap];
    [tap release];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    // 下载失败,直接隐藏启动页面
    //[self hide];
}


@end
