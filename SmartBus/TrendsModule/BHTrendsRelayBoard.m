//
//  BHTrendsRelayBoard.m
//  SmartBus
//
//  Created by 王 正星 on 14-1-9.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHTrendsRelayBoard.h"
#import "BHMyGroupsBoard.h"
#import "BHTrendsHelper.h"
#import "BHWeiboHelper.h"
#import "MALocationHelper.h"
#import "BHPublishBoard.h"
#import "BHTrendsRelayInfo.h"
#import "BHChooseGroopButton.h"
#import "BHGroupModel.h"

#define kAddImageBtnTag   120121
#define kPublicBtnTag     120122
#define kToggleLabelTag   120123
#define kLocateLabelTag   120124
#define kSinaBtnTag       120125
#define kTencentBtnTag    120126

@interface BHTrendsRelayBoard ()<MALocationDelegate>
{
    UIImageView *bubbleImageView;
    BeeUITextView *_textView;
    UIView *_footerToolBar;
    UIImageView *_locateView;
    BHTrendsHelper *_postsHelper;
    BHWeiboHelper *_weiboHelper;
    MALocationHelper *_locationHelper;
    NSInteger _imageIndex;
    BHChooseGroopButton *chooseGroupButton;
    BOOL m_addCommentSameTime;
    BHGroupModel *_groupModel;
}
@end

@implementation BHTrendsRelayBoard

- (void)load
{
    _postsHelper = [[BHTrendsHelper alloc] init];
    [_postsHelper addObserver:self];
    
    _weiboHelper = [[BHWeiboHelper alloc] initWithTarget:self];
    
    _locationHelper = [[MALocationHelper alloc] initWithDelegate:self];
    _locationHelper.usingReGeocode = YES;
    
    [self observeNotification:BHMyGroupsBoard.SELECT_GROUP];
    [super load];
}

- (void)unload
{
    [_postsHelper removeObserver:self];
    SAFE_RELEASE(_postsHelper);
    SAFE_RELEASE(_weiboHelper);
    SAFE_RELEASE(_groupModel);
    [self unobserveAllNotifications];
    [super unload];
}

- (void)handleMenu
{
    [_postsHelper removeObserver:self];
    SAFE_RELEASE(_postsHelper);
    [super handleMenu];
}


ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_trends.png"] title:@"转发"];
        
        BeeUIButton *certainButton = [BeeUIButton new];
        certainButton.frame = CGRectMake(280.f, 2.f, 40.f, 40.f);
        certainButton.image = [UIImage imageNamed:@"icon_certain.png"];
        [certainButton addSignal:BHPublishBoard.PUBLISH forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:certainButton];
        
        [self addBackgroundView];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_NOTIFICATION2( BHMyGroupsBoard, notification )
{
    if ( [notification is:BHMyGroupsBoard.SELECT_GROUP] )
    {
        BHGroupModel *group = (BHGroupModel *)notification.object;
        [chooseGroupButton setGroupName:group.gpname];
        
        SAFE_RELEASE(_groupModel);
        _groupModel = [group retain];
    }
}

- (void)addBackgroundView
{
    bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:6.f topCapHeight:6.f]];
    bubbleImageView.layer.masksToBounds = YES;
    bubbleImageView.layer.cornerRadius = 4.f;
    bubbleImageView.frame = CGRectMake(10.f, 10.f, 300.f, 280.f);
    bubbleImageView.userInteractionEnabled = YES;
    [self.beeView addSubview:bubbleImageView];
    
    _footerToolBar = [[UIView alloc] initWithFrame:CGRectMake(2.f, 300.f-130.f, 296.f, 108.f)];
    _footerToolBar.backgroundColor = RGB(238.f, 238.f, 238.f);
    [bubbleImageView addSubview:_footerToolBar];
    
    [self addTextView];
    [self addRelayTargetTrends];
    [self addLocateControl];
    
    chooseGroupButton = [[BHChooseGroopButton alloc]initWithFrame:CGRectMake(10.f, 46, 60, 28.f)];
    [chooseGroupButton setGroupName:@"选择一个圈子转发"];
    [chooseGroupButton setSignal:@"chooseGroup"];
    [_footerToolBar addSubview:chooseGroupButton];
    
    [self addCommentSameTime];
}

