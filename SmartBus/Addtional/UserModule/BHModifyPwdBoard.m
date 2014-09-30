//
//  BHModifyPwdBoard.m
//  SmartBus
//
//  Created by kukuasir on 13-11-10.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHModifyPwdBoard.h"
#import "BHTextBubble.h"
#import "BHUserHelper.h"

@interface BHModifyPwdBoard ()<UITextFieldDelegate>
{
    BHTextBubble *_bubble;
    UITextField *_newPwdText;
    UITextField *_confirmText;
    
    BHUserHelper *_userHelper;
    NSString *_uphone;
}
- (void)addPasswordTexts;
- (void)resignAll;
@end

@implementation BHModifyPwdBoard

DEF_SIGNAL( MODIFY_PWD );

@synthesize uphone = _uphone;

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
    
    if ( self.forgeted )
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.stack popBoardAnimated:YES];
    }
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        if ( self.forgeted )
        {
            [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_profile.png"] title:@"修改密码"];
        }
        else
        {
            [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_setting.png"] title:@"修改密码"];
        }
        
        if ( !self.forgeted )
        {
            _bubble = [[BHTextBubble alloc] initWithPosition:CGPointMake(10.f, 15.f) title:@"原密码"];
            [_bubble setMode:BubbleModeTextField placeholder:@"请输入原密码"];
            [self.beeView addSubview:_bubble];
        }
        
        [self addPasswordTexts];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW(_bubble);
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.MODIFY_PWD] )
    {
        [self resignAll];
        
        if ( !self.forgeted && (!_bubble.textField.text || _bubble.textField.text.length == 0) )
        {
            [self presentMessageTips:@"请输入原密码"];
            return;
        }
        
        if ( !_newPwdText.text || _newPwdText.text.length == 0 )
        {
            [self presentMessageTips:@"请输入新密码"];
            return;
        }
        
        if ( !_confirmText.text || _confirmText.text.length == 0 )
        {
            [self presentMessageTips:@"请输入确认密码"];
            return;
        }
        
        if ( ![_confirmText.text is:_newPwdText.text] )
        {
            [self presentMessageTips:@"两次输入的密码不一致"];
            return;
        }
        
        if ( self.forgeted )
        {
            [_userHelper updatePassword:_newPwdText.text atPhone:_uphone];
        }
        else
        {
            [_userHelper updatePassword:_newPwdText.text oldPassword:_bubble.textField.text atPhone:_uphone];
        }
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.succeed )
	{
        if ( [request.userInfo isEqualToString:@"forgotPassword"] ||
            [request.userInfo isEqualToString:@"modifyPassword"] )
        {
            if ( _userHelper.succeed )
            {
                [BHUtil saveUserPhone:nil andPassword:_newPwdText.text];
                [self presentMessageTips:@"修改成功"];
                [self performSelector:@selector(handleMenu) withObject:nil afterDelay:2];
            }
        }
    }
}


#pragma mark -
#pragma mark private methods

- (void)addPasswordTexts
{
    CGFloat y = self.forgeted ? 15.f : 75.f;
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f]];
    bubbleImageView.frame = CGRectMake(10.f, y, 300.f, 96.f);
    bubbleImageView.userInteractionEnabled = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 9.f, 70.f, 30.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = BOLD_FONT_SIZE(14);
    label.text = @"新密码";
    [bubbleImageView addSubview:label];
    [label release];
    
    _newPwdText = [[UITextField alloc] initWithFrame:CGRectMake(90.f, 9.f, 200.f, 30.f)];
    _newPwdText.backgroundColor = [UIColor clearColor];
    _newPwdText.font = FONT_SIZE(14);
    _newPwdText.textColor = [UIColor darkGrayColor];
    _newPwdText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _newPwdText.placeholder = @"请输入新密码";
    _newPwdText.returnKeyType = UIReturnKeyNext;
    _newPwdText.delegate = self;
    [bubbleImageView addSubview:_newPwdText];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20.f, 48.f, 260.f, 1.f)];
    line.backgroundColor = [UIColor flatWhiteColor];
    [bubbleImageView addSubview:line];
    [line release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 57.f, 70.f, 30.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = BOLD_FONT_SIZE(14);
    label.text = @"再次输入";
    [bubbleImageView addSubview:label];
    [label release];
    
    _confirmText = [[UITextField alloc] initWithFrame:CGRectMake(90.f, 57.f, 200.f, 30.f)];
    _confirmText.backgroundColor = [UIColor clearColor];
    _confirmText.font = FONT_SIZE(14);
    _confirmText.textColor = [UIColor darkGrayColor];
    _confirmText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _confirmText.placeholder = @"请再次输入新密码";
    _confirmText.returnKeyType = UIReturnKeyDone;
    _confirmText.delegate = self;
    [bubbleImageView addSubview:_confirmText];
    
    [self.beeView addSubview:bubbleImageView];
    [bubbleImageView release];
    
    
    BeeUIButton *nextButton = [BeeUIButton new];
    nextButton.frame = CGRectMake(10.f, y+96.f+15.f, 300.f, 44.f);
    nextButton.layer.cornerRadius = 4.f;
    nextButton.layer.masksToBounds = YES;
    nextButton.title = @"确认修改";
    nextButton.backgroundColor = [UIColor flatDarkRedColor];
    [nextButton addSignal:self.MODIFY_PWD forControlEvents:UIControlEventTouchUpInside];
    [self.beeView addSubview:nextButton];
}

- (void)resignAll
{
    [_bubble.textField resignFirstResponder];
    [_newPwdText resignFirstResponder];
    [_confirmText resignFirstResponder];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( [textField isEqual:_newPwdText] )
    {
        [_confirmText becomeFirstResponder];
    }
    else if ( [textField isEqual:_confirmText] )
    {
        [_confirmText resignFirstResponder];
    }
    return YES;
}

@end
