//
//  JSTVPlayerView.m
//  WSChat
//
//  Created by fengren on 13-3-25.
//  Copyright (c) 2013年 WSChat. All rights reserved.
//

#import "JSTVPlayerView.h"
#import "UIControl+Create.h"
#import "AppConfig.h"
#import "NSDateFunctions.h"
#import "NSString+Tool.h"
#import "libSk.h"
#import "NSData+AES128.h"

#define ONEDAY_SECONDS 86400.0

@implementation JSTVPlayerView
@synthesize playType;
@synthesize playUrls;
@synthesize imageUrl;
@synthesize epgId;
@synthesize epgData;
@synthesize delayTime;



- (id)initWithFrame:(CGRect)frame withPlayType:(PlayType)playtype
{
    self.playType = playtype;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initCenter];
        [self bringSubviewToFront:epgTableView];
                
    }
    return self;
}


- (void)dealloc
{
    //NSLog(@"jstv dealloc");
    
    
    [super dealloc];
    
}

- (void)removeFromSuperview
{
    [processIntTimer invalidate];
    [super removeFromSuperview];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */



- (void)initTop
{
    [super initTop];
    if (playType != LIVETYPE && playType != BACKTYPE) {
        [buttonZoom setHidden:YES];
    }
}

- (void)initCenter
{
    CGSize boundsSize = self.bounds.size;    
    CGFloat buttonWidth = 40;
    CGFloat buttonHeight = 52;
    CGRect buttonRect = CGRectMake(0, (boundsSize.height - buttonHeight)/2, buttonWidth, buttonHeight);
    if (playType == LIVETYPE || playType == BACKTYPE) {
        buttonEpg = [UIButton newButton:flag_buttonEpg withFrame:buttonRect withImage:TTIMAGE_EX(@"btn_list.png") withObject:self];
        [self addSubview:buttonEpg];
    }
    
    epgTableView = [[[BeeUITableView alloc] initWithFrame:CGRectMake(0, 0, 160, boundsSize.height) style:UITableViewStylePlain] autorelease];
    [epgTableView setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.8]];
    epgTableView.delegate = self;
    epgTableView.dataSource = self;
    epgTableView.alpha = 0;
    [self addSubview:epgTableView];
    
    //控制视频画质
    buttonWidth = 50;
    buttonHeight = 35;
    CGFloat left = boundsSize.width - buttonWidth - 4;
    CGFloat top = (boundsSize.height - buttonHeight * 4)/2.0;
    
    CGRect qualityRect = CGRectMake(left, top, buttonWidth, buttonHeight*4);
    videoQualityView = [[[UIView alloc] initWithFrame:qualityRect] autorelease];
//    [self addSubview:videoQualityView];
    
    left = 0;
    top = 0;
    buttonRect = CGRectMake(left, top, buttonWidth, buttonHeight);
    buttonAuto = [UIButton newButton:flag_buttonAuto withFrame:buttonRect withImage:TTIMAGE_EX(@"w01.png") withObject:self];
    [videoQualityView addSubview:buttonAuto];
    
    top += buttonHeight;
    buttonRect = CGRectMake(left, top, buttonWidth, buttonHeight);
    buttonSpeed = [UIButton newButton:flag_buttonSpeed withFrame:buttonRect withImage:TTIMAGE_EX(@"w04.png") withObject:self];
    [videoQualityView addSubview:buttonSpeed];
    
    top += buttonHeight;
    buttonRect = CGRectMake(left, top, buttonWidth, buttonHeight);
    buttonStandard = [UIButton newButton:flag_buttonStandard withFrame:buttonRect withImage:TTIMAGE_EX(@"w03.png") withObject:self];
    [videoQualityView addSubview:buttonStandard];
    
    top += buttonHeight;
    buttonRect = CGRectMake(left, top, buttonWidth, buttonHeight);
    buttonHigh = [UIButton newButton:flag_buttonHigh withFrame:buttonRect withImage:TTIMAGE_EX(@"w02.png") withObject:self];
    [videoQualityView addSubview:buttonHigh];
    
    int videoQuality = [AppConfig sharedInstance].videoQuality;
    [self initQualityButton:videoQuality];
    
    [self addSubview:videoQualityView];
    
    [videoQualityView setAlpha:0];
}

- (void)initBottom
{
    [super initBottom];
    CGSize boundsSize = controllerView.bounds.size;
    CGFloat buttonWidth = 32;
    CGFloat buttonHeight = 32;
    CGFloat top = 6;    
    CGFloat left = 4;
    CGRect buttonRect = CGRectMake(left, top, buttonWidth, buttonHeight);
    if (playType == LIVETYPE || playType == BACKTYPE) {
        buttonLive = [UIButton newButton:flag_buttonLive withFrame:buttonRect withImage:TTIMAGE_EX(@"icon_player_live.png") withObject:self];
        buttonLive.center = CGPointMake(boundsSize.width/4 - 2, buttonLive.center.y);
        [controllerView addSubview:buttonLive];
    }

    CGFloat interval = 4;
    left = boundsSize.width - (interval+buttonWidth)*4;
    buttonRect = CGRectMake(left, top, buttonWidth, buttonHeight);
    buttonShare = [UIButton newButton:flag_buttonShare withFrame:buttonRect withImage:TTIMAGE_EX(@"icon_player_share.png") withObject:self];
    buttonShare.center = CGPointMake(boundsSize.width*3.f/4.f - 2, buttonLive.center.y);
    [controllerView addSubview:buttonShare];
    
    buttonRect = CGRectMake(left, top, buttonWidth, buttonHeight);
    if (playType == LIVETYPE || playType == BACKTYPE) {
        buttonPlayType = [UIButton newButton:flag_buttonPlayType withFrame:buttonRect withImage:TTIMAGE(@"icon_player_auto.png") withObject:self];
        buttonPlayType.center = CGPointMake(boundsSize.width*3.f/4.f - 2, buttonLive.center.y);
        [controllerView addSubview:buttonPlayType];
    }
    
//    left += interval+buttonWidth;
//    buttonRect = CGRectMake(left, top, buttonWidth, buttonHeight);
//    buttonChart = [UIButton newButton:flag_buttonChart withFrame:buttonRect withImage:TTIMAGE_EX(@"player_chart.png") withObject:self];
//    [bottomView addSubview:buttonChart];
}