- (void)addTextView
{
    _textView = [[BeeUITextView alloc] initWithFrame:CGRectMake(1.f, 0.f, 298.f, 100.f)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.placeholder = @"说点什么吧...";
    _textView.returnKeyType = UIReturnKeyDone;
    [bubbleImageView addSubview:_textView];
}


- (void)addLocateControl
{
    // 定位视图
    _locateView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 8.f, 35.f, 28.f)];
    _locateView.backgroundImage = [[UIImage imageNamed:@"bg_comment.png"] stretchableImageWithLeftCapWidth:14.f topCapHeight:14.f];
    [_footerToolBar addSubview:_locateView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pub_loc.png"]];
    iconImageView.frame = CGRectMake(10.f, 6.5f, 15.f, 15.f);
    [_locateView addSubview:iconImageView];
    [iconImageView release];
    
    BeeUILabel *label = [[BeeUILabel alloc] initWithFrame:CGRectMake(25.f, 6.f, 0.f, 16.f)];
    label.backgroundColor = [UIColor clearColor];
    label.tag = kLocateLabelTag;
    label.font = FONT_SIZE(12);
    label.textColor = [UIColor darkGrayColor];
    [_locateView addSubview:label];
    [label release];
    
    // 公开/隐藏切换按钮
    BeeUIButton *publicButton = [BeeUIButton new];
    publicButton.frame = CGRectMake(230.f, 8.f, 60.f, 28.f);
    publicButton.tag = kPublicBtnTag;
    publicButton.backgroundImage = [[UIImage imageNamed:@"bg_comment.png"] stretchableImageWithLeftCapWidth:14.f topCapHeight:14.f];
    [publicButton addSignal:BHPublishBoard.TOGGLE_PUBLIC forControlEvents:UIControlEventTouchUpInside];
    [_footerToolBar addSubview:publicButton];
    
    iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_public.png"]];
    iconImageView.frame = CGRectMake(10.f, 6.5f, 15.f, 15.f);
    [publicButton addSubview:iconImageView];
    [iconImageView release];
    
    label = [[BeeUILabel alloc] initWithFrame:CGRectMake(25.f, 6.f, 30.f, 16.f)];
    label.backgroundColor = [UIColor clearColor];
    label.tag = kToggleLabelTag;
    label.font = FONT_SIZE(12);
    label.textColor = [UIColor darkGrayColor];
    label.text = @"隐藏";
    [publicButton addSubview:label];
    [label release];
    
    [_locationHelper startLocating];
}

- (void)addCommentSameTime
{
    BeeUIButton *button = [[BeeUIButton alloc]initWithFrame:CGRectMake(10.f, 82.f, 20.f, 20.f)];
    [button setSignal:@"addComment"];
    [button setBackgroundImage:[UIImage imageNamed:@"icon_grey@2x.png"]];
    [_footerToolBar addSubview:button];
    [button release];
    
    NSString *tips = @"同时评论给";
    CGSize size = [tips sizeWithFont:FONT_SIZE(12) byWidth:200];
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(35.f, 82.f, size.width, 20.f)];
    [tipsLabel setBackgroundColor:[UIColor clearColor]];
    [tipsLabel setTextColor:[UIColor grayColor]];
    [tipsLabel setFont:FONT_SIZE(12.f)];
    [tipsLabel setText:tips];
    [_footerToolBar addSubview:tipsLabel];
    [tipsLabel release];
    
    UILabel *toUserLabel = [[UILabel alloc]initWithFrame:CGRectMake(35.f+size.width, 82.f, 150.f, 20.f)];
    [toUserLabel setBackgroundColor:[UIColor clearColor]];
    [toUserLabel setTextColor:[UIColor flatRedColor]];
    [toUserLabel setFont:FONT_SIZE(12.f)];
    [toUserLabel setText:self.targetTrends.user.uname];
    [_footerToolBar addSubview:toUserLabel];
    [toUserLabel release];
}

