//
//  JSTVPlayerViewController.h
//  WSChat
//
//  Created by fengren on 13-3-26.
//  Copyright (c) 2013年 WSChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTVPlayerView.h"

@class ShareViewController;

@interface JSTVPlayerViewController : BeeUIBoard
<JSTVPlayerViewDelegate,MediaPlayerViewDelegate>
{
    JSTVPlayerView * jstvPlayerView;
    ShareViewController *sharevc;
}
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) PlayType playType;
@property (nonatomic, retain) NSArray * playUrls;//包含自动、流畅、标清、高清
@property (nonatomic, retain) NSURL *currentUrl;//当前播放的
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *epgId;//频道Id
@property (nonatomic, retain) NSDictionary *epgData;//频道数据

@property (nonatomic, assign) double totalTimes;
@property (nonatomic, assign) double delayTime;  //回放的时间戳,用于回放


@end
