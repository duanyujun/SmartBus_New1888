//
//  BHRegisterBoard.m
//  SmartBus
//
//  Created by jstv on 13-10-21.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHRegisterBoard.h"
#import "BHAuthCodeBoard.h"
#import "BHTextBubble.h"
#import "BHUserHelper.h"

#define GET_VAILCODE_TAG 1234

@interface BHRegisterBoard ()
{
    BHTextBubble *_bubble;
    BHUserHelper *_userHelper;
}
@end

@implementation BHRegisterBoard

DEF_SIGNAL( CHECK_PHONE );

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
        
        _bubble = [[BHTextBubble alloc] initWithPosition:CGPointMake(10.f, 15.f) title:@"手机号"];
        [_bubble setMode:BubbleModeTextField placeholder:@"请输入您的手机号"];
        [self.beeView addSubview:_bubble];
        
        BeeUIButton *nextButton = [BeeUIButton new];
        nextButton.frame = CGRectMake(10.f, 80.f, 300.f, 44.f);
        nextButton.layer.cornerRadius = 4.f;
        nextButton.layer.masksToBounds = YES;
        nextButton.title = @"下一步";
        nextButton.backgroundColor = [UIColor flatDarkRedColor];
        [nextButton addSignal:self.CHECK_PHONE forControlEvents:UIControlEventTouchUpInside];
        [self.beeView addSubview:nextButton];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_bubble);
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.CHECK_PHONE] )
    {
        [_bubble.textField resignFirstResponder];
        
        if ( ![BHUtil isMobileNumber:_bubble.textField.text] )
        {
            [self presentMessageTips:@"您输入的手机号有误"];
            return;
        }
        // 检查手机号是否可用
        [_userHelper check:_bubble.textField.text];
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.succeed )
	{
        if ([request.userInfo isEqualToString:@"checkPhone"])
        {
            if ( !_userHelper.succeed )
            {
                [self presentMessageTips:@"您输入的手机号已被注册"];
                return;
            }
            
            BHAuthCodeBoard *board = [[BHAuthCodeBoard alloc] initWithPhone:_bubble.textField.text];
            board.registed = YES;
            [self.stack pushBoard:board animated:YES];
            [board release];
        }
    }
}

@end