- (void)addRelayTargetTrends
{
    BHTrendsRelayInfo *info = [[BHTrendsRelayInfo alloc]initWithFrame:CGRectMake(5.f, 105.f, 290.f, 60.f)];
    [info setInfo:self.targetTrends];
    [bubbleImageView addSubview:info];
    [info release];
}


ON_SIGNAL2( BHChooseGroopButton, signal)
{
    if ([signal is:@"chooseGroup"])
    {
        BHMyGroupsBoard *board = [BHMyGroupsBoard board];
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:BHPublishBoard.PUBLISH] )
    {
        [_textView resignFirstResponder];
        
        if ( [BHUserModel sharedInstance].uid <= 0 )
        {
            BHLoginBoard *board = [BHLoginBoard board];
            BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
            [self presentViewController:stack animated:YES completion:nil];
            return;
        }
        
        if ( !_groupModel.gpid )
        {
            [self presentMessageTips:@"请选择一个圈子转发"];
            return;
        }
        
        BeeUILabel *label = (BeeUILabel *)[_locateView viewWithTag:kLocateLabelTag];
        BHTrendsModel *posts = [[BHTrendsModel alloc] init];
        posts.user.uid = [BHUserModel sharedInstance].uid;
        posts.feedid = self.targetTrends.feedid;
        posts.weibaId = _groupModel.gpid;
        posts.weiba = _groupModel.gpname;
        posts.hide = _locateView.hidden;
        posts.coor = [BHUserModel sharedInstance].coordinate;
        posts.address = label.text;
        [_postsHelper relayComment:_textView.text withTargetComment:posts];
        [posts release];
        
        // 同时评论
        if ( m_addCommentSameTime )
        {
            [_postsHelper pushComment:_textView.text
                              inRowId:self.targetTrends.feedid
                               atUser:self.targetTrends.user.uid
                                 meid:[BHUserModel sharedInstance].uid];
        }
    }
    else if ( [signal is:BHPublishBoard.TOGGLE_PUBLIC] )
    {
        [_textView resignFirstResponder];
        
        BeeUIButton *publicButton = (BeeUIButton *)[_footerToolBar viewWithTag:kPublicBtnTag];
        publicButton.selected = !publicButton.selected;
        BeeUILabel *label = (BeeUILabel *)[publicButton viewWithTag:kToggleLabelTag];
        if ( !publicButton.selected )
        {
            label.text = @"隐藏";
            _locateView.hidden = NO;
        }
        else
        {
            label.text = @"公开";
            _locateView.hidden = YES;
            [_locationHelper stopLocating];
        }
    }
    else if ([signal is:@"addComment"])
    {
        m_addCommentSameTime = !m_addCommentSameTime;
        if (m_addCommentSameTime) {
            [signal.sourceView setBackgroundImage:[UIImage imageNamed:@"icon_red@2x.png"]];
        }else
        {
            [signal.sourceView setBackgroundImage:[UIImage imageNamed:@"icon_grey@2x.png"]];
        }
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        if ( [request.userInfo is:@"relayComment"] )
        {
            [self presentLoadingTips:@"正在提交..."];
        }
    }
    else if ( request.succeed )
	{
        if ( [request.userInfo is:@"relayComment"] )
        {
            if ( _postsHelper.succeed )
            {
                [self dismissTips];
                [self presentMessageTips:@"提交成功"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
            }
            else
            {
                NSLog(@"relayComment :%@",request.responseString);
            }
        }
    }
}

- (void)dismiss
{
    [self.stack popBoardAnimated:YES];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        [self.stack popBoardAnimated:YES];
    }
}


#pragma mark -
#pragma mark MALocationDelegate

- (void)locationHelper:(MALocationHelper *)helper didFinishedReGeocode:(NSString *)address
{
    CGSize size = [address sizeWithFont:FONT_SIZE(12) byWidth:200.f];
    size.width = size.width > 200.f ? 200.f : size.width;
    
    BeeUILabel *label = (BeeUILabel *)[_locateView viewWithTag:kLocateLabelTag];
    label.text = address;
    
    [UIView animateWithDuration:0.35f animations:^{
        label.frame = CGRectMake(25.f, 6.f, size.width+8.f, 16.f);
        _locateView.frame = CGRectMake(10.f, 8.f, size.width+38.f, 28.f);
    }];
}
@end
