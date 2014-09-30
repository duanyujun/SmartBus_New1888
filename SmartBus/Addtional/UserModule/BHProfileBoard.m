//
//  BHProfileBoard.m
//  SmartBus
//
//  Created by kukuasir on 13-11-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHProfileBoard.h"
#import "BHUserCheckBoard.h"
#import "BHSuccessBoard.h"
#import "BHTextBubble.h"
#import "BHUserHelper.h"

@interface BHProfileBoard ()
{
    BHTextBubble *_unameBubble;
    BHTextBubble *_pwdBubble;
    BHTextBubble *_genderBubble;
    
    BHUserHelper *_userHelper;
    NSString *_uphone;
}
@end

@implementation BHProfileBoard

DEF_SIGNAL( SUBMIT );

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
        
        _unameBubble = [[BHTextBubble alloc] initWithPosition:CGPointMake(10.f, 15.f) title:@"昵  称 :"];
        [_unameBubble setMode:BubbleModeTextField placeholder:@"请输入您的昵称"];
        [self.beeView addSubview:_unameBubble];
        
        _pwdBubble = [[BHTextBubble alloc] initWithPosition:CGPointMake(10.f, 75.f) title:@"密  码 :"];
        [_pwdBubble setMode:BubbleModeTextField placeholder:@"请输入您的密码"];
        [self.beeView addSubview:_pwdBubble];
        
        _genderBubble = [[BHTextBubble alloc] initWithPosition:CGPointMake(10.f, 135.f) title:@"性  别 :"];
        [_genderBubble setMode:BubbleModeButton placeholder:@"保密"];
        [_genderBubble addTarget:self action:@selector(genderSelect:)];
        [self.beeView addSubview:_genderBubble];
        
        BeeUIButton *submitButton = [BeeUIButton new];
        submitButton.frame = CGRectMake(10.f, 205.f, 300.f, 44.f);
        submitButton.layer.cornerRadius = 4.f;
        submitButton.layer.masksToBounds = YES;
        submitButton.title = @"提交注册";
        submitButton.backgroundColor = [UIColor flatDarkRedColor];
        [submitButton addSignal:self.SUBMIT forControlEvents:UIControlEventTouchUpInside];
        [self.beeView addSubview:submitButton];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_unameBubble);
        SAFE_RELEASE_SUBVIEW(_pwdBubble);
        SAFE_RELEASE_SUBVIEW(_genderBubble);
	}
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        NSString *gender = nil;
        switch ( [BHUserModel sharedInstance].ugender )
        {
            case 1:
                gender = @"男";
                break;
            case 2:
                gender = @"女";
                break;
            default:
                gender = @"保密";
                break;
        }
        [_genderBubble.textButton setTitle:gender forState:UIControlStateNormal];
    }
}


ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.SUBMIT] )
    {
        NSString *nickname = [_unameBubble.textField text];
        NSString *password = [_pwdBubble.textField text];
        
        if ( (!nickname || nickname.length == 0) ||
            (!password || password.length == 0))
        {
            [self presentMessageTips:@"您填写的信息不完整"];
            return;
        }
        
        BHUserModel *user = [[BHUserModel alloc] init];
        user.uphone = _uphone;
        user.uname = nickname;
        user.password = password;
        user.ugender = [BHUserModel sharedInstance].ugender;
        [_userHelper registerUserInfo:user];
        [user release];
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        [self presentLoadingTips:@"正在注册..."];
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        
        if ([request.userInfo isEqualToString:@"register"])
        {
            if ( _userHelper.succeed )
            {
                [BHUtil saveUserPhone:_uphone andPassword:_pwdBubble.textField.text];
                BHSuccessBoard *board = [BHSuccessBoard board];
                [self.stack pushBoard:board animated:YES];
            }
        }
    }
    else if ( request.failed )
    {
        [self dismissTips];
    }
}


#pragma mark -
#pragma mark button events

- (void)genderSelect:(id)sender
{
    BHUserCheckBoard *board = [[BHUserCheckBoard alloc] initWithCheckMode:CheckModeGender];
    board.registered = YES;
    [self.stack pushBoard:board animated:YES];
    [board release];
}

@end
