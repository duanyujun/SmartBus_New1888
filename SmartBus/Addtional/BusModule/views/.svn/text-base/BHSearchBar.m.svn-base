//
//  BHSearchBar.m
//  SmartBus
//
//  Created by launching on 13-10-8.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSearchBar.h"

@interface BHSearchBar ()<UITextFieldDelegate>
{
    BeeUITextField *_textField;
}
@end

@implementation BHSearchBar

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:10.f topCapHeight:10.f]];
        bubbleImageView.frame = CGRectMake(10.f, 0.f, 250.f, self.frame.size.height);
        [self addSubview:bubbleImageView];
        [bubbleImageView release];
        
        _textField = [[BeeUITextField alloc] initWithFrame:CGRectMake(20.f, 2.f, 230.f, self.bounds.size.height-4.f)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = FONT_SIZE(14);
        [self addSubview:_textField];
        
        BeeUIButton *button = [BeeUIButton new];
        button.frame = CGRectMake(self.bounds.size.width-50.f, 1.f, self.bounds.size.height, self.bounds.size.height-2.f);
        button.stateNormal.backgroundImage = [UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)];
        button.stateNormal.image = [UIImage imageNamed:@"icon_search.png"];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3.f;
        [button addSignal:@"search" forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _textField.placeholder = placeholder;
}

- (void)setActive:(BOOL)flag
{
    if (flag) {
        [_textField becomeFirstResponder];
    } else {
        [_textField resignFirstResponder];
    }
}

- (NSString *)content
{
    return _textField.text;
}

- (void)clear
{
    _textField.text = nil;
}

- (BOOL)resignFirstResponder
{
    [_textField resignFirstResponder];
    [super resignFirstResponder];
    return true;
}


ON_SIGNAL2( BeeUIButton, signal )
{
    [super handleUISignal:signal];
}

ON_SIGNAL2( BeeUITextField, signal )
{
    [super handleUISignal:signal];
}


@end