- (void)hideAndShowControlView:(id)sender{
    
    if (isControlViewShow) {
        //隐藏控制条和头
        [UIView animateWithDuration:0.3 animations:^{
            [topView setAlpha:0];
            [bottomView setAlpha:0];
            [buttonEpg setAlpha:0];
            [epgTableView setAlpha:0];
            //[videoQualityView setAlpha:0];
            
            [self hideSlideVolume:YES];
//            [videoQualityView setAlpha:0];
            if (self.isFullScreen) {
                //[[UIApplication sharedApplication] setStatusBarHidden:YES];
            }
        }completion:^(BOOL finished){
            isControlViewShow = NO;
            m_hiderTimerCounter = 0;
            //NSLog(@"hide controller");
        }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [topView setAlpha:1];
            [bottomView setAlpha:1];
            [buttonEpg setAlpha:1];
            //[epgTableView setAlpha:1];
//            [videoQualityView setAlpha:1];
            
            [self hideSlideVolume:YES];
            epgTableView.alpha = 0;
            buttonEpg.center = CGPointMake(buttonEpg.frame.size.width/2, buttonEpg.center.y);
            if (self.isFullScreen) {
                //[[UIApplication sharedApplication] setStatusBarHidden:NO];
            }
        }completion:^(BOOL finished){
            isControlViewShow = YES;
            //NSLog(@"show controller");
        }];
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
        case flag_buttonEpg:
            [self actionShowEpg];
            break;
        case flag_buttonAuto:
            [self actionVideoQuality:quality_auto];
            break;
        case flag_buttonSpeed:
            [self actionVideoQuality:quality_speed];
            break;
        case flag_buttonStandard:
            [self actionVideoQuality:quality_standard];
            break;
        case flag_buttonHigh:
            [self actionVideoQuality:quality_high];
            break;
        case flag_buttonBack:
            [self actionBack];
            
            break;
        case flag_buttonLive:
            [self actionLive];
            break;
        case flag_buttonPlay:
            [self actionPlay];
            break;
        case flag_buttonShare:
            [self actionShare];
            break;
        case flag_buttonChart:
            [self actionChart];
            break;
        case flag_buttonVolume:
            [self actionVolume];
            break;
        case flag_buttonPlayType:
            [self actionPlayType];
            break;
        default:
            break;
    }
}


- (void)switchButtonClicked:(id)sender
{
    NSLog(@"oyy!~");
    isProgressSwitch =! isProgressSwitch;
    [buttonSwitchProgress setImage:(!isProgressSwitch?TTIMAGE(@"icon_player_switch.png"):TTIMAGE(@"icon_player_switch_back.png")) forState:UIControlStateNormal];
    [self updateprogressView];
    [self resetProcessControl];
}

