//
//  BHAboutBoard.m
//  SmartBus
//
//  Created by launching on 13-11-26.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAboutBoard.h"
#import "BHLaunchHelper.h"
#import "BHLaunchModel.h"

@interface BHAboutBoard ()
{
    BHLaunchHelper *_launchHelper;
    BOOL _hasUpdated;  // 是否有更新
}
- (void)addApplicationInfo;
- (void)addUpdateTips;
- (void)addStatement;
- (void)addUpdateIndicator:(BOOL)update;
- (void)addCopyright;
@end

#define kUpdateBtnTag  512047

@implementation BHAboutBoard

DEF_SIGNAL( UPDATE );

- (void)load
{
    _launchHelper = [[BHLaunchHelper alloc] init];
    [_launchHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_launchHelper removeObserver:self];
    SAFE_RELEASE(_launchHelper);
    [super unload];
}

- (void)handleMenu
{
    [_launchHelper removeObserver:self];
    SAFE_RELEASE(_launchHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_setting.png"] title:@"关于"];
        
        [self addApplicationInfo];
        [self addUpdateTips];
        [self addStatement];
        [self addCopyright];
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        // 加载启动信息
        [_launchHelper getLaunchInfo];
    }
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.UPDATE] )
    {
        if ( _hasUpdated )
        {
            NSURL *iTunesURL = [NSURL URLWithString:@"https://itunes.apple.com/app/id688262741"];
            [[UIApplication sharedApplication] openURL:iTunesURL];
        }
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        [self presentLoadingTips:@"正在检查..."];
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        
        if ( [request.userInfo is:@"getLaunchInfo"] )
        {
            if ( _launchHelper.succeed )
            {
                NSString *appVersion = [BeeSystemInfo appVersion];  // 本地应用版本号
                NSString *systemVersion = [BHLaunchModel sharedInstance].version;  // 服务器上版本号
                _hasUpdated = [appVersion compare:systemVersion options:NSNumericSearch] == NSOrderedAscending;
                [self addUpdateIndicator:_hasUpdated];
            }
        }
	}
	else if ( request.failed )
	{
		[self dismissTips];
	}
}


#pragma mark -
#pragma mark private methods

- (void)addApplicationInfo
{
    UIImage *bubbleImage = [UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:bubbleImage];
    bubbleImageView.frame = CGRectMake(10.f, 10.f, 300.f, 50.f);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 7.f, 200.f, 20.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_SIZE(15);
    label.text = @"应用版本";
    [bubbleImageView addSubview:label];
    [label release];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 27.f, 200.f, 16.f)];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.font = FONT_SIZE(12);
    versionLabel.textColor = [UIColor lightGrayColor];
    versionLabel.text = [NSString stringWithFormat:@"v%@", [BeeSystemInfo appVersion]];
    [bubbleImageView addSubview:versionLabel];
    [versionLabel release];
    
    [self.beeView addSubview:bubbleImageView];
    [bubbleImageView release];;
}

- (void)addUpdateTips
{
    BeeUIButton *button = [BeeUIButton new];
    button.frame = CGRectMake(10.f, 70.f, 300.f, 44.f);
    button.tag = kUpdateBtnTag;
    button.backgroundImage = [UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)];
    [button addSignal:self.UPDATE forControlEvents:UIControlEventTouchUpInside];
    [self.beeView addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 2.f, 200.f, 40.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_SIZE(15);
    label.text = @"检查更新";
    [button addSubview:label];
    [label release];
}

- (void)addStatement
{
    BeeUIButton *button = [BeeUIButton new];
    button.frame = CGRectMake(10.f, 124.f, 300.f, 44.f);
    button.backgroundImage = [UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)];
    //[button addSignal:self.STATEMENT forControlEvents:UIControlEventTouchUpInside];
    [self.beeView addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 2.f, 200.f, 40.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_SIZE(15);
    label.text = @"合作声明";
    [button addSubview:label];
    [label release];
}

- (void)addUpdateIndicator:(BOOL)update
{
    BeeUIButton *button = (BeeUIButton *)[self.beeView viewWithTag:kUpdateBtnTag];
    
    NSString *tips = update ? @"New" : @"无更新";
    CGSize size = [tips sizeWithFont:FONT_SIZE(15) byWidth:200];
    size.width += 10.f;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(290.f-size.width, 10.f, size.width, 24.f)];
    label.backgroundColor = update ? [UIColor flatRedColor] : [UIColor clearColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 3.f;
    label.font = FONT_SIZE(15);
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = update ? [UIColor whiteColor] : [UIColor darkGrayColor];
    label.text = tips;
    [button addSubview:label];
    [label release];
}

- (void)addCopyright
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25.f, 180.f, 270.f, 34.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = BOLD_FONT_SIZE(14);
    label.text = @"南京公共交通（集团）有限公司";
    label.numberOfLines = 0;
    [self.beeView addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(25.f, 204.f, 270.f, 16.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_SIZE(14);
    label.text = @"版权所有";
    [self.beeView addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(25.f, 242.f, 270.f, 16.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_SIZE(14);
    label.text = @"数据提供";
    [self.beeView addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(25.f, 258.f, 270.f, 16.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = BOLD_FONT_SIZE(14);
    label.text = @"南京智慧交通信息有限公司";
    [self.beeView addSubview:label];
    [label release];
}

@end
