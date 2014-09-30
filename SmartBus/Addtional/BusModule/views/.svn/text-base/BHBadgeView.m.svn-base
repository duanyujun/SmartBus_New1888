//
//  BHBadgeView.m
//  SmartBus
//
//  Created by launching on 13-10-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHBadgeView.h"

@implementation BHBadgeView
{
    UILabel *_badgeLabel;
}

@synthesize badgeColor = _badgeColor;
@synthesize fontSize = _fontSize;
@synthesize badgeNumber = _badgeNumber;

- (void)dealloc
{
    SAFE_RELEASE(_badgeColor);
    SAFE_RELEASE_SUBVIEW(_badgeLabel);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		self.backgroundColor = [UIColor flatGrayColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.width / 2;
        
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 5.f, frame.size.width-10.f, frame.size.height-10.f)];
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.font = BOLD_FONT_SIZE(11);
        _badgeLabel.textAlignment = UITextAlignmentCenter;
        _badgeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_badgeLabel];
	}
    
	return self;
}


#pragma mark -
#pragma mark getter/setter methods

- (void)setBadgeColor:(UIColor *)badgeColor
{
    SAFE_RELEASE(_badgeColor);
    _badgeColor = [badgeColor retain];
    if ( _badgeColor )
    {
        self.backgroundColor = _badgeColor;
    }
    else
    {
        self.backgroundColor = RGB(224.f, 224.f, 224.f);
    }
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    [_badgeLabel setFont:BOLD_FONT_SIZE(_fontSize)];
}

- (void)setBadgeNumber:(NSInteger)badgeNumber
{
    _badgeNumber = badgeNumber;
    
    self.alpha = 1;
    NSString *number = [NSString stringWithFormat:@"%d", _badgeNumber];
    CGSize size = [number sizeWithFont:BOLD_FONT_SIZE(_fontSize) byWidth:100.f];
    _badgeLabel.frame = CGRectMake((self.frame.size.width-size.width)/2, (self.frame.size.height-size.height)/2, size.width, size.height);
    _badgeLabel.text = number;
}

@end
