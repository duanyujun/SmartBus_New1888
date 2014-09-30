//
//  MediaPlayerView.m
//  WSChat
//
//  Created by fengren on 13-3-31.
//  Copyright (c) 2013年 WSChat. All rights reserved.
//

#import "MediaPlayerView.h"
#import "UIControl+Create.h"
#import "NSDateFunctions.h"
#import "ProgressUtil.h"


#define ONEDAY_SECONDS 86400.0
#define ProgressEdge 140
#define PlayBtnHeight 50
@implementation MediaPlayerView
@synthesize delegate;
@synthesize isFullScreen;
@synthesize title;
@synthesize currentUrl;
@synthesize totalTimes;
@synthesize mPlayerView;
@synthesize mPlayerItem;
@synthesize mPlayer;
@synthesize mAdvertPlayerView;
@synthesize mAdvPlayer;
@synthesize loadProcessTimer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        portraitFrame = frame;
        self.backgroundColor = [UIColor blackColor];
        isFullScreen = NO;
        isPlaying = NO;
        [self initPlayView];
        [self initTop];
        [self initBottom];
        [self initSliderVolume];
        [self initProgressView];
        [self initGesture];
                
        isControlViewShow = YES;
        m_hiderTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hidController) userInfo:nil repeats:YES];
        
        //监听音量
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeChanged:)
                                                     name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                   object:nil];
        
    }
    return self;
}

-(void)removePlayerTimeObserver
{
	if (mTimeObserver)
	{
		[mPlayer removeTimeObserver:mTimeObserver];
		[mTimeObserver release];
		mTimeObserver = nil;
	}
}

- (void) deallocPlayer {
    
    if (loadProcessTimer) {
        [loadProcessTimer invalidate];
        loadProcessTimer = nil;
    }
    if (mPlayer != nil) {
        [mPlayer pause];
        [self removePlayerTimeObserver];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:mPlayerItem];
        
        [mPlayerItem removeObserver:self forKeyPath:@"status"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:mPlayer];
        [mPlayer release];
        mPlayer  = nil;
        [mPlayerItem release];
        mPlayerItem = nil;
    }
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [m_hiderTimer invalidate];
    [self  deallocPlayer];
    for (UIView * view in topView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView * view in bottomView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    
    
    [title release];
    [currentUrl release];
    [super dealloc];
}

