//
//  BHAppSectionView.m
//  SmartBus
//
//  Created by launching on 13-10-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAppSectionView.h"
#import "UIImageView+WebCache.h"
#import "UILabelExt.h"
#import "BHSectionModel.h"
#import "LKRoute.h"

@interface BHAppSectionView ()
{
    UIImageView *bubbleImageView;
    UIView *headBar;
    UIView *contentView;
    id<BHAppSectionDelegate> _delegate;
    BOOL _hideMore;
}
@end

@implementation BHAppSectionView

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(bubbleImageView);
    SAFE_RELEASE_SUBVIEW(headBar);
    SAFE_RELEASE_SUBVIEW(contentView);
    SAFE_RELEASE(self.image);
    SAFE_RELEASE(self.title);
    [super dealloc];
}

- (id)initWithPosition:(CGPoint)point delegate:(id<BHAppSectionDelegate>)delegate
{
    if ( self = [super initWithFrame:CGRectMake(point.x, point.y, 320.f-point.x*2, kSectionHeaderHeight)] )
    {
        _delegate = delegate;
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.f;
        
        bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:10.f topCapHeight:10.f]];
        bubbleImageView.frame = self.bounds;
        [self addSubview:bubbleImageView];
        
        // header
        headBar = [[UIView alloc] initWithFrame:CGRectMake(1.f, 0.f, 308.f, kSectionHeaderHeight)];
        headBar.backgroundColor = [UIColor clearColor];
        [self addSubview:headBar];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 5.f, 20.f, 20.f)];
        [headBar addSubview:iconImageView];
        [iconImageView release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.f, 5.f, 100.f, 20.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = BOLD_FONT_SIZE(15);
        titleLabel.textColor = [UIColor whiteColor];
        [headBar addSubview:titleLabel];
        [titleLabel release];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(310.f-34.f, 0.f, kSectionHeaderHeight, kSectionHeaderHeight);
        [button setImage:[UIImage imageNamed:@"section_more.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [headBar addSubview:button];
        
        // content
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kSectionHeaderHeight, 310.f, self.frame.size.height-kSectionHeaderHeight)];
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        
        UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.f, 8.f, 63.f, 50.f)];
        coverImageView.image = [UIImage imageNamed:@"pic_default.png"];
        [contentView addSubview:coverImageView];
        [coverImageView release];
        
        UIImageView *memberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_member.png"]];
        memberImageView.frame = CGRectMake(78.f, 8.f, 13.f, 14.f);
        [contentView addSubview:memberImageView];
        memberImageView.hidden = YES;
        [memberImageView release];
        
        UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(78.f, 5.f, 225.f, 20.f)];
        subjectLabel.backgroundColor = [UIColor clearColor];
        subjectLabel.font = FONT_SIZE(15);
        [contentView addSubview:subjectLabel];
        [subjectLabel release];
        
        UILabelExt *summaryLabel = [[UILabelExt alloc] initWithFrame:CGRectMake(78.f, 27.f, 225.f, 32.f)];
        summaryLabel.backgroundColor = [UIColor clearColor];
        summaryLabel.font = FONT_SIZE(12);
        summaryLabel.textColor = [UIColor lightGrayColor];
        summaryLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        summaryLabel.numberOfLines = 0;
        [contentView addSubview:summaryLabel];
        [summaryLabel release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [contentView addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (id)initWithPosition:(CGPoint)point
{
    return [self initWithPosition:point delegate:nil];
}


#pragma mark - 
#pragma mark getter/setter methods

- (void)setTintColor:(UIColor *)color
{
    headBar.backgroundColor = color;
}

- (void)setImage:(UIImage *)img
{
    UIImageView *iconImageView = (UIImageView *)[headBar.subviews objectAtIndex:0];
    [iconImageView setImage:img];
}

- (void)setTitle:(NSString *)t
{
    UILabel *titleLabel = (UILabel *)[headBar.subviews objectAtIndex:1];
    [titleLabel setText:t];
}

- (void)setHideMore:(BOOL)hideMore
{
    UIButton *button = (UIButton *)[headBar.subviews objectAtIndex:2];
    button.hidden = hideMore;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [bubbleImageView setFrame:self.bounds];
    [contentView setFrame:CGRectMake(0.f, kSectionHeaderHeight, 310.f, self.frame.size.height-kSectionHeaderHeight)];
}


#pragma mark -
#pragma mark public methods

- (void)setStyle:(AppStyle)style dataSource:(id)dataSource
{
    BHSectionModel *section = (BHSectionModel *)dataSource;
    if ( section == nil ) return;
    
    UIImageView *coverImageView = (UIImageView *)[contentView.subviews objectAtIndex:0];
    UIImageView *memberImageView = (UIImageView *)[contentView.subviews objectAtIndex:1];
    UILabel *subjectLabel = (UILabel *)[contentView.subviews objectAtIndex:2];
    UILabelExt *summaryLabel = (UILabelExt *)[contentView.subviews objectAtIndex:3];
    
    if ( style == AppStyleTrends && section.summary.length == 0 && section.subject.length == 0 )
    {
        coverImageView.hidden = YES;
        memberImageView.hidden = YES;
        summaryLabel.hidden = YES;
        subjectLabel.hidden = NO;
        
        [subjectLabel setFrame:CGRectMake(10.f, 10.f, 280.f, 20.f)];
        [subjectLabel setTextAlignment:UITextAlignmentCenter];
        [subjectLabel setText:@"本站没有动态,赶快去发布动态吧~"];
        
        CGRect rc = self.frame;
        rc.size.height = kSectionHeaderHeight + 40.f;
        [self setFrame:rc];
    }
    else
    {
        coverImageView.hidden = NO;
        memberImageView.hidden = (style == AppStyleTrends) ? NO : YES;
        summaryLabel.hidden = NO;
        subjectLabel.hidden = NO;
        
        [coverImageView setImageWithURL:[NSURL URLWithString:section.cover]
                       placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
        [subjectLabel setTextAlignment:UITextAlignmentLeft];
        [subjectLabel setText:section.subject];
        [summaryLabel setText:section.summary];
        
        if ( style == AppStyleTrends )
        {
            subjectLabel.frame = CGRectMake(98.f, 5.f, 205.f, 20.f);
        }
        
        CGRect rc = self.frame;
        rc.size.height = kSectionHeaderHeight + 16.f + 52.f;
        [self setFrame:rc];
    }
}


#pragma mark -
#pragma mark private methods

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    if ( [_delegate respondsToSelector:@selector(appSectionViewDidTapped:)] )
    {
        [_delegate appSectionViewDidTapped:self];
    }
}

- (void)moreAction:(id)sender
{
    if ( [_delegate respondsToSelector:@selector(appSectionViewDidSelectMore:)] )
    {
        [_delegate appSectionViewDidSelectMore:self];
    }
}

@end
