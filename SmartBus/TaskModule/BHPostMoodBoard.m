//
//  BHPostMoodBoard.m
//  SmartBus
//
//  Created by launching on 13-12-19.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPostMoodBoard.h"
#import "UIPlaceHolderTextView.h"
#import "BHWeiboHelper.h"
#import "BHTaskHelper.h"

@interface BHPostMoodBoard ()<UITextViewDelegate, BHWeiboHelperDelegate>
{
    UIPlaceHolderTextView *_textView;
    BHWeiboHelper *_weiboHelper;
    BHTaskHelper *_taskHelper;
}
- (void)setupSubviews;
@end

#define kSinaBtnTag    85451
#define kTencentBtnTag 85452

@implementation BHPostMoodBoard

DEF_SIGNAL( PUBLISH );

- (void)load
{
    _weiboHelper = [[BHWeiboHelper alloc] initWithTarget:self];
    _taskHelper = [[BHTaskHelper alloc] init];
    [_taskHelper addObserver:self];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(_weiboHelper);
    [_taskHelper removeObserver:self];
    SAFE_RELEASE(_taskHelper);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_home.png"] title:@"发布心情"];
        [self setupSubviews];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_textView);
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
//        [_textView becomeFirstResponder];
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.PUBLISH] )
    {
        NSString *status = _textView.text;
        if ( !status || [status empty] )
        {
            [self presentMessageTips:@"您还没有填写今天的心情哦~"];
            return;
        }
        [_taskHelper postStatus:_textView.text];
        
        if ( [_weiboHelper sinaWeiboIsLoggedIn] )
        {
            [_weiboHelper shareSinaWeibo:_textView.text andImage:nil];
        }
        
        if ( [_weiboHelper tcWeiboIsLoggedIn] )
        {
            [_weiboHelper shareTCWeibo:_textView.text andImage:nil];
        }
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.succeed )
	{
        if ( [request.userInfo is:@"postStatus"] )
        {
            if ( _taskHelper.succeed )
            {
                [self presentMessageTips:@"发布成功"];
                [self performSelector:@selector(handleMenu) withObject:nil afterDelay:2];
            }
        }
	}
}


#pragma mark -
#pragma mark private methods

- (void)setupSubviews
{
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)]];
    bubbleImageView.frame = CGRectMake(10.f, 10.f, 300.f, 140.f);
    [self.beeView addSubview:bubbleImageView];
    [bubbleImageView release];
    
    _textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(15.f, 15.f, 220.f, 90.f)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = FONT_SIZE(14);
    _textView.placeholder = @"    今天心情怎么样，说点什么分享下吧( 分享心情还可获得15银币哦 )";
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.delegate = self;
    [self.beeView addSubview:_textView];
    
    BeeUIButton *publishButton = [BeeUIButton new];
    publishButton.frame = CGRectMake(240.f, 52.f, 60.f, 26.f);
    publishButton.layer.masksToBounds = YES;
    publishButton.layer.cornerRadius = 3.f;
    publishButton.backgroundColor = RGB(231, 84, 91);
    publishButton.title = @"发  布";
    publishButton.titleColor = [UIColor whiteColor];
    publishButton.titleFont = FONT_SIZE(15);
    [publishButton addSignal:self.PUBLISH forControlEvents:UIControlEventTouchUpInside];
    [self.beeView addSubview:publishButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 114.f, 60.f, 20.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_SIZE(15);
    label.textColor = [UIColor darkGrayColor];
    label.text = @"同布到";
    [self.beeView addSubview:label];
    [label release];
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"bg_comment.png"] stretchableImageWithLeftCapWidth:14.f topCapHeight:14.f];
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaButton.frame = CGRectMake(80.f, 110.f, 35.f, 28.f);
    sinaButton.tag = kSinaBtnTag;
    [sinaButton setImage:[UIImage imageNamed:@"icon_sina_gray.png"] forState:UIControlStateNormal];
    [sinaButton setImage:[UIImage imageNamed:@"icon_sina_active.png"] forState:UIControlStateSelected];
    [sinaButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [sinaButton addTarget:self action:@selector(handleWeiboAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.beeView addSubview:sinaButton];
    sinaButton.selected = [_weiboHelper sinaWeiboIsLoggedIn];
    
    UIButton *tencentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tencentButton.frame = CGRectMake(125.f, 110.f, 35.f, 28.f);
    tencentButton.tag = kTencentBtnTag;
    [tencentButton setImage:[UIImage imageNamed:@"icon_tencent_gray.png"] forState:UIControlStateNormal];
    [tencentButton setImage:[UIImage imageNamed:@"icon_tencent_active.png"] forState:UIControlStateSelected];
    [tencentButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [tencentButton addTarget:self action:@selector(handleWeiboAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.beeView addSubview:tencentButton];
    tencentButton.selected = [_weiboHelper tcWeiboIsLoggedIn];
}

- (void)handleWeiboAction:(id)sender
{
    [_textView resignFirstResponder];
    
    if ( [sender tag] == kSinaBtnTag )
    {
        [_weiboHelper logInSinaWeibo];
    }
    else if ( [sender tag] == kTencentBtnTag )
    {
        [_weiboHelper logInTCWeibo];
    }
}


#pragma mark -
#pragma mark BHWeiboHelperDelegate

- (void)weiboHelperSinaWeiboLoggedIn:(id)helper
{
    UIButton *sinaButton = (UIButton *)[self.beeView viewWithTag:kSinaBtnTag];
    sinaButton.selected = !sinaButton.selected;
}

- (void)weiboHelperTCWeiboLoggedIn:(id)helper
{
    UIButton *tencentButton = (UIButton *)[self.beeView viewWithTag:kTencentBtnTag];
    tencentButton.selected = !tencentButton.selected;
}


#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( [text is:@"\n"] )
    {
        [textView resignFirstResponder];
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
