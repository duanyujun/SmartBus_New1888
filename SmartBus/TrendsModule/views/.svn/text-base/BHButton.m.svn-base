//
//  BHButton.m
//  SmartBus
//
//  Created by kukuasir on 13-11-10.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHButton.h"

@implementation BHButton

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 15.f;
        
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        bubbleImageView.image = [UIImage imageNamed:@"bg_comment.png" stretched:CGPointMake(14.5, 14.f)];
        [self addSubview:bubbleImageView];
        [bubbleImageView release];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, (frame.size.height-16.f)/2, 16.f, 16.f)];
        [self addSubview:iconImageView];
        [iconImageView release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.f, (frame.size.height-20.f)/2, 20.f, 20.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONT_SIZE(14);
        titleLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:titleLabel];
        [titleLabel release];
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView *bubbleImageView = (UIImageView *)[self.subviews objectAtIndex:0];
    [bubbleImageView setImage:backgroundImage];
}

- (void)setImage:(UIImage *)image number:(NSInteger)number
{
    UIImageView *iconImageView = (UIImageView *)[self.subviews objectAtIndex:1];
    [iconImageView setImage:image];
    
    NSString *str = [NSString stringWithFormat:@"%d", number];
    CGSize size = [str sizeWithFont:FONT_SIZE(14) byWidth:200.f];
    size.width += 10.f;
    UILabel *titleLabel = (UILabel *)[self.subviews objectAtIndex:2];
    [titleLabel setText:str];
    CGRect rc = titleLabel.frame;
    rc.size.width = size.width;
    [titleLabel setFrame:rc];
    
    rc = self.frame;
    rc.size.width = 30.f + size.width;
    [self setFrame:rc];
    
    UIImageView *bubbleImageView = (UIImageView *)[self.subviews objectAtIndex:0];
    [bubbleImageView setFrame:self.bounds];
}

- (void)setTextColor:(UIColor *)color
{
    UILabel *titleLabel = (UILabel *)[self.subviews objectAtIndex:2];
    [titleLabel setTextColor:color];
}

- (NSInteger)number
{
    UILabel *titleLabel = (UILabel *)[self.subviews objectAtIndex:2];
    return [titleLabel.text integerValue];
}

@end
