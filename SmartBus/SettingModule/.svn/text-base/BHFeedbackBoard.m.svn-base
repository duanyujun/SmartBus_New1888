//
//  BHFeedbackBoard.m
//  SmartBus
//
//  Created by launching on 13-11-26.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHFeedbackBoard.h"
#import "BHSetupHelper.h"

@interface BHFeedbackBoard ()<UITextFieldDelegate>
{
    UIView *_container;
    UITextField *_uphoneTextField;
    UITextField *_unameTextField;
    BeeUITextView *_feedbackText;
    BHSetupHelper *_setHelper;
}
- (void)addBubbleImageView:(CGRect)frame;
@end

@implementation BHFeedbackBoard

DEF_SIGNAL( FEED_BACK );

- (void)load
{
    _setHelper = [[BHSetupHelper alloc] init];
    [_setHelper addObserver:self];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE_SUBVIEW(_feedbackText);
    [_setHelper removeObserver:self];
    SAFE_RELEASE(_setHelper);
    [super unload];
}

- (void)handleMenu
{
    [_setHelper removeObserver:self];
    SAFE_RELEASE(_setHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_setting.png"] title:@"意见反馈"];
        
        BeeUIButton *menu = [BeeUIButton new];
        menu.frame = CGRectMake(280.f, 2.f, 40.f, 40.f);
        menu.image = [UIImage imageNamed:@"icon_certain.png"];
        [menu addSignal:self.FEED_BACK forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:menu];
        
        _container = [[UIView alloc] initWithFrame:self.beeView.bounds];
        _container.backgroundColor = [UIColor clearColor];
        [self.beeView addSubview:_container];
        
        // 手机号
        [self addBubbleImageView:CGRectMake(10.f, 10.f, 300.f, 50.f)];
        _uphoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(25.f, 15.f, 270.f, 40.f)];
        _uphoneTextField.backgroundColor = [UIColor clearColor];
        _uphoneTextField.font = FONT_SIZE(15);
        _uphoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _uphoneTextField.placeholder = @"输入您的手机号";
        _uphoneTextField.returnKeyType = UIReturnKeyNext;
        _uphoneTextField.delegate = self;
        [_container addSubview:_uphoneTextField];
        
        // 用户名
        [self addBubbleImageView:CGRectMake(10.f, 70.f, 300.f, 50.f)];
        _unameTextField = [[UITextField alloc] initWithFrame:CGRectMake(25.f, 75.f, 270.f, 40.f)];
        _unameTextField.backgroundColor = [UIColor clearColor];
        _unameTextField.font = FONT_SIZE(15);
        _unameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _unameTextField.placeholder = @"输入您的用户名";
        _unameTextField.returnKeyType = UIReturnKeyNext;
        _unameTextField.delegate = self;
        [_container addSubview:_unameTextField];
        
        // 反馈内容
        [self addBubbleImageView:CGRectMake(10.f, 130.f, 300.f, 270.f)];
        _feedbackText = [[BeeUITextView alloc] initWithFrame:CGRectMake(15.f, 135.f, 290.f, 260.f)];
        _feedbackText.backgroundColor = [UIColor clearColor];
        _feedbackText.showsVerticalScrollIndicator = NO;
        _feedbackText.placeholder = @"对掌上公交有想法？说说吧。";
        _feedbackText.font = FONT_SIZE(15);
        _feedbackText.returnKeyType = UIReturnKeyDone;
        [_container addSubview:_feedbackText];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        SAFE_RELEASE_SUBVIEW(_uphoneTextField);
        SAFE_RELEASE_SUBVIEW(_unameTextField);
        SAFE_RELEASE_SUBVIEW(_feedbackText);
        SAFE_RELEASE_SUBVIEW(_container);
    }
}

ON_SIGNAL2( BeeUITextView, signal )
{
    if ( [signal is:BeeUITextView.DID_ACTIVED] )
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rc = _container.frame;
            rc.origin.y = -120.f;
            [_container setFrame:rc];
        }];
    }
    else if ( [signal is:BeeUITextView.RETURN] )
    {
        [_feedbackText resignFirstResponder];
        
        [UIView animateWithDuration:0.3 animations:^{
            [_container setFrame:self.beeView.bounds];
        }];
    }
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.FEED_BACK] )
    {
        NSString *uphone = _uphoneTextField.text;
        NSString *uname = _unameTextField.text;
        NSString *content = _feedbackText.text;
        
        if ( !uphone || uphone.length == 0 )
        {
            [self presentMessageTips:@"您还没有填手机号码"];
            return;
        }
        
        if ( ![BHUtil isMobileNumber:uphone] )
        {
            [self presentMessageTips:@"您填入的手机号码格式不正确哦"];
            return;
        }
        
        if ( !content || content.length == 0 )
        {
            [self presentMessageTips:@"您还没有输入反馈内容"];
            return;
        }
        [_setHelper feedback:content atPhone:uphone username:uname];
    }
}


#pragma mark -
#pragma mark private methods

- (void)addBubbleImageView:(CGRect)frame
{
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)]];
    bubbleImageView.frame = frame;
    [_container addSubview:bubbleImageView];
    [bubbleImageView release];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( [textField isEqual:_uphoneTextField] )
    {
        [_unameTextField becomeFirstResponder];
    }
    else if ( [textField isEqual:_unameTextField] )
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rc = _container.frame;
            rc.origin.y = -120.f;
            [_container setFrame:rc];
        }];
        
        [_feedbackText setText:nil];
        [_feedbackText becomeFirstResponder];
    }
    
    return YES;
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        [self presentLoadingTips:@"正在提交..."];
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        
		if ( [request.userInfo is:@"feedback"] )
        {
            [self presentMessageTips:@"您的宝贵意见对我们非常有用,如有需要我们会联系您!"];
            [self performSelector:@selector(handleMenu) withObject:nil afterDelay:2];
        }
	}
    else if ( request.failed )
    {
        [self dismissTips];
    }
}

@end
