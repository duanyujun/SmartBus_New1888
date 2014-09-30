//
//  BHGroupIntroCell.m
//  SmartBus
//
//  Created by launching on 13-12-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHGroupIntroCell.h"

@interface BHGroupIntroCell ()
{
    UIImageView *bubbleImageView;
    UILabel *introLabel;
    UILabel *notifyLabel;
}
@end

@implementation BHGroupIntroCell

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(bubbleImageView);
    SAFE_RELEASE_SUBVIEW(introLabel);
    SAFE_RELEASE_SUBVIEW(notifyLabel);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)]];
        bubbleImageView.frame = CGRectMake(10.f, 5.f, 300.f, 120.f);
        [self.contentView addSubview:bubbleImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 8.f, 276.f, 25.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONT_SIZE(15);
        titleLabel.textColor = [UIColor flatRedColor];
        titleLabel.text = @"圈子简介";
        [bubbleImageView addSubview:titleLabel];
        [titleLabel release];
        
        introLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 33.f, 276.f, 25.f)];
        introLabel.backgroundColor = [UIColor clearColor];
        introLabel.font = FONT_SIZE(14);
        introLabel.textColor = [UIColor lightGrayColor];
        introLabel.numberOfLines = 0;
        [bubbleImageView addSubview:introLabel];
        
        UIView *hline = [[UIView alloc] initWithFrame:CGRectMake(0.f, 65.f, 300.f, 1.f)];
        hline.backgroundColor = [UIColor flatWhiteColor];
        [bubbleImageView addSubview:hline];
        [hline release];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 74.f, 276.f, 25.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONT_SIZE(15);
        titleLabel.textColor = [UIColor flatRedColor];
        titleLabel.text = @"公告";
        [bubbleImageView addSubview:titleLabel];
        [titleLabel release];
        
        notifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 99.f, 276.f, 25.f)];
        notifyLabel.backgroundColor = [UIColor clearColor];
        notifyLabel.font = FONT_SIZE(14);
        notifyLabel.textColor = [UIColor lightGrayColor];
        notifyLabel.numberOfLines = 0;
        [bubbleImageView addSubview:notifyLabel];
    }
    return self;
}

- (void)setIntro:(NSString *)intro andNotify:(NSString *)notify
{
    CGSize size = [intro sizeWithFont:FONT_SIZE(14) byWidth:276.f];
    [introLabel setFrame:CGRectMake(12.f, 33.f, 276.f, size.height)];
    [introLabel setText:intro];
    
    UIView *hline = [bubbleImageView.subviews objectAtIndex:2];
    [hline setFrame:CGRectMake(0.f, 40.f+size.height, 300.f, 1.f)];
    
    UILabel *titleLabel = (UILabel *)[bubbleImageView.subviews objectAtIndex:3];
    [titleLabel setFrame:CGRectMake(12.f, 49.f+size.height, 276.f, 25.f)];
    
    size = [notify sizeWithFont:FONT_SIZE(14) byWidth:276.f];
    [notifyLabel setFrame:CGRectMake(12.f, titleLabel.frame.origin.y+titleLabel.frame.size.height, 276.f, size.height)];
    [notifyLabel setText:notify];
    
    CGFloat height = notifyLabel.frame.origin.y + notifyLabel.frame.size.height + 8.f;
    [bubbleImageView setFrame:CGRectMake(10.f, 5.f, 300.f, height)];
}

@end
