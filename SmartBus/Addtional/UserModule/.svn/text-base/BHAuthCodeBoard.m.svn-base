//
//  BHAuthCodeBoard.m
//  SmartBus
//
//  Created by kukuasir on 13-11-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAuthCodeBoard.h"
#import "BHProfileBoard.h"
#import "BHModifyPwdBoard.h"
#import "BHTextBubble.h"
#import "BHUserHelper.h"

@interface BHAuthCodeBoard ()
{
    BHTextBubble *_bubble;
    UIButton *_resendButton;
    
    BHUserHelper *_userHelper;
    NSString *_uphone;
    NSInteger _remain;
}
- (void)remainTime;
@end

@implementation BHAuthCodeBoard

DEF_SIGNAL( VERIFY_AUTH );

- (id)initWithPhone:(NSString *)phone
{
    if ( self = [super init] )
    {
        _uphone = [phone retain];
    }
    return self;
}

- (void)load
{
    _remain = kSendInterval;
    _userHelper = [[BHUserHelper alloc] init];
    [_userHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_userHelper removeObserver:self];
    SAFE_RELEASE(_userHelper);
    SAFE_RELEASE(_uphone);
    [super unload];
}

- (void)handleMenu
{
    [_userHelper removeObserver:self];
    SAFE_RELEASE(_userHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_profile.png"] title:@"注册"];
        
        _bubble = [[BHTextBubble alloc] initWithPosition:CGPointMake(10.f, 15.f) title:@"验证码"];
        [_bubble setMode:BubbleModeTextField placeholder:@"请输入手机收到的验证码"];
        [self.beeView addSubview:_bubble];
        
        BeeUIButton *nextButton = [BeeUIButton new];
        nextButton.frame = CGRectMake(10.f, 80.f, 300.f, 44.f);
        nextButton.layer.cornerRadius = 4.f;
        nextButton.layer.masksToBounds = YES;
        nextButton.title = @"下一步";
        nextButton.backgroundColor = [UIColor flatDarkRedColor];
        [nextButton addSignal:self.VERIFY_AUTH forControlEvents:UIControlEventTouchUpInside];
        [self.beeView addSubview:nextButton];
        
        BeeUILabel *tipLabel = [[BeeUILabel alloc] initWithFrame:CGRectMake(10.f, 150.f, 145.f, 28.f)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = FONT_SIZE(14);
        tipLabel.textAlignment = UITextAlignmentCenter;
        tipLabel.textColor = [UIColor blackColor];
        tipLabel.text = @"如果还没有收到短信";
        [self.beeView addSubview:tipLabel];
        [tipLabel release];
        
        _resendButton = [[UIButton alloc] initWithFrame:CGRectMake(180.f, 150.f, 130.f, 28.f)];
        _resendButton.titleLabel.font = FONT_SIZE(14);
        [_resendButton setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        [_resendButton setTitleColor:[UIColor flatBlackColor] forState:UIControlStateNormal];
        [_resendButton setBackgroundImage:[[UIImage imageNamed:@"bg_comment.png"] stretchableImageWithLeftCapWidth:14.f topCapHeight:14.f] forState:UIControlStateNormal];
        [_resendButton addTarget:self action:@selector(resend:) forControlEvents:UIControlEventTouchUpInside];
        [self.beeView addSubview:_resendButton];
        
        // 发送短信获取验证码
        [_userHelper performSelector:@selector(sendMessage:) withObject:_uphone afterDelay:0.1];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_bubble);
        SAFE_RELEASE_SUBVIEW(_resendButton);
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.VERIFY_AUTH] )
    {
        if ( ![_userHelper.authCode is:_bubble.textField.text] )
        {
            [self presentMessageTips:@"验证码不正确"];
            return;
        }
        
        BHSampleBoard *board = nil;
        if ( self.registed )
        {
            board = [[BHProfileBoard alloc] initWithPhone:_uphone];
        }
        else
        {
            board = [BHModifyPwdBoard board];
            [(BHModifyPwdBoard *)board setUphone:_uphone];
            [(BHModifyPwdBoard *)board setForgeted:YES];
        }
        [self.stack pushBoard:board animated:YES];
        [board release];
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.succeed )
	{
        if ([request.userInfo isEqualToString:@"sendVailcode"])
        {
            [self remainTime];
        }
    }
}


#pragma mark -
#pragma mark private methods

- (void)remainTime
{
    _remain --;
    
    if (_remain >= 0)
    {
        _resendButton.enabled = NO;
        [_resendButton setTitle:[NSString stringWithFormat:@"%d秒后可重发", _remain] forState:UIControlStateNormal];
        [self performSelector:@selector(remainTime) withObject:nil afterDelay:1];
    }
    else
    {
        [_resendButton setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        _resendButton.enabled = YES;
    }
}

- (void)resend:(id)sender
{
    // 重新获取验证码
    [_userHelper sendMessage:_uphone];
}

@end
