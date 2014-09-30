//
//  BHTextStyleCell.m
//  SmartBus
//
//  Created by launching on 14-8-1.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHTextStyleCell.h"

@implementation BHTextStyleCell

@synthesize textField = __textField;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        __textField = [[UITextField alloc] initWithFrame:CGRectZero];
        __textField.backgroundColor = [UIColor clearColor];
        __textField.font = TTFONT_SIZED(16);
        __textField.textColor = [UIColor darkGrayColor];
        __textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        __textField.placeholder = @"请输入新密码";
        __textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:__textField];
    }
    return self;
}

- (void)fillTitle:(NSString *)title placeholder:(NSString *)placeholder
{
    [self.textLabel setFont:TTFONT_BOLD_SIZE(16)];
    [self.textLabel setText:title];
    
    CGSize size = [title sizeWithFont:TTFONT_BOLD_SIZE(16) byWidth:200];
    float x = size.width + 22.0;
    __textField.frame = CGRectMake(x, 0, 320-x-10, 40);
    __textField.placeholder = placeholder;
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(12, 0, 150, 40);
}

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(__textField);
    [super dealloc];
}

@end
