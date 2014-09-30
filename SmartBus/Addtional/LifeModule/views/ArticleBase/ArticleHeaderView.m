//
//  ArticleHeaderView.m
//  JstvNews
//
//  Created by launching on 13-6-4.
//  Copyright (c) 2013年 kukuasir. All rights reserved.
//

#import "ArticleHeaderView.h"
#import "BHArticleBase.h"

@implementation ArticleHeaderView

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(titleLabel);
    SAFE_RELEASE_SUBVIEW(dateLabel);
    SAFE_RELEASE_SUBVIEW(complainLabel);
    SAFE_RELEASE_SUBVIEW(iconImageView);
    SAFE_RELEASE_SUBVIEW(hline1);
    SAFE_RELEASE_SUBVIEW(hline2);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 8.f, 300.f, 30.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 38.f, 100.f, 20.f)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:12.f];
        dateLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:dateLabel];
        
        iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wq_personal.png"]];
        iconImageView.frame = CGRectMake(8.f, 38.f, 20.f, 20.f);
        [self addSubview:iconImageView];
        iconImageView.hidden = YES;
        
        complainLabel = [[UILabel alloc] initWithFrame:CGRectMake(36.f, 38.f, 270.f, 26.f)];
        complainLabel.backgroundColor = [UIColor clearColor];
        complainLabel.font = [UIFont systemFontOfSize:12.f];
        complainLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:complainLabel];
        complainLabel.hidden = YES;
        
        hline1 = [[UIView alloc] initWithFrame:CGRectMake(0.f, 52.f, 320.f, 1.f)];
        hline1.backgroundColor = RGB(211.f, 211.f, 211.f);
        [self addSubview:hline1];
        
        hline2 = [[UIView alloc] initWithFrame:CGRectMake(0.f, 53.f, 320.f, 1.f)];
        hline2.backgroundColor = [UIColor whiteColor];
        [self addSubview:hline2];
    }
    return self;
}

- (void)setArticleBase:(id)base
{
    BHArticleBase *info = (BHArticleBase *)base;
    
    CGFloat height = 8.f;
    
    CGSize size = [info.subject sizeWithFont:BOLD_FONT_SIZE(16) constrainedToSize:CGSizeMake(306.f, 200.f)];
    [titleLabel setFrame:CGRectMake(10.f, height, 304.f, size.height)];
    [titleLabel setText:info.subject];
    
    height += size.height + 3.f;
    
    [dateLabel setFrame:CGRectMake(10.f, height, 300.f, 20.f)];
    [dateLabel setText:info.created];
    
    [hline1 setFrame:CGRectMake(0.f, height+23.f, 320.f, 1.f)];
    [hline2 setFrame:CGRectMake(0.f, height+24.f, 320.f, 1.f)];
    [self setFrame:CGRectMake(0.f, 0.f, 320.f, height+25.f)];
}

@end