- (void)setTitle:(NSString *)_title
{
    if (labelTitle)
    {
        labelTitle.text = _title;
    }
}
- (NSString *)title
{
    if (labelTitle)
    {
        return labelTitle.text;
    }
    else
    {
        return @"";
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)initPlayView
{
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    mPlayerView = [[[PlayerView alloc] initWithFrame:rect] autorelease];
    [self addSubview:mPlayerView];
    mPlayerView.center = self.center;
}

- (void)initTop
{
    CGSize boundsSize = self.bounds.size;
    
    CGRect backRect = CGRectMake(0, 0, boundsSize.width, 44);
    
    topView = [[[UIView alloc] initWithFrame:backRect] autorelease];
    [self addSubview:topView];
    
    topImageView = [[[UIImageView alloc] initWithFrame:backRect] autorelease];
    topImageView.image = TTIMAGE_EX(@"palyer_top.png");
    topImageView.alpha = 0.8;
    [topView addSubview:topImageView];
    
    CGFloat top = 6.0;
    
    CGFloat labelTimeWidth = 90;
//    //显示播放时间
//    CGRect labelTimeRect = CGRectMake(4, top, labelTimeWidth, 32);
//    labelTime = [[UILabel newLabel:@"" withFrame:labelTimeRect withFont:TTFONT_NAMED(@"Helvetica",10.0f)] autorelease];
//    labelTime.textAlignment = UITextAlignmentLeft;
//    labelTime.numberOfLines = 2;
//    [topView addSubview:labelTime];
    buttonBack = [UIButton newButton:flag_buttonBack withFrame:CGRectMake(4, top ,32, 32) withImage:TTIMAGE_EX(@"icon_player_back.png") withObject:self];
    [topView addSubview:buttonBack];
    //显示标题
    CGRect labelTitleRect = CGRectMake(4+labelTimeWidth+4, top, boundsSize.width-(labelTimeWidth+4+4)*2, 32);
    labelTitle = [[UILabel newLabel:@"" withFrame:labelTitleRect withFont:TTFONT_NAMED(@"Helvetica-Bold",12.0f)] autorelease];
    [topView addSubview:labelTitle];
    
    CGRect buttonRect = CGRectMake(boundsSize.width-8-32, top, 32, 32);
    buttonZoom = [UIButton newButton:flag_buttonZoom withFrame:buttonRect withImage:TTIMAGE_EX(@"player_zoom_out.png") withObject:self];
//    [topView addSubview:buttonZoom];
}

- (void)initBottom
{
    CGSize boundsSize = self.bounds.size;
    CGRect backRect = CGRectMake(0, boundsSize.height - 65-34, boundsSize.width, 65+34);
    bottomView = [[[UIView alloc]initWithFrame:backRect] autorelease];
    [self addSubview:bottomView];
    CGFloat top = 0;
    CGRect imageViewRect = CGRectMake(0, top, 334, 65);
    controllerView = [[[UIView alloc]initWithFrame:CGRectMake((boundsSize.width-334)/2.f, 0, 334, 65)] autorelease];
    bottomImageView = [[[UIImageView alloc] initWithFrame:imageViewRect] autorelease];
    bottomImageView.image = TTIMAGE_EX(@"bg_player_controllers.png");
    bottomImageView.alpha = 0.8;
    [controllerView addSubview:bottomImageView];
    [bottomView addSubview:controllerView];
    
    CGFloat buttonWidth = 32;
    CGFloat buttonHeight = 32;
//    top += 6;
    
    CGFloat left = 4;
    CGRect buttonRect = CGRectMake(left, top, buttonWidth, buttonHeight);
//    buttonBack = [UIButton newButton:flag_buttonBack withFrame:buttonRect withImage:TTIMAGE_EX(@"player_back.png") withObject:self];
//    [controllerView addSubview:buttonBack];
    
    
    left = (controllerView.frame.size.width - PlayBtnHeight)/2;
    buttonRect = CGRectMake(left, top, PlayBtnHeight, PlayBtnHeight);
    buttonPlay = [UIButton newButton:flag_buttonPlay withFrame:buttonRect withImage:TTIMAGE_EX(@"player_pauser.png") withObject:self];
    [controllerView addSubview:buttonPlay];
    
    CGFloat interval = 10;
    left  = boundsSize.width-interval-buttonWidth;
    buttonRect = CGRectMake(left, top, buttonWidth, buttonHeight);
    buttonVolume = [UIButton newButton:flag_buttonVolume withFrame:buttonRect withImage:TTIMAGE_EX(@"icon_player_speaker.png") withObject:self];
    [controllerView addSubview:buttonVolume];
    
}

//拖动声音条
- (void) volumeChange : (id) sender
{
    UISlider *slider = (UISlider *) sender;
    
    [self setVolume:slider.value];
    
}

- (void) sliderStartDrag : (id) sender
{
    [self pauseHiderTimer];//暂停定时隐藏控制页面
}

- (void) sliderEndDrag : (id) sender
{
    [self resumeHiderTimer];//恢复定时隐藏控制页面
}


- (void)setVolume:(float)newVolume
{
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:newVolume];
}
- (float)volume
{
    return [[MPMusicPlayerController applicationMusicPlayer] volume];
}
- (void)systemVolumeChanged:(NSNotification *)notification
{
    float volume =
    [[[notification userInfo]
      objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
     floatValue];
    
    sliderVolume.value = volume;
}

- (void)initSliderVolume
{
    CGRect rect = CGRectMake(229, 110, 120, 25);
    if (IS_IPHONE_5)
    {
        rect     = CGRectMake(229, 110, 120, 25);
    }
    sliderVolume = [[[UISlider alloc] initWithFrame:rect] autorelease];
    
    UIImage *tumbImage= TTIMAGE_EX(@"slider_thumb.png");
    //设置声音条
    UIImage *volumeMinImage = TTIMAGE_EX(@"slider_min.png");
    UIImage *volumeMaxImage = TTIMAGE_EX(@"slider_max.png");
    volumeMinImage=[volumeMinImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    volumeMaxImage=[volumeMaxImage stretchableImageWithLeftCapWidth:138.0 topCapHeight:0.0];
    [sliderVolume setMinimumTrackImage:volumeMinImage forState:UIControlStateNormal];
    [sliderVolume setMaximumTrackImage:volumeMaxImage forState:UIControlStateNormal];
    [sliderVolume setThumbImage:tumbImage forState:UIControlStateNormal];
    sliderVolume.minimumValue = 0.0;
    sliderVolume.maximumValue = 1.0;
    sliderVolume.continuous = YES;
    sliderVolume.value = [self volume];
    [sliderVolume setThumbImage:tumbImage forState:UIControlStateHighlighted];
    [sliderVolume setThumbImage:tumbImage forState:UIControlStateNormal];
    
    sliderVolume.transform = CGAffineTransformMakeRotation(M_PI*1.5);
    // 滑块拖动时的事件
    [sliderVolume addTarget:self action:@selector(volumeChange:) forControlEvents:UIControlEventValueChanged];
    [sliderVolume addTarget:self action:@selector(sliderStartDrag:) forControlEvents:UIControlEventTouchDown];
    [sliderVolume addTarget:self action:@selector(sliderEndDrag:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self addSubview:sliderVolume];
    sliderVolume.alpha = 0;
}


- (void)initProgressView
{
    CGSize boundsSize = self.bounds.size;
    CGRect rect = CGRectMake(12, 0, boundsSize.width-24, 24);
    progressBgContainer = [[[UIView alloc]initWithFrame:rect] autorelease];
    progressBg = [[[UIImageView alloc]initWithFrame:rect] autorelease];
    [progressBg setImage:[UIImage imageNamed:@"bg_player_progressBarBottom.png"]];
    progressBg.alpha = 0.6;
    [progressBgContainer addSubview:progressBg];
    [bottomView addSubview:progressBgContainer];
    
//    buttonSwitchProgress = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
//    [buttonSwitchProgress setImage:TTIMAGE(@"icon_player_switch.png") forState:UIControlStateNormal];
//    [buttonSwitchProgress addTarget:self action:@selector(switchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [progressBgContainer addSubview:buttonSwitchProgress];
    
    CGFloat labelTimeWidth = 90;
    //显示播放时间
    CGRect labelTimeRect = CGRectMake(4, 0, labelTimeWidth, 32);
    labelTime = [[UILabel newLabel:@"" withFrame:labelTimeRect withFont:TTFONT_NAMED(@"Helvetica",10.0f)] autorelease];
    labelTime.textAlignment = UITextAlignmentCenter;
    labelTime.numberOfLines = 2;
    [progressBgContainer addSubview:labelTime];
    
    progressContainView = [[[UIView alloc] initWithFrame:rect] autorelease];
//    [progressContainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_player_progressBarBottom.png"]]];
    
    CGRect progressRect = CGRectMake(0, 7.5, progressContainView.bounds.size.width, 9);
    progressView = [[[UIProgressView alloc] initWithFrame:progressRect] autorelease];
    UIImage *playMiniImage = [[UIImage imageNamed:@"slider_miners.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:3];
    UIImage *playMaxImage  = [[UIImage imageNamed:@"slider_maxers.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:3];
    progressView.progressImage = playMiniImage;
    progressView.trackImage = playMaxImage;
    
    progressView.progress = 0;
    
    [progressContainView addSubview:progressView];
    
    
    
    progressButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_thumber.png"]];
    
    progressButton.alpha = 1;
    progressButton.frame = CGRectMake(0, 4, 32, 32);
    progressButton.center = CGPointMake(0,progressView.center.y);
    progressButton.userInteractionEnabled = YES;
    [progressContainView addSubview: progressButton];
    
    [progressBgContainer addSubview:progressContainView];
}

- (void)initGesture
{
    //加入手指点击键盘消失
    UITapGestureRecognizer *singletap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAndShowControlView:)] autorelease];
    singletap.cancelsTouchesInView = NO;
    singletap.delegate = self;
    [singletap setNumberOfTapsRequired:1];
    [mPlayerView addGestureRecognizer:singletap];
    UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc]
                                                 
                                                 initWithTarget:self action:@selector(scale:)] autorelease];
    [pinchRecognizer setDelegate:self];
    [mPlayerView addGestureRecognizer:pinchRecognizer];
    
}

- (void)hidController
{
    if (!isHiderTimerPause)
    {
        if (isControlViewShow)
        {
            m_hiderTimerCounter ++;
            if (m_hiderTimerCounter > 5)
            {
                [self hideAndShowControlView:nil];
            }
        }
        else
        {
            
        }
    }
    
}

- (void)hideAndShowControlView:(id)sender{
    
    if (isControlViewShow) {
        //隐藏控制条和头
        [UIView animateWithDuration:0.3 animations:^{
            [topView setAlpha:0];
            [bottomView setAlpha:0];
            [self hideSlideVolume:YES];
            if (isFullScreen) {
                //[[UIApplication sharedApplication] setStatusBarHidden:YES];
            }
        }completion:^(BOOL finished){
            isControlViewShow = NO;
            m_hiderTimerCounter = 0;
            //NSLog(@"hide controller");
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            [topView setAlpha:1];
            [bottomView setAlpha:1];
            [self hideSlideVolume:YES];
            if (isFullScreen) {
                //[[UIApplication sharedApplication] setStatusBarHidden:NO];
            }
        }completion:^(BOOL finished){
            isControlViewShow = YES;
            //NSLog(@"show controller");
        }];
    }
}


-(void)scale:(UIPinchGestureRecognizer*)sender {
    
    //当手指离开屏幕
    if([sender state] == UIGestureRecognizerStateEnded) {
        CGFloat scale = [(UIPinchGestureRecognizer*)sender scale];
        NSLog(@"scale -> %f",scale);
        if (scale > 1) {
            if (!isFullScreen)
            {
                [self actionZoom];
            }
        }
        else
        {
            if (isFullScreen)
            {
                [self actionZoom];
            }
        }
        return;
    }
}

//处理按钮点击事件
- (void)touchButton:(id)sender
{
    int tag = [(UIButton *)sender tag];
    switch (tag) {
        case flag_buttonZoom:
            [self actionZoom];
            break;            
        case flag_buttonBack:
            [self actionBack];
            break;
            break;
        case flag_buttonPlay:
            [self actionPlay];
            break;
        case flag_buttonVolume:
            [self actionVolume];
            break;
            
        default:
            break;
    }
}

- (void)switchButtonClicked:(id)sender
{
    
}

- (void)resetFrame:(CGRect)frame
{
    self.frame = frame;
    CGSize boundsSize = self.frame.size;
    CGRect rect = CGRectMake(0, 0, boundsSize.width, boundsSize.height);
    mPlayerView.frame = rect;
    //top
    topView.frame = CGRectMake(0, 0, boundsSize.width, 44); 
    topImageView.frame = CGRectMake(0, 0, boundsSize.width, 44);    
    
    CGFloat labelTimeWidth = 90;
    CGFloat labelHeight = 32;
    CGFloat left = 4+labelTimeWidth+4;
    CGFloat top = 5.0;
    labelTitle.frame = CGRectMake(left, top, boundsSize.width-(labelTimeWidth+4+4)*2, labelHeight);
    buttonZoom.frame = CGRectMake(boundsSize.width-8-32, top, 32, 32);
    
    
    //bottom
    bottomView.frame = CGRectMake(0, boundsSize.height - 65-40, boundsSize.width, 65+40);
    controllerView.frame = CGRectMake((boundsSize.width-334)/2.f, 0, 334, 65);

    bottomImageView.frame = CGRectMake(0, 0, 334, 65);
    
    CGFloat buttonWidth = 32;
    CGFloat buttonHeight = 32;
    top = (bottomImageView.frame.size.height-32)/2.f;
    left = 8;
//    buttonBack.frame = CGRectMake(left, top, buttonWidth, buttonHeight);
    
    left = (controllerView.frame.size.width - PlayBtnHeight)/2;
    buttonPlay.frame = CGRectMake(left, (bottomImageView.frame.size.height-PlayBtnHeight)/2.f, PlayBtnHeight, PlayBtnHeight);
    CGFloat interval = 10;
    left = controllerView.frame.size.width-interval-buttonWidth;
    buttonVolume.frame = CGRectMake(left, top, buttonWidth, buttonHeight);
    
    if (isFullScreen)
    {
        CGRect rect = CGRectMake(435, 121, 25, 139);
        if (IS_IPHONE_5)
        {
            rect     = CGRectMake(435+88, 121, 25, 139);
        }
        sliderVolume.frame = rect;
    }
    else
    {
        CGRect rect = CGRectMake(275, 60, 25, 120);
        if (IS_IPHONE_5)
        {
            rect     = CGRectMake(275, 60, 25, 120);
        }
        sliderVolume.frame = rect;
    }
    
    
    progressBgContainer.frame = CGRectMake(-20, controllerView.frame.size.height, boundsSize.width, 40);
    progressBg.frame = progressBgContainer.bounds;
//    buttonSwitchProgress.frame = CGRectMake(5, 4, 32, 32);
    labelTime.frame = CGRectMake(progressBgContainer.frame.size.width - 90, 0, 90, 40);
    
    progressContainView.frame = CGRectMake(30, 0, progressBgContainer.bounds.size.width-140, 40);
    progressView.frame = CGRectMake(0, 14.5, progressContainView.bounds.size.width, 11.5);
    progressButton.center = CGPointMake(progressButton.center.x, progressView.center.y);
    
    CGPoint oldCenter = progressButton.center;
    CGFloat scale = 1;
    if (isFullScreen)
    {
        if (IS_IPHONE_5)
        {
            scale = (568.0-ProgressEdge)/(320.0-ProgressEdge);
        }
        else
        {
            scale = (480.0-ProgressEdge)/(320.0-ProgressEdge);
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            scale = (320.0-ProgressEdge)/(568.0-ProgressEdge);
        }
        else
        {
            scale = (320.0-ProgressEdge)/(480.0-ProgressEdge);
        }
    }
    progressButton.center = CGPointMake(oldCenter.x * scale, oldCenter.y);
}


- (CGAffineTransform)getTransform
{
    if (isFullScreen)
    {
        return CGAffineTransformMakeRotation(M_PI*0.5);
    }
    else
    {
        return CGAffineTransformIdentity;
    }
    /* UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
     if (orientation == UIInterfaceOrientationLandscapeLeft) {
     return CGAffineTransformMakeRotation(M_PI*1.5);
     } else if (orientation == UIInterfaceOrientationLandscapeRight) {
     return CGAffineTransformMakeRotation(M_PI/2);
     } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
     return CGAffineTransformMakeRotation(-M_PI);
     } else {
     return CGAffineTransformIdentity;
     }*/
}

- (void)setIsFullScreen:(BOOL)_isFullScreen
{
    isFullScreen = _isFullScreen;
    [self hideSlideVolume:YES];
    if (isFullScreen)//全屏
    {
        
        [buttonZoom setImage:TTIMAGE_EX(@"player_zoom_in.png") forState:UIControlStateNormal];
        
        CGRect screenFrame = [UIScreen mainScreen].applicationFrame;
        
        CGPoint center = CGPointMake(ceil(screenFrame.size.width/2),ceil((screenFrame.size.height)/2));
        
        //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
        //[[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeLeft animated:YES];
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        //（获取当前电池条动画改变的时间）
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        
        //[[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
        
        [self resetFrame:CGRectMake(0, 0, screenFrame.size.height, screenFrame.size.width)];
        self.center = center;
        self.transform = [self getTransform];

//        [ProgressUtil sharedProgress]..center = self.center;
//        [ActivityIndicatorEx currentIndicator].transform = self.transform;
        [UIView commitAnimations];
    }
    else//退出全屏
    {
        [buttonZoom setImage:TTIMAGE_EX(@"player_zoom_out.png") forState:UIControlStateNormal];
        //        CGPoint center = CGPointMake(ceil(oldFrame.size.width/2),ceil(oldFrame.size.height/2));
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        self.transform = [self getTransform];
        [self resetFrame:portraitFrame];
        
//        [ActivityIndicatorEx currentIndicator].center = self.center;
//        [ActivityIndicatorEx currentIndicator].transform = self.transform;
        
        [UIView commitAnimations];
    }
}

- (void)actionZoom
{
    self.isFullScreen = !isFullScreen;
}


- (void)actionPlay
{
    if (isPlaying)
    {
        [self pausePlay];
    }
    else
    {
        [self resumePlay];
    }
}

- (void)hideSlideVolume:(BOOL)hide
{
    if (hide)
    {
        sliderVolume.alpha = 0;        
        
    }
    else
    {
        sliderVolume.alpha = 1;
    }
}

- (void)actionVolume
{
    if (sliderVolume.alpha)
    {
        [self hideSlideVolume:YES];
    }
    else
    {
        [self hideSlideVolume:NO];
    }
}


- (void)actionBack
{
//    [self dismissTips];
    [[ProgressUtil sharedProgress] hide];
    [self deallocPlayer];
    if ([self.delegate respondsToSelector:@selector(mediaPlayerViewDidReturn:)])
        [self.delegate mediaPlayerViewDidReturn:self];
}


//加载广告view
- (void)initAdvertPlayer
{
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    mAdvertPlayerView = [[PlayerView alloc] initWithFrame:rect];
    [mAdvertPlayerView setBackgroundColor:[UIColor blackColor]];
    [self addSubview:mAdvertPlayerView];
//    mAdvertPlayerView.center = self.center;
    
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"5秒" ofType:@"mp4"];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
    self->mAdvPlayer = [[AVPlayer playerWithPlayerItem:playerItem] retain];
    [mAdvertPlayerView setPlayer:mAdvPlayer];
    [mAdvertPlayerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
    [mAdvPlayer play];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playAdDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}

- (void) playAdDidEnd {
    isAdFinished = YES;
    [self->mAdvPlayer release], self->mAdvPlayer = nil;
    [mAdvertPlayerView removeFromSuperview];
    if (mPlayerView != nil) {
        if (isAdFinished) {
            [mPlayerView.player play];
        }
    
    }
}

//初始化点播
- (void)initPlayPlayer
{
    self.mPlayerItem = [AVPlayerItem playerItemWithURL:self.currentUrl];
    self.mPlayer = [AVPlayer playerWithPlayerItem:self.mPlayerItem];
    [mPlayerView setPlayer:mPlayer];
    [mPlayerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
    [self.mPlayer play];
    
    CMTime totalTime = mPlayerItem.duration;
    totalTimes = (CGFloat)totalTime.value/totalTime.timescale;
    
    //添加播放完成的notifation 执行下一条内容
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:mPlayerItem];
    
    [mPlayerItem addObserver:self
                         forKeyPath:@"status"
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        
    [self playProcessControl];  //定制进度控制条
    
    isPlaying = YES;
    [buttonPlay setImage:TTIMAGE_EX(@"player_pauser.png")  forState:UIControlStateNormal];
}

- (void)initLoadProcess
{
//    [self dismissTips];
    [[ProgressUtil sharedProgress] hide];
    [[ProgressUtil sharedProgress] showInView:self.mPlayerView];
    mloadProcessStatus = -1;
    if ([loadProcessTimer isValid]) {
        [loadProcessTimer invalidate];
    }
    loadProcessTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(checkLoad) userInfo:nil repeats:YES];
    [loadProcessTimer fire];
}

- (void)checkLoad
{
    float statue = [self availableDuration];
//    NSLog(@"statue = %f",mloadProcessStatus);
    
    if (mloadProcessStatus >= statue) {
        return;
    }
    mloadProcessStatus = statue;
    if (statue < 0) {
//        [self presentLoadingTips:@"正在连接..."];
        [[ProgressUtil sharedProgress] setMessage:@"正在链接服务器..."];
        isloading = YES;
        mloadProcessStatusCheckPoint = statue;
    }else
    {
        if (isloading) {
            
            if (statue < 5 ) {
//                [self presentLoadingTips:[NSString stringWithFormat:@"%d%%",(int)((statue)*100.f/5.f)]];
                [[ProgressUtil sharedProgress] setMessage:[NSString stringWithFormat:@"正在缓冲%d%%",(int)((statue)*100.f/5.f)]];
            }else
            {
                isloading = NO;
//                [self dismissTips];
                [[ProgressUtil sharedProgress] hide];
                if ([loadProcessTimer isValid]) {
                    [loadProcessTimer invalidate];
                    loadProcessTimer = nil;
                }
            }
        }
        /*
        else
        {
            mloadProcessCheckCount++;
            if (mloadProcessCheckCount > 10) {
                NSLog(@"check! %f",mloadProcessStatusCheckPoint);
                if (statue - mloadProcessStatusCheckPoint < 0.1f) {
                    mloadProcessStatusCheckPoint = statue;
                    NSLog(@"缓冲！");
                    isloading = YES;
                    [[ProgressUtil sharedProgress] showInView:self.mPlayerView];
                    return;
                }
                mloadProcessCheckCount = 0;
                mloadProcessStatusCheckPoint = statue;
            }
        }
         */
    }
    
}

- (NSTimeInterval) availableDuration;
{
    NSArray *loadedTimeRanges = [[self.mPlayer currentItem] loadedTimeRanges];
    if (loadedTimeRanges.count == 0) {
        return -0.1f;
    }
    CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

-(void)setViewDisplayName
{
    //Set the view title to the last component of the asset URL.
    self.title = [self.currentUrl lastPathComponent];
    
    // Or if the item has a AVMetadataCommonKeyTitle metadata, use that instead.
	for (AVMetadataItem* item in ([[[mPlayer currentItem] asset] commonMetadata]))
	{
		NSString* commonKey = [item commonKey];
		
		if ([commonKey isEqualToString:AVMetadataCommonKeyTitle])
		{
			self.title = [item stringValue];
		}
	}
}

static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;

//监听播放状态
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"keyPath %@",keyPath);
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerI = (AVPlayerItem *)object;
        if (playerI.status == AVPlayerStatusReadyToPlay)
        {
            NSLog(@"play! %f",[self availableDuration]);
//            [self dismissTips];
            [[ProgressUtil sharedProgress] hide];
            if (loadProcessTimer) {
                [loadProcessTimer invalidate];
                loadProcessTimer = nil;
            }
            
            [self hideAndShowControlView:nil];
            
        }else if(playerI.status == AVPlayerStatusUnknown)
        {
//            [self dismissTips];
            [[ProgressUtil sharedProgress] hide];
            [self removePlayerTimeObserver];
            //UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"无法播放，流地址是%@",self->currentUrl] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            //[alert show];
        }else if (playerI.status ==AVPlayerStatusFailed)
        {
            
            AVPlayerItem *playerItem = (AVPlayerItem *)object;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"播放失败..."
                                                                message:[NSString stringWithFormat:@"%@请稍后再试，您的问题我们会尽快处理。",[playerItem.error localizedDescription]]//[playerItem.error localizedFailureReason]
                                                               delegate:self
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            
//            [self dismissTips];
            [[ProgressUtil sharedProgress] hide];
            [self removePlayerTimeObserver];
            //            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"无法播放，流地址是%@",self->currentUrl] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            //            [alert show];
        }
        
        if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext)
        {
            AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
            
            /* Is the new player item null? */
            if (newPlayerItem == (id)[NSNull null])
            {
                
            }
            else /* Replacement of player currentItem has occurred */
            {
                /* Set the AVPlayer for which the player layer displays visual output. */
                [mPlayerView setPlayer:mPlayer];
                
                
                /* Specifies that the player should preserve the video’s aspect ratio and
                 fit the video within the layer’s bounds. */
                [mPlayerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
                
            }
        }
        
        
    }
}
//点播和本地播放的播放完成时
- (void) playDidEnd {
    [self actionBack];
}

