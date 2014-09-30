//
//  MediaPlayerView.h
//  WSChat
//
//  Created by fengren on 13-3-31.
//  Copyright (c) 2013年 WSChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import "PlayerView.h"


enum MediaPlyer_Button_Flag
{
    flag_buttonZoom = 1000,
    flag_buttonBack,
    flag_buttonPlay,
    flag_buttonVolume
};

@protocol MediaPlayerViewDelegate;

@interface MediaPlayerView : UIView<UIGestureRecognizerDelegate>
{
    //PlayerView * playerView;
    //AVPlayer *player;
    
    //top
    UIView * topView;
    UIImageView * topImageView;
    UILabel * labelTime;//显示播放时间
    UILabel * labelTitle;//显示标题
    UIButton * buttonZoom;//zoom in,zoom out
    
    //bottom
    UIView * bottomView;
    UIView * controllerView;
    UIImageView * bottomImageView;
    UIButton * buttonBack;
    UIButton * buttonPlay;
    UIButton * buttonVolume;
    UISlider * sliderVolume;
    //进度条
    UIView *progressBgContainer;
    UIImageView *progressBg;
    UIView * progressContainView;
    UIProgressView  *progressView;
    UIImageView * progressButton;
    
    UIButton * buttonSwitchProgress;//切换时间段
    CGRect portraitFrame;
    
    BOOL isControlViewShow;
    NSTimer *m_hiderTimer;
    int m_hiderTimerCounter;
    BOOL isHiderTimerPause;
    
    BOOL isPlaying;
    
    BOOL isProgressSwitch;
    id mTimeObserver;
    
    BOOL isAdFinished;
    
    NSTimer *loadProcessTimer;
    float mloadProcessStatus;
    int mloadProcessCheckCount;//监听缓冲计数
    float mloadProcessStatusCheckPoint;
    BOOL isloading;
}

@property (readwrite, retain, setter=setPlayer:, getter=player) AVPlayer* mPlayer;
@property (readwrite, retain, setter=setPlayer:, getter=player) AVPlayer* mAdvPlayer;
@property (retain) AVPlayerItem* mPlayerItem;
@property (nonatomic, retain) PlayerView *mPlayerView;
@property (nonatomic, retain) PlayerView *mAdvertPlayerView;

@property (nonatomic, assign) id <MediaPlayerViewDelegate> delegate;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSURL *currentUrl;
@property (nonatomic, assign) double totalTimes;


@property (nonatomic, retain)NSTimer *loadProcessTimer;

- (void)initBottom;
- (void)initTop;
- (void)resetFrame:(CGRect)frame;
- (void)hideAndShowControlView:(id)sender;
//暂停定时隐藏控制页面
- (void)pauseHiderTimer;
//恢复定时隐藏控制页面
- (void)resumeHiderTimer;
- (CGAffineTransform)getTransform;

- (void)actionZoom;
- (void)actionBack;
- (void)actionPlay;
- (void)actionVolume;

- (void) playProcessControl;
- (void) initPlayPlayer;
- (void) initAdvertPlayer;
- (void)startPlay;
- (void)stopPlay;
- (void)pausePlay;
- (void)resumePlay;
- (void)initLoadProcess;

- (void) deallocPlayer ;

@end

@protocol MediaPlayerViewDelegate <NSObject>

@optional

- (void)mediaPlayerViewDidReturn:(MediaPlayerView*)view;


@end
