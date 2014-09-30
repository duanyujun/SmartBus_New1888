//
//  JSTVPlayerViewController.m
//  WSChat
//
//  Created by fengren on 13-3-26.
//  Copyright (c) 2013年 WSChat. All rights reserved.
//

#import "JSTVPlayerViewController.h"
#import "MediaPlayerView.h"
//#import "ShareViewController.h"
#import "libSk.h"

@interface JSTVPlayerViewController ()

@end

@implementation JSTVPlayerViewController
@synthesize isFullScreen;
@synthesize playType;
@synthesize playUrls;
@synthesize currentUrl;
@synthesize imageUrl;
@synthesize epgId;
@synthesize epgData;
@synthesize totalTimes;
@synthesize delayTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        }
    return self;
}

- (void)dealloc
{
    [jstvPlayerView removeFromSuperview];
    [jstvPlayerView release];
    [playUrls release];
    [currentUrl release];
    [imageUrl release];
    [epgId release];
    [epgData release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    /*
    if (playType == LIVETYPE || playType == BACKTYPE) {
//        [[TrendMessage sharedInstance] sendUserAction:ActionTypeLive withContentId:[self.epgId integerValue]];

    } else if (playType == PLAYTYPE){
        [[TrendMessage sharedInstance] sendUserAction:ActionTypeVod withContentId:[self.epgId integerValue]];
    } else if (playType == PLAYMOVIETYPE){
        [[TrendMessage sharedInstance] sendUserAction:ActionTypeMovie withContentId:[self.epgId integerValue]];
    }
    */
    [self initJstvPlayerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES]; 
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillDisappear:animated];
}


- (void)initJstvPlayerView
{
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp4"];
    CGSize boundsSize = self.view.bounds.size;
    CGRect rect = CGRectMake(0, 0,boundsSize.width,240);
    jstvPlayerView = [[[JSTVPlayerView alloc] initWithFrame:rect withPlayType:self.playType] autorelease];
    jstvPlayerView.delegate = self;
    
    
    jstvPlayerView.title = self.title;
//    jstvPlayerView.playType = self.playType;
    jstvPlayerView.playUrls = self.playUrls;
    jstvPlayerView.isFullScreen = isFullScreen;
    jstvPlayerView.currentUrl = self.currentUrl;
    jstvPlayerView.imageUrl = self.imageUrl;
    jstvPlayerView.epgId = self.epgId;
    jstvPlayerView.epgData = self.epgData;
    //jstvPlayerView.totalTimes = self.totalTimes;
    jstvPlayerView.delayTime = self.delayTime;
    
    [self.view addSubview:jstvPlayerView];
    [jstvPlayerView startPlay];
//    [jstvPlayerView initAdvertPlayer];
    [jstvPlayerView.player play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UGXHttpRequestDelegate

- (void)handleNetworkDidStartRequestWithRequestId:(NSInteger)requestId {
    //    if (requestId == ADDCOLLECT) {
    //        [[ProgressUtil sharedProgress] showInView:self.view];
    //    }
}

- (void)handleNetworkResponseData:(id)data withRequestId:(NSInteger)requestId
{
    NSLog(@"net data-> %@",data);
    
    if (![data isKindOfClass:[NSArray class]]) {
        /*数据有误*/
        return;
    }
    

}

- (void)handleNetworkResponseFaildWithRequestId:(NSInteger)requestId {
    //    [[ProgressUtil sharedProgress] hide];
    //    [Utilities showAlert:@"请求失败,请重试" inView:self.view];
}


#pragma mark JSTVPlayerViewDelegate
- (void)playerViewDidReturn:(JSTVPlayerView*)view
{
    if (playType == LIVETYPE) {
//        [[TrendMessage sharedInstance] removeUserAction];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
- (void)playerShareButtonAction:(ShareAction)action withImgUrl:(NSString *)shareImgUrl
{
    sharevc = [[ShareViewController alloc]init];
//    sharevc.fatherVc = self;
    sharevc.shareimageurl = shareImgUrl;
    if (playType == PLAYTYPE) {
        sharevc.shareimagetype = ShareImgSingle;
    }
    else
    {
        sharevc.shareimagetype = ShareImgMuti;
    }
    
    switch (action) {
        case ShareRR:
            NSLog(@"RR");
            sharevc.sharetype = ShareRR;;
            break;
        case ShareSina:
            NSLog(@"SINA");
            sharevc.sharetype = ShareSina;
            break;
        case ShareWX:
            NSLog(@"WX");
            sharevc.sharetype = ShareWX;
            break;
        case ShareTX:
            NSLog(@"TX");
            sharevc.sharetype = ShareTX;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:sharevc animated:YES];
    [sharevc release];
    sharevc = nil;
}
*/

#pragma mark MediaPlayerViewDelegate
- (void)mediaPlayerViewDidReturn:(MediaPlayerView*)view
{
    if (playType == LIVETYPE) {
//        [[TrendMessage sharedInstance] removeUserAction];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