- (void)resetLabelTime:(double)currentPlayTime
{
    NSString * current = [NSDateFunctions parseSecToMin:(int)ceil(currentPlayTime)];
    NSString * total = [NSDateFunctions parseSecToMin:(int)ceil(totalTimes)];
    labelTime.text = [NSString stringWithFormat:@"%@/%@",current,total];
}

#pragma 设置播放控制
//进度控制条，用于点播
- (void) playProcessControl{
    mTimeObserver = [mPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time){
        //获取当前时间
        CMTime currentTime = mPlayerItem.currentTime;
        //转成秒数
        double currentPlayTime = (double)currentTime.value/currentTime.timescale;
        
        if (totalTimes > 0 && currentPlayTime > 0)
        {
            progressView.progress = currentPlayTime/totalTimes;
            CGFloat playWidth = progressContainView.bounds.size.width;
            progressButton.center = CGPointMake(currentPlayTime/totalTimes*playWidth, progressButton.center.y);
            [self resetLabelTime:currentPlayTime];
        }
    }];
    [mTimeObserver retain];
}

- (void)startPlay
{
//    [ActivityIndicatorEx currentIndicator].center = self.center;
//    [[ActivityIndicatorEx currentIndicator] displayActivity:NSLocalizedString(@"正在加载视频...", @"")];
    [self initPlayPlayer];
}

