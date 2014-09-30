//
//  JSTVPlayerView.h
//  WSChat
//
//  Created by fengren on 13-3-25.
//  Copyright (c) 2013年 WSChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayerView.h"
#import <MediaPlayer/MPMusicPlayerController.h>
#import "MediaPlayerView.h"
#import "NSDateFunctions.h"

enum Video_Quality {
    quality_auto,  //自动清晰度
    quality_high, //高清
    quality_standard,//标清
    quality_speed  //流畅
};

enum Button_Flag
{    
    flag_buttonEpg = flag_buttonVolume+1,
    
    flag_buttonAuto,
    flag_buttonSpeed,
    flag_buttonStandard,
    flag_buttonHigh,
    
    flag_buttonShare,
    flag_buttonChart,
    flag_buttonPlayType,
    flag_buttonLive
};



typedef enum {
    LIVETYPE,//直播
    BACKTYPE,//回看
    PLAYTYPE,//点播
    PLAYCACHETYPE,//播放本地视频
    PLAYMOVIETYPE
}PlayType;


@protocol JSTVPlayerViewDelegate;

@interface JSTVPlayerView : MediaPlayerView<
UITableViewDataSource,
UITableViewDelegate>
{
    
    //center
    int playIndex;
    UIButton * buttonEpg;//控制显示播放列表
    BeeUITableView * epgTableView;
    int playingIndex;
    
    UIView * videoQualityView;//控制视频画质背景
    UIButton * buttonAuto;
    UIButton * buttonSpeed;
    UIButton * buttonStandard;
    UIButton * buttonHigh;
    //bottom
    
    UIButton * buttonLive;//直播按钮
    UIButton * buttonShare;
    UIButton * buttonChart;
    UIButton * buttonPlayType;
    
    NSMutableDictionary                *keys;
    
    double                      playStartTime;
    double                      playEndTime;
    double                      tempPlayStartTime;
    
    NSTimer *processIntTimer;
    
//    UIPopoverListView *poplistview;//share
    
    NSURL *pUrl; /*当前播放url*/
}

@property (nonatomic, assign) PlayType playType;
@property (nonatomic, retain) NSArray * playUrls;//包含自动、流畅、标清、高清
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *epgId;//频道Id
@property (nonatomic, retain) NSDictionary *epgData;//频道数据
@property (nonatomic, assign) double delayTime;  //回放的时间戳


- (id)initWithFrame:(CGRect)frame withPlayType:(PlayType)playtype;
@end

@protocol JSTVPlayerViewDelegate <NSObject>

@optional

- (void)playerViewDidReturn:(JSTVPlayerView*)view;
//- (void)playerView:(JSTVPlayerView*)view withZoom:(BOOL)_isFullScreen;

//- (void)playerShareButtonAction:(ShareAction)action withImgUrl:(NSString *)shareImgUrl;

@end