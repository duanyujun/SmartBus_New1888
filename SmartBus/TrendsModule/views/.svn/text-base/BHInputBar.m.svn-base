//
//  BHInputBar.m
//  SmartBus
//
//  Created by launching on 13-11-12.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHInputBar.h"
#import "HPGrowingTextView.h"
#define TAPVIEW_TAG 9867555

@interface BHInputBar ()<HPGrowingTextViewDelegate>
{
    UIImageView *_bubbleImageView;
    HPGrowingTextView *_growingTextView;
    id<BHInputBarDelegate> _delegate;
    CGRect parentFrame;
}
@end

#define kSendButtonTag  78952

@implementation BHInputBar

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    SAFE_RELEASE_SUBVIEW(_growingTextView);
    _delegate = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    if ( self = [super initWithFrame:frame] )
    {
        _delegate = delegate;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor flatDarkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 1.5;
        
        _bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f]];
        _bubbleImageView.frame = CGRectMake(10.f, 8.f, 250.f, 40.f);
        [self addSubview:_bubbleImageView];
        
        _growingTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(20.f, 10.f, 230.f, 36.f)];
        _growingTextView.backgroundColor = [UIColor clearColor];
        _growingTextView.font = FONT_SIZE(14);
        _growingTextView.minNumberOfLines = 1;
        _growingTextView.maxNumberOfLines = 3;
        _growingTextView.returnKeyType = UIReturnKeySend;
        _growingTextView.delegate = self;
        [self addSubview:_growingTextView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(270.f, 8.f, 40.f, 40.f);
        button.tag = kSendButtonTag;
        [button setBackgroundImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_send.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        //注册键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (BOOL)resignFirstResponder
{
    UIView *parentView = [self superview];
    UIControl *tapControl = (UIControl *)[parentView viewWithTag:TAPVIEW_TAG];
    [tapControl removeFromSuperview];
    SAFE_RELEASE_SUBVIEW(tapControl);
    return [_growingTextView resignFirstResponder];
}

- (void)send:(id)sender
{
    if ( !_growingTextView.text || _growingTextView.text.length == 0 )
    {
        return;
    }
    
    if ( [_delegate respondsToSelector:@selector(inputBar:sendMessage:)] )
    {
        [_delegate inputBar:self sendMessage:_growingTextView.text];
    }
    
    //[self resignFirstResponder];
    _growingTextView.text = nil;
}


#pragma mark -
#pragma mark keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.superview convertRect:keyboardBounds toView:nil];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect rc = self.frame;
                         rc.origin.y = self.superview.frame.size.height - (keyboardBounds.size.height + self.frame.size.height);
                         self.frame = rc;
                     } completion:^(BOOL finished) {
                         if ( finished )
                         {
                             UIView *parentView = [self superview];
                             UIControl *tapControl = (UIControl *)[parentView viewWithTag:TAPVIEW_TAG];
                             if (!tapControl) {
                                 tapControl = [[UIControl alloc]initWithFrame:parentView.bounds];
                                 [tapControl setTag:TAPVIEW_TAG];
                                 [tapControl addTarget:self action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
                             }
                             [tapControl setBackgroundColor:[UIColor clearColor]];
                             
                             [parentView addSubview:tapControl];
                             [parentView bringSubviewToFront:tapControl];
                             [parentView bringSubviewToFront:self];
                             
                         }
                     }];
    if ( [_delegate respondsToSelector:@selector(inputBar:keyBoardWillShow:)] )
    {
        [_delegate inputBar:self keyBoardWillShow:notification];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect rc = self.frame;
                         rc.origin.y = self.superview.frame.size.height - self.frame.size.height;
                         self.frame = rc;
                     } completion:^(BOOL finished) {
                         if ( finished )
                         {
                             
                         }
                     }];
    if ( [_delegate respondsToSelector:@selector(inputBar:keyBoardWillHide:)] )
    {
        [_delegate inputBar:self keyBoardWillHide:notification];
    }
}


#pragma mark -
#pragma mark HPGrowingTextViewDelegate

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self send:nil];
    return NO;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect rc = _bubbleImageView.frame;
    rc.size.height -= diff;
    _bubbleImageView.frame = rc;
    
    rc = growingTextView.frame;
    rc.size.height -= diff;
    growingTextView.frame = rc;
    
    UIButton *button = (UIButton *)[self viewWithTag:kSendButtonTag];
    rc = button.frame;
    rc.origin.y -= (diff / 2);
    button.frame = rc;
    
    rc = self.frame;
    rc.origin.y += diff;
    rc.size.height -= diff;
    self.frame = rc;
}


@end