- (void)stopPlay
{
    if (mPlayer)
        [mPlayer pause];
    
}
- (void)pausePlay
{
    if (mPlayer)
    {
        [mPlayer pause];
    }
    isPlaying = NO;
    [buttonPlay setImage:TTIMAGE_EX(@"player_runer.png")  forState:UIControlStateNormal];
    
}

- (void)resumePlay
{
    if (mPlayer)
    {
        [mPlayer play];
    }
    isPlaying = YES;
    [buttonPlay setImage:TTIMAGE_EX(@"player_pauser.png")  forState:UIControlStateNormal];
}

//暂停定时隐藏控制页面
- (void)pauseHiderTimer
{
    isHiderTimerPause = YES;
}
//恢复定时隐藏控制页面
- (void)resumeHiderTimer
{
    isHiderTimerPause = NO;
}

#pragma 进度条滑动的代理

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self pauseHiderTimer];//暂停定时隐藏控制页面
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    id touchView = [touch view];
    if ( !([touchView isKindOfClass:[UIImageView class]]) &&  touchView != progressContainView && !([touchView isKindOfClass:[UIProgressView class]])) {
        return;
    }
    
    
    CGPoint point = [touch  locationInView:progressContainView];
    //得到当前位置的比例
    CGFloat playWidth = progressContainView.bounds.size.width;
    double currentProportion = point.x / playWidth;
    
    progressView.progress = currentProportion;
    progressButton.center = CGPointMake(point.x, progressButton.center.y);
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //self.processButton.image = [UIImage imageNamed:@"进度条_btn"];
    UITouch *touch = [touches anyObject];
    id touchView = [touch view];
    if (!([touchView isKindOfClass:[UIImageView class]]) &&  touchView != progressContainView && !([touchView isKindOfClass:[UIProgressView class]])) {
        [self resumeHiderTimer];//恢复定时隐藏控制页面
        return;
    }
    
    CGPoint point = [touch  locationInView:progressContainView];
    //得到当前位置的比例
    CGFloat playWidth = progressContainView.bounds.size.width;
    double proportion = (double)point.x / playWidth;    
    CMTime time = CMTimeMake(proportion  * totalTimes, 1) ;
    [mPlayerItem seekToTime:time];
    
    [self resumeHiderTimer];//恢复定时隐藏控制页面
}

@end

