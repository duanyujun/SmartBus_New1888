//
//  BHTextBubble.m
//  SmartBus
//
//  Created by kukuasir on 13-11-8.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTextBubble.h"

#define kBubbleHeight  48.f

@implementation BHTextBubble

@synthesize textField = _textField, textButton = _textButton;

- (void)removeFromSuperview
{
    SAFE_RELEASE_SUBVIEW(_textField);
    SAFE_RELEASE_SUBVIEW(_textButton);
    [super removeFromSuperview];
}

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(_textField);
    SAFE_RELEASE_SUBVIEW(_textButton);
    [super dealloc];
}

- (id)initWithPosition:(CGPoint)point title:(NSString *)title
{
    if ( self = [super initWithFrame:CGRectMake(point.x, point.y, 300.f, kBubbleHeight)] )
    {
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f]];
        bubbleImageView.frame = self.bounds;
        [self addSubview:bubbleImageView];
        [bubbleImageView release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 9.f, 70.f, 30.f)];
        label.backgroundColor = [UIColor clearColor];
        label.font = BOLD_FONT_SIZE(14);
        label.text = title;
        [self addSubview:label];
        [label release];
    }
    return self;
}

- (void)setMode:(BubbleMode)mode placeholder:(NSString *)placeholer
{
    if ( mode == BubbleModeTextField )
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(90.f, 9.f, 200.f, 30.f)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = FONT_SIZE(14);
        _textField.textColor = [UIColor darkGrayColor];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.placeholder = placeholer;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        [self addSubview:_textField];
    }
    else if ( mode == BubbleModeButton )
    {
        _textButton = [[UIButton alloc] initWithFrame:CGRectMake(90.f, 2.f, 200.f, 44.f)];
        _textButton.backgroundColor = [UIColor clearColor];
        _textButton.titleLabel.font = FONT_SIZE(14);
        _textButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_textButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_textButton setTitle:placeholer forState:UIControlStateNormal];
        [self addSubview:_textButton];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right_arrow.png"]];
        arrowImageView.frame = CGRectMake(190.f, 16.f, 6.f, 12.f);
        [_textButton addSubview:arrowImageView];
        [arrowImageView release];
    }
}

- (void)addTarget:(id)target action:(SEL)selector
{
    [_textButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