- (void)resetFrame:(CGRect)frame
{
    [super resetFrame:frame];  
    CGSize boundsSize = self.frame.size;
    
    //center
    CGFloat buttonWidth = 40;
    CGFloat buttonHeight = 52;
    buttonEpg.frame = CGRectMake(0, (boundsSize.height - buttonHeight)/2, buttonWidth, buttonHeight);
    epgTableView.frame = CGRectMake(0, 0, 160, boundsSize.height);
    //控制视频画质View
    
    buttonWidth = 50;
    buttonHeight = 35;
    CGFloat left = boundsSize.width - buttonWidth - 4;
    CGFloat top = (boundsSize.height - buttonHeight * 4)/2.0;
    videoQualityView.frame = CGRectMake(left, top, buttonWidth, buttonHeight*4);
    
    //bottom
    
    boundsSize = controllerView.frame.size;
    buttonWidth = 32;
    buttonHeight = 32;
    top = (bottomImageView.frame.size.height-32)/2.f;
    left = 8;
//    buttonBack.frame = CGRectMake(left, top, buttonWidth, buttonHeight);
    
    buttonLive.frame = CGRectMake(left, top, buttonWidth, buttonHeight);
    buttonLive.center = CGPointMake(boundsSize.width/4, buttonLive.center.y);
    
//    left = (boundsSize.width - buttonWidth)/2;
//    buttonPlay.frame = CGRectMake(left, top, buttonWidth, buttonHeight);
    
    CGFloat interval = 4;
    left = boundsSize.width - (interval+buttonWidth)*4;
    buttonShare.frame = CGRectMake(10, top, buttonWidth, buttonHeight);
    
    buttonPlayType.center = CGPointMake(boundsSize.width*3.f/4.f - 2, buttonLive.center.y);
    
    if (playType != LIVETYPE && playType != BACKTYPE) {
        buttonShare.center = CGPointMake(boundsSize.width*1.f/4.f - 2, buttonShare.center.y);
        buttonVolume.center = CGPointMake(boundsSize.width*3.f/4.f - 2, buttonShare.center.y);
//        buttonVolume.frame = CGRectMake(left, top, buttonWidth, buttonHeight);
    }
    
    
}
- (void)actionShowEpg
{
    if (epgTableView.alpha > 0) {
        
        [UIView animateWithDuration:0.1 animations:^{
            epgTableView.alpha = 0;
        }completion:^(BOOL finished){
            [UIView animateWithDuration:0.2 animations:^{
                buttonEpg.center = CGPointMake(buttonEpg.frame.size.width/2, buttonEpg.center.y);
            }completion:^(BOOL finished){
            }];
        }];
    }
    else
    {
        [self checkEPGPlayIndex];
        [UIView animateWithDuration:0.2 animations:^{
            buttonEpg.center = CGPointMake(epgTableView.frame.size.width + buttonEpg.frame.size.width/2, buttonEpg.center.y);
        }completion:^(BOOL finished){
            [UIView animateWithDuration:0.1 animations:^
            {
                epgTableView.alpha = 0.8;
            }completion:^(BOOL finished){
                [epgTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:playingIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }];
        }];
    }

}

- (void)actionLive
{
    [self initLivePlayer];
    [self.mPlayer play];
}


- (void)actionShare
{
    /*
    CGFloat xWidth = 320.f - 20.0f;
    CGFloat yHeight = 155.f;
    CGFloat yOffset = (self.bounds.size.height - yHeight)/2.0f;
    CGRect rect;
    if (self.isFullScreen) {
        rect = CGRectMake(10, yOffset, yHeight, xWidth);
    }
    else
    {
        rect = CGRectMake(10, yOffset, xWidth, yHeight);
    }
    
    poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = YES;
    [poplistview setTitle:@"分享到"];
    
    [poplistview show];
    poplistview.transform = [self getTransform];
    [poplistview release];
     */
    
}

- (void)actionChart
{
    
}

- (void)actionPlayType
{
    videoQualityView.alpha = (videoQualityView.alpha == 0? 1:0);
    if (sliderVolume.alpha == 1) {
        sliderVolume.alpha = 0;
    }
}

- (void)hideSlideVolume:(BOOL)hide
{
    if (hide)
    {
        sliderVolume.alpha = 0;
        if (playType == PLAYCACHETYPE)
        {
            videoQualityView.alpha = 0;
        }
        else
        {
            videoQualityView.alpha = 0;
        }
        
    }
    else
    {
        sliderVolume.alpha = 1;
        videoQualityView.alpha = 0;
    }
}


- (void)initQualityButton:(NSInteger)qualityType
{
    switch (qualityType) {
        case quality_auto:
        {
            [buttonAuto setImage:TTIMAGE_EX(@"x01.png") forState:UIControlStateNormal];
            [buttonSpeed setImage:TTIMAGE_EX(@"w04.png") forState:UIControlStateNormal];
            [buttonStandard setImage:TTIMAGE_EX(@"w03.png") forState:UIControlStateNormal];
            [buttonHigh setImage:TTIMAGE_EX(@"w02.png") forState:UIControlStateNormal];
            [buttonPlayType setImage:TTIMAGE(@"icon_player_auto.png") forState:UIControlStateNormal];
        }
            break;
        case quality_speed:
        {
            [buttonAuto setImage:TTIMAGE_EX(@"w01.png") forState:UIControlStateNormal];
            [buttonSpeed setImage:TTIMAGE_EX(@"x04.png") forState:UIControlStateNormal];
            [buttonStandard setImage:TTIMAGE_EX(@"w03.png") forState:UIControlStateNormal];
            [buttonHigh setImage:TTIMAGE_EX(@"w02.png") forState:UIControlStateNormal];
            [buttonPlayType setImage:TTIMAGE(@"icon_player_liuchang.png") forState:UIControlStateNormal];
        }
            break;
        case quality_standard:
        {
            [buttonAuto setImage:TTIMAGE_EX(@"w01.png") forState:UIControlStateNormal];
            [buttonSpeed setImage:TTIMAGE_EX(@"w04.png") forState:UIControlStateNormal];
            [buttonStandard setImage:TTIMAGE_EX(@"x03.png") forState:UIControlStateNormal];
            [buttonHigh setImage:TTIMAGE_EX(@"w02.png") forState:UIControlStateNormal];
            [buttonPlayType setImage:TTIMAGE(@"icon_player_biaoqing.png") forState:UIControlStateNormal];
        }
            break;
        case quality_high:
        {
            [buttonAuto setImage:TTIMAGE_EX(@"w01.png") forState:UIControlStateNormal];
            [buttonSpeed setImage:TTIMAGE_EX(@"w04.png") forState:UIControlStateNormal];
            [buttonStandard setImage:TTIMAGE_EX(@"w03.png") forState:UIControlStateNormal];
            [buttonHigh setImage:TTIMAGE_EX(@"x02.png") forState:UIControlStateNormal];
            [buttonPlayType setImage:TTIMAGE(@"icon_player_chaoqing.png") forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

- (void)actionVideoQuality:(NSInteger)qualityType
{
    [AppConfig sharedInstance].videoQuality = qualityType;
    [self initQualityButton:qualityType];
    [self startPlay];
    [self.mPlayer play];
}


- (void) getFangdaolian {
    NSURL *url = [NSURL URLWithString:@"http://streamabr.jstv.com:8080/ip.php"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:5];
    [request startSynchronous]; 
    if ([request error]) {
        NSLog(@"%@",[request error]);
    }
    keys = nil;
    NSLog(@"%@",[request responseString]);
    if ([request responseString].length > 0)
    {
        keys = [[NSMutableDictionary alloc] initWithDictionary:[request.responseString objectFromJSONString]];//[[request.responseString JSONValue] retain];
    }
    NSString *keyString = [self AESde:[keys objectForKey:@"kenc"]];
    [keys setObject:keyString forKey:@"key"];
    
}

/*解密key*/
- (NSString *)AESde:(NSString *)kenc
{
    
    NSData *data = [self stringToHexData:kenc];
    
    NSData *keyData = [self stringToHexData:@"a5d6a07eb3f43252d05fa597b3282eef"];
    NSData *ivData = [self stringToHexData:@"5af5b059b0f1f243da248b9dbafc9411"];
    data = [data AES128Operation:kCCDecrypt keyData:keyData keyData:ivData];
    
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return [string autorelease];
}

- (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[[NSScanner alloc] initWithString:hexCharStr] autorelease];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
}

- (NSData *) stringToHexData:(NSString *)hexString
{
    int len = [hexString length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [hexString length] / 2; i++) {
        byte_chars[0] = [hexString characterAtIndex:i*2];
        byte_chars[1] = [hexString characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}
//需要从epg中获取，此处测试专用
- (void) getStartAndEndTime {
    int i = 0;
    for (NSDictionary *lineData in [self->epgData valueForKey:@"epg"]) {
        // double currentSecs = [self getCurrentSec];
        
        double epgSecs = [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue] +
        [NSDateFunctions getSecFormMinAndSec :[lineData valueForKey:@"epg_time"]];
        
        //NSLog(@"%lf",delayTime);
        
        // NSLog(@"%lf,%d",epgSecs,[[[self getTimeIntArrayForTimeInt] objectAtIndex:0] integerValue] + [self getSecFormMinAndSec :[[[self->epgData valueForKey:@"epg"] objectAtIndex:i+1] valueForKey:@"epg_time"]]);
        
        
        
        
        //如果不是最后一个节目
        if ([(NSArray *)[self.epgData valueForKey:@"epg"] count] - 1 != i){
            if (delayTime >= epgSecs && delayTime < [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue] + [NSDateFunctions getSecFormMinAndSec :[[[self->epgData valueForKey:@"epg"] objectAtIndex:i+1] valueForKey:@"epg_time"]]) {
                
                playStartTime = epgSecs;
                playEndTime   = [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue] + [NSDateFunctions getSecFormMinAndSec :[[[self->epgData valueForKey:@"epg"] objectAtIndex:i+1] valueForKey:@"epg_time"]];
                playIndex = i;
                return;
            }
            
        }else{
            //如果小于当前时间，就显示正在播放，否则是预约
            if (delayTime > epgSecs) {
                playStartTime = epgSecs;
                playEndTime   = [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue] + 86400.0;
                playIndex = i;
                return;
            }
            
        }
        i ++ ;
        
    }
}

- (NSURL *)getLiveTypeURL:(NSString *)urlStr
{
    NSArray *temp     = [[urlStr urlDecode] componentsSeparatedByString:@".m3u8"];
    if ([temp count]>=2)
    {
        NSString *tempUrl = [[temp objectAtIndex:0] stringByAppendingString:[temp objectAtIndex:1]];
        
        NSString *u = [libSk gen:tempUrl withKey:[self->keys valueForKey:@"key"] withIp:[self->keys valueForKey:@"ip"]];
        
        //NSArray *h = [u componentsSeparatedByString:@"?"];
        //
        NSArray *tempskArray     = [u componentsSeparatedByString:@"sk="];
        
        NSString *url = [NSString stringWithFormat:@"%@.m3u8%@&&sk=%@",[temp objectAtIndex:0],[temp objectAtIndex:1],tempskArray.count >=2? tempskArray.lastObject:u] ;
        
        
        NSURL *playUrl = [NSURL URLWithString:url];
        return playUrl;
    }
    else
    {
        return nil;
    }
    
}

//初始化直播
- (void)initLivePlayer
{
    int qualityType = [AppConfig sharedInstance].videoQuality;
    if (qualityType>3)
    {
        qualityType = 0;
    }
    [buttonLive setImage:TTIMAGE(@"icon_player_live_choose.png") forState:UIControlStateNormal];
    NSString * sCurrentUrl = [self.playUrls objectAtIndex:qualityType];
    self.delayTime = [NSDateFunctions getCurrentSec];
    //self.totalTimes = ONEDAY_SECONDS;
    //重置epg时间
    playStartTime = 0.0;
    playEndTime   = 0.0;
    [self getStartAndEndTime];
    
    [self getFangdaolian];
    if (self->keys == nil) {
        return;
    }
    pUrl = [self getLiveTypeURL:sCurrentUrl];
    //NSLog(@"%@,%@",[self->keys valueForKey:@"key"],[self->keys valueForKey:@"ip"]);
    
        
    //NSLog(@"%@",playerItem.tracks);
    if (self.mPlayer != nil) {
        [self deallocPlayer];
    }
    
    self.mPlayerItem = [AVPlayerItem playerItemWithURL:pUrl];
    self.mPlayer = [AVPlayer playerWithPlayerItem:self.mPlayerItem];
    
    [self.mPlayerView setPlayer:self.mPlayer];
//    [self.mPlayer play];
    [self.mPlayerItem addObserver:self
                                        forKeyPath:@"status"
                                           options:NSKeyValueObservingOptionNew
                                           context:nil];
    
    [self initLoadProcess];
    [self liveAndBackProcessControl];
    
    //获取当前epgData
    
//    [self getEpgList];
    
}

- (NSURL *)getBackTypeURL:(NSString *) urlStr withDelay:(double)delay
{
    NSArray *temp     = [[urlStr urlDecode] componentsSeparatedByString:@".m3u8"];
    if ([temp count]>=2)
    {
        NSString *tempUrl = [[temp objectAtIndex:0] stringByAppendingString:[temp objectAtIndex:1]];
        
        NSString *u = [libSk gen:[NSString stringWithFormat:@"%@&delay=%lf",tempUrl,delay] withKey:[self->keys valueForKey:@"key"] withIp:[self->keys valueForKey:@"ip"]];
        NSArray *tempskArray     = [u componentsSeparatedByString:@"sk="];
        
        NSString *url = [NSString stringWithFormat:@"%@.m3u8%@&delay=%lf&sk=%@",[temp objectAtIndex:0],[temp objectAtIndex:1],delay,tempskArray.count >=2? tempskArray.lastObject:u] ;
        
        
        NSURL *playUrl = [NSURL URLWithString:url];
        return playUrl;
    }
    else
    {
        return nil;
    }
    
}

//初始化回播
- (void)initBackPlayPlayer:(double) delay
{
    [buttonLive setImage:TTIMAGE(@"icon_player_live.png") forState:UIControlStateNormal];
    //双重判断,如果值大于现在
    if(delay > [NSDateFunctions getCurrentSec])
    {
//        [[ActivityIndicatorEx currentIndicator] hide];
        return;
    }
    int qualityType = [AppConfig sharedInstance].videoQuality;
    if (qualityType>3)
    {
        qualityType = 0;
    }
    NSString * sCurrentUrl = [self.playUrls objectAtIndex:qualityType];
    
    self.delayTime = delay;
    
    //重置epg时间
    playStartTime     = 0.0;
    playEndTime       = 0.0;
    [self getStartAndEndTime];    
    //计算相距于目前的时间
    delay = ABS([NSDateFunctions getCurrentSec] - delay) ;
    
    [self getFangdaolian];
    
    if (self->keys == nil) {
        return;
    }
    
    pUrl = [self getBackTypeURL:sCurrentUrl withDelay:delay];
    
    //NSLog(@"%@",playerItem.tracks);
    if (self.mPlayer != nil) {
        [self deallocPlayer];
    }
    NSLog(@"playUrl -> %@",pUrl);
    
    self.mPlayerItem = [AVPlayerItem playerItemWithURL:pUrl];
    self.mPlayer = [AVPlayer playerWithPlayerItem:self.mPlayerItem];
    
    [self.mPlayerView setPlayer:self.mPlayer];
//    [self.mPlayer play];
    [self.mPlayerItem addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    [self liveAndBackProcessControl];
    
    isPlaying = YES;
    [buttonPlay setImage:TTIMAGE_EX(@"player_pauser.png")  forState:UIControlStateNormal];
    //更新节目单
    //[self performSelector:@selector(switchPlaying) withObject:nil afterDelay:0.1];
    //log-> 1367989200.000000 vs 1367971200.000000  || delaytime = 1367978134.191526
    //1367967900.000000 vs 1367956200.000000  || delaytime = 1367956217.000000
}

- (void)initTimer
{
    if (processIntTimer) {
        if ([processIntTimer isValid]) {
            [processIntTimer invalidate];
        }
        
    }
    processIntTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                target:self
                                                              selector:@selector(updateprogressView)
                                                              userInfo:nil
                                                               repeats:YES];
    [processIntTimer fire];
}



- (void) updateprogressView
{    
    if ([NSDateFunctions getCurrentYearMonthDayInt] == [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue])
    {
        
        if (!isProgressSwitch)
        {
            progressView.progress = [NSDateFunctions getCurrentSecInday]/ONEDAY_SECONDS;
//            NSLog(@"1 -> %f",[DateFunctions getCurrentSecInday]/ONEDAY_SECONDS);
        }
        else
        {
//            double epgSecs = [[[DateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue];
            NSLog(@"2 -> %f",([NSDateFunctions getCurrentSec]-playStartTime)/(playEndTime-playStartTime));
            progressView.progress = ([NSDateFunctions getCurrentSec]-playStartTime)/(playEndTime-playStartTime);
        }
    }
    else
    {
        progressView.progress = 1;
    }
    
    [self resetLabelTimeByLiveAndBack:self.delayTime];
    //self.timeCurrentLabel.text = [self getCurrentDetailTime];
}


- (void)resetLabelTimeByLiveAndBack:(double)delay
{
    NSString * current = [NSDateFunctions getDetailTimeForTimeInt:delay];;
    NSString * total = [NSDateFunctions getCurrentDetailTime];;
    labelTime.text = [NSString stringWithFormat:@"%@/\n%@",current,total];
}

#pragma 设置播放控制
//进度控制条，用于点播
- (void) playProcessControl{
    [super playProcessControl];
}

- (void)resetProcessControl
{
    CGFloat playWidth = progressContainView.bounds.size.width;
    double dayTime = [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue];
    double x = .0f;
    if (!isProgressSwitch) {
        x = (delayTime - dayTime) / ONEDAY_SECONDS * playWidth;
    }
    else
    {
        x = (delayTime - playStartTime) / (playEndTime - playStartTime) * playWidth;
    }
    
    progressButton.center = CGPointMake(x, progressButton.center.y);
}

- (void)liveAndBackProcessControl
{
    CGFloat playWidth = progressContainView.bounds.size.width;
    double dayTime = [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue];
    double x = .0f;
    if (!isProgressSwitch) {
        x = (delayTime - dayTime) / ONEDAY_SECONDS * playWidth;
    }
    else
    {
        x = (delayTime - playStartTime) / (playEndTime - playStartTime) * playWidth;
    } 
    
    progressButton.center = CGPointMake(x, progressButton.center.y);     
    
    mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time){
        //转成秒数
        CGFloat playTime = (CGFloat)time.value/time.timescale;
        if (playTime > 0) {
            self.delayTime = self.delayTime + 1.0f;
            //[self resetLabelTimeByLiveAndBack];
            
            //计算每秒前进的像素
            CGFloat playWidth = progressContainView.bounds.size.width;
            if (progressButton.center.x<playWidth)
            {
                if (!isProgressSwitch) {
                    progressButton.center = CGPointMake(progressButton.center.x+playWidth/ONEDAY_SECONDS, progressButton.center.y);
                }
                else
                {
                    NSLog(@"log-> %f vs %f  || delaytime = %f",playEndTime,playStartTime,delayTime);
                    progressButton.center = CGPointMake(progressButton.center.x+playWidth/(playEndTime-playStartTime), progressButton.center.y);
                }
            }
            else
            {
                progressButton.center = CGPointMake(0, progressButton.center.y);
            }
            
            
           //设置EPG文字跳转
            [self getStartAndEndTime];
            if (tempPlayStartTime == 0.0) {
                tempPlayStartTime = playStartTime;
            }
            // NSLog(@"%lf,%lf",tempPlayStartTime,playStartTime);
            if (tempPlayStartTime != playStartTime) {
                [epgTableView reloadData];
                tempPlayStartTime = playStartTime;
            }
            
        }
    }];
    [mTimeObserver retain];
    
}

- (void)initViewShowByPlayType:(PlayType)type
{
    
    epgTableView.alpha = 0;
    videoQualityView.alpha = 0;
    
    switch (type) {
        case PLAYCACHETYPE:
            epgTableView.alpha = 0;
            buttonShare.alpha  = 0;
            buttonChart.alpha = 0;
            break;
        case PLAYMOVIETYPE:
        case PLAYTYPE:
            buttonSwitchProgress.alpha = 0;
            buttonEpg.alpha = 0;
            [buttonEpg setEnabled:NO];
            [buttonLive setImage:TTIMAGE(@"icon_player_live.png") forState:UIControlStateNormal];
            [buttonLive setEnabled:NO];
            break;
        default:
            break;
    }
}

- (void)initViewShowByBackType
{
    buttonPlay.enabled = YES;
}

- (void)initViewShowByLiveType
{
    buttonPlay.enabled = NO;
}

- (void)initViewShowByType:(PlayType)type
{
    if (self.playType == LIVETYPE)
    {
        [self initViewShowByLiveType];
    }
    else if (self.playType == BACKTYPE)
    {
        [self initViewShowByBackType];
    }
    else if (self.playType == PLAYTYPE)
    {
        [self initViewShowByPlayType:type];
    }
    else if (self.playType == PLAYMOVIETYPE)
    {
        [self initViewShowByPlayType:type];
    }
    else if (self.playType == PLAYCACHETYPE)
    {
        [self initViewShowByPlayType:type];
    }
}

- (void)startPlay
{
    
//    [ActivityIndicatorEx currentIndicator].center = self.center;
//    [ActivityIndicatorEx currentIndicator].transform = self.transform;
//    [[ActivityIndicatorEx currentIndicator] displayActivity:NSLocalizedString(@"正在加载视频...", @"")];
    
    [self initViewShowByType:self.playType];
    if (self.playType == LIVETYPE)
    {
        [self initLivePlayer]; //初始化直播播放器
        [self initTimer];//初始化定时器
        [self initLoadProcess];
    }
    else if (self.playType == BACKTYPE)
    {
        [self initBackPlayPlayer:self.delayTime];
        [self initTimer];
        [self initLoadProcess];
    }
    else if (self.playType == PLAYTYPE)
    {
        [self initPlayPlayer]; //初始化点播播放器
    }
    else if (self.playType == PLAYMOVIETYPE)
    {
        [self initPlayPlayer]; //初始化点播播放器
    }
    else if (self.playType == PLAYCACHETYPE)
    {
        [self initPlayPlayer]; //初始化点播播放器
    }
    
}

- (void)checkEPGPlayIndex
{
    NSArray *tempArray = [self.epgData objectForKey:@"epg"];
    
    
    for (int i = 0; i < [tempArray count]; i++) {
        NSDictionary *dic = [tempArray objectAtIndex:i];
        double epgSecs = [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue] +
        [NSDateFunctions getSecFormMinAndSec :[dic valueForKey:@"epg_time"]];
        if (i + 1 >= tempArray.count) {
            playingIndex =  i;
            return;
        }
        else
        {
            if (delayTime >= epgSecs && delayTime < [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue] + [NSDateFunctions getSecFormMinAndSec :[[tempArray objectAtIndex:i+1] valueForKey:@"epg_time"]]) {
                NSLog(@"%d",[[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue] + [NSDateFunctions getSecFormMinAndSec :[[tempArray objectAtIndex:i+1] valueForKey:@"epg_time"]]);
                playingIndex =  i;
                return;
                
            }
        }
        
    }
}

#pragma tableview delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)[self.epgData objectForKey:@"epg"] count];
}

- (NSString*) tableView: (UITableView*)tableView titleForHeaderInSection: (NSInteger)section{
    return @"";
}


- (UITableViewCell *) tableView: (UITableView*)tableView cellForRowAtIndexPath: (NSIndexPath*)indexPath {
    static NSString *dentifier = @"epgCell" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dentifier] autorelease];
    }
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    NSArray *tempArray = [self.epgData objectForKey:@"epg"];
    NSDictionary *dic = [tempArray objectAtIndex:[indexPath row]];
    UIColor *color = [UIColor whiteColor];

    double currentSecs = [NSDateFunctions getCurrentSec];
    
    double epgSecs = [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue] +
    [NSDateFunctions getSecFormMinAndSec :[dic valueForKey:@"epg_time"]];
    //如果不是最后一个节目
    if ([(NSArray *)[self->epgData valueForKey:@"epg"] count] - 1 != indexPath.row){
        //如果当前时间小于开播时间
        if (delayTime < epgSecs) {
            if (currentSecs < epgSecs) {
                color = [UIColor grayColor];
            }else{
//                color = [UIColor ]
            }
        }
        
        //如果处于播放和下个节目播放之间 就显示正在播放
        else if (delayTime >= epgSecs && delayTime < [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue] + [NSDateFunctions getSecFormMinAndSec :[[tempArray objectAtIndex:indexPath.row+1] valueForKey:@"epg_time"]]) {
            // NSLog(@"%lf,%lf",delayTime,epgSecs);
            color = [UIColor redColor];
            playingIndex =  indexPath.row;
            
        }
        //当前时间大于epg时间并且
        else {
            
        }
        //没有的话就显示正在播放
    }else{
        //如果小于当前时间，就显示正在播放，否则是预约
        if (delayTime > epgSecs) {
            color = [UIColor redColor];
            
        }else {
            if (epgSecs > currentSecs) {
                color = [UIColor grayColor];
            }else {
                color = [UIColor whiteColor];
            }
        }
    }
    
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setText:[[dic objectForKey:@"epg_name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [titleLbl setTextColor:color];
    [titleLbl setFont:[UIFont systemFontOfSize:14]];
    [cell.contentView addSubview:titleLbl];
    [titleLbl release];
    
    UILabel *timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 50, 40)];
    [timeLbl setBackgroundColor:[UIColor clearColor]];
    [timeLbl setText:[[dic objectForKey:@"epg_time"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [timeLbl setTextColor:color];
    [timeLbl setFont:[UIFont systemFontOfSize:14]];
    [cell.contentView addSubview:timeLbl];
    [timeLbl release];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (playIndex >= [indexPath row]) {
        NSArray *tempArray = [self.epgData objectForKey:@"epg"];
        NSDictionary *dic = [tempArray objectAtIndex:[indexPath row]];
        
        self.delayTime = [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue]+[NSDateFunctions getSecFormMinAndSec:[dic objectForKey:@"epg_time"]];
        NSLog(@"time ->%@ VS %lf",[dic objectForKey:@"epg_time"],self.delayTime);
        self.playType = BACKTYPE;
        [self startPlay];
        [self.mPlayer play];
//        [self initAdvertPlayer];
        [tableView reloadData];
    }
}

#pragma 进度条滑动的代理

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
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
    
    if (playType == LIVETYPE || playType == BACKTYPE)
    {
        //计算可以划的x坐标
        double proportion = [NSDateFunctions getCurrentSecInday]/ONEDAY_SECONDS;
        double x = proportion * playWidth ;
        if (x > playWidth) {
            x = playWidth;
        }
        //得到滑动到的秒数
        double seconds = currentProportion * (isProgressSwitch?(playEndTime - playStartTime):ONEDAY_SECONDS);
        if (isProgressSwitch) {
            seconds += playStartTime;
        }else
        {
            seconds = seconds + [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue];//年月日时间戳+当前滑动的秒数
        }
        
        if (progressView.progress >= 1) {
            if (point.x < 0 || point.x > playWidth) {
                return;
            }
        }else
        {
            if (point.x < 0 || point.x >= x) {
                return;
            }
        }
//        if (x >= point.x || progressView.progress >= 1)
        {
            //self.timeShowLabel.alpha = 1;
            //self.timeShowLabel.text = [self getDetailTimeForTimeInt:seconds];
            
            [self resetLabelTimeByLiveAndBack:seconds];
            progressButton.center = CGPointMake(point.x, progressButton.center.y);
        }
        //isHuadong = YES;
    }
    else
    {
        progressView.progress = currentProportion;
        progressButton.center = CGPointMake(point.x, progressButton.center.y);
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //self.processButton.image = [UIImage imageNamed:@"进度条_btn"];
    UITouch *touch = [touches anyObject];
    id touchView = [touch view];
    /*if (touchView == containView)
    {
        [self hideAndShowControlView:nil];
        [self resumeHiderTimer];//恢复定时隐藏控制页面
        return;
    }*/
    if (!([touchView isKindOfClass:[UIImageView class]]) &&  touchView != progressContainView && !([touchView isKindOfClass:[UIProgressView class]]))
    {
        [self resumeHiderTimer];//恢复定时隐藏控制页面
        return;
    }
    
    CGPoint point = [touch  locationInView:progressContainView];
    //得到当前位置的比例
    CGFloat playWidth = progressContainView.bounds.size.width;
    double proportion = (double)point.x / playWidth;    
    
    if (playType == LIVETYPE || playType == BACKTYPE)
    {
        NSLog(@"touchesEnded!");
        CGPoint point = [touch  locationInView:progressContainView];
        //得到当前位置的比例
        CGFloat playWidth = progressContainView.bounds.size.width;
        double currentProportion = point.x / playWidth;
        
        //计算可以划的x坐标
        double proportion = [NSDateFunctions getCurrentSecInday]/ONEDAY_SECONDS;
        
        double x = proportion * playWidth ;
        //得到滑动到的秒数
        double seconds = currentProportion * (isProgressSwitch?(playEndTime - playStartTime):ONEDAY_SECONDS);
        if (isProgressSwitch) {
            seconds += playStartTime;
        }else
        {
            seconds = seconds + [[[NSDateFunctions getTimeIntArrayForTimeInt:self.delayTime] objectAtIndex:0] integerValue];//年月日时间戳+当前滑动的秒数
        }
        
        
        if (x >= point.x || progressView.progress == 1) {
            //self.timeShowLabel.alpha = 1;
            //self.timeShowLabel.text = [self getDetailTimeForTimeInt:seconds];
            [self resetLabelTimeByLiveAndBack:seconds];
            progressButton.center = CGPointMake(point.x, progressButton.center.y);
            
            //
            self.delayTime = seconds;
            NSLog(@"time ->VS %lf",self.delayTime);
            self.playType = BACKTYPE;
            [self startPlay];
            [self.mPlayer play];
            [epgTableView reloadData];
        }
    }
    else
    {
        CMTime time = CMTimeMake(proportion  * self.totalTimes, 1) ;
        [self.mPlayerItem seekToTime:time];
    }
    [self resumeHiderTimer];//恢复定时隐藏控制页面
}

#pragma mark - getEPGList


- (void)getEpgList
{
//    NSString *urlString = [NSString stringWithFormat:@"%@lexiang/rest/api/channel",LXPROHOST];
//    UGXHttpRequest *request = [UGXHttpRequest sharedInstance];
//    [request cancelHttpRequest];
//    request.delegate = self;
//    //    [request startHttpRequest:[NSURL URLWithString:urlString]];
//    NSDictionary *pDic = [NSDictionary dictionaryWithObjectsAndKeys:@"queryepg",@"flag",[DateFunctions getCurrentYearMonthDay],@"epgdata",epgId,@"channelid", nil];
//    [request submitHTTPRequestForData:pDic withURL:[NSURL URLWithString:urlString]];
}

#pragma mark - UGXHttpRequestDelegate

- (void)handleNetworkDidStartRequest {
    
}

- (void)handleNetworkResponseData:(id)data withRequestId:(NSInteger)requestId
{
    NSLog(@"data -> %@",data);
    self.epgData = [data lastObject];
    [self checkEPGPlayIndex];
    [epgTableView reloadData];
    if (playType == LIVETYPE || playType == BACKTYPE)
    {
        /*
        NSMutableArray *epgArray = [self.epgData objectForKey:@"epg"];
        playIndex = [DateFunctions GetNowTimeIndex:epgArray];
        if ([epgArray count] > 0) {
            if (playIndex + 3 < [epgArray count]) {
                [epgTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:playIndex+3 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                
            }
            else {
                [epgTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[epgArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
         */
    }
    
}

- (void)handleNetworkResponseFaildWithRequestId:(NSInteger)requestId {
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

/*
#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] autorelease];
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    ShareView *SV = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, 320, 115)];
    SV.delegate = self;
    
    [cell.contentView addSubview:SV];
//    SV.center =  cell.contentView.center;
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s : %d", __func__, indexPath.row);
    // your code here
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115.f;
}
*/
#pragma mark - WEIBODelegate
/*
- (void)ShareButtonAction:(ShareAction)action
{
    [poplistview dismiss];
//    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",self.imageUrl,[DateFunctions getEpgScreenShotTimeForTimeInt]];
    if ([self.delegate respondsToSelector:@selector(playerShareButtonAction:withImgUrl:)]) {
        [self.delegate playerShareButtonAction:action withImgUrl:self.imageUrl];
    }
}
*/
#pragma mark- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
/*
    NSString *urlString = [NSString stringWithFormat:@"%@pushliveerror.aspx", PLAYERROHOST];
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
	[_request setTimeOutSeconds:20];
	[_request setRequestMethod:@"POST"];
	[_request setPostValue:[self->keys valueForKey:@"ip"] forKey:@"ip"];
	[_request setPostValue:[pUrl absoluteString] forKey:@"addr"];
    [_request setPostValue:[NSNumber numberWithInt:11] forKey:@"app"];
    [_request setPostValue:[NSNumber numberWithInt:0] forKey:@"plat"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [_request setPostValue:app_Version forKey:@"ver"];
    [_request setPostValue:[NSNumber numberWithBool:![ASIHTTPRequest isNetworkReachableViaWWAN]] forKey:@"net"];
    [_request startAsynchronous];
  */
}

@end
