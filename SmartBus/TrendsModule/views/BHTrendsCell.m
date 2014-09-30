//
//  BHTrendsCell.m
//  SmartBus
//
//  Created by launching on 13-11-13.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTrendsCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "BHButton.h"
#import "NSDate+Helper.h"

@interface BHTrendsCell ()
{
    UIImageView *bubbleImageView;
    UIButton *avatorButton;
    UILabel *unameLabel;
    UIImageView *timeBGImageView;
    UILabel *timeLabel;
    UILabel *contentLabel;
    UIImageView *coverImageView;
    UIView *toolsBar;
    
    BOOL _fromSelf;
}
- (void)addProfileBar:(BOOL)bSelf;
- (void)addContentView:(BOOL)bSelf;
- (void)addToolsBar;
@end

#define kIconImageTag  5270
#define kLocationTag   5271
#define kGroupTag      5272

@implementation BHTrendsCell

@synthesize trends = _trends;
@synthesize delegate = _delegate;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(bubbleImageView);
    SAFE_RELEASE_SUBVIEW(avatorButton);
    SAFE_RELEASE_SUBVIEW(unameLabel);
    SAFE_RELEASE_SUBVIEW(timeLabel);
    SAFE_RELEASE_SUBVIEW(contentLabel);
    SAFE_RELEASE_SUBVIEW(coverImageView);
    SAFE_RELEASE_SUBVIEW(toolsBar);
    SAFE_RELEASE(_trends)
    _delegate = nil;
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier bSelf:(BOOL)bSelf
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        _fromSelf = bSelf;
        
        // 背景图片
        bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f]];
        bubbleImageView.frame = CGRectMake(5.f, 3.f, 310.f, 220.f);
        bubbleImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:bubbleImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [bubbleImageView addGestureRecognizer:tap];
        [tap release];
        
        [self addProfileBar:_fromSelf];
        [self addContentView:_fromSelf];
        [self addToolsBar];
    }
    return self;
}

- (void)setTrends:(BHTrendsModel *)trends
{
    SAFE_RELEASE(_trends);
    _trends = [trends retain];
    
    CGFloat height = [_trends getHeight];
    [bubbleImageView setFrame:CGRectMake(5.f, 3.f, 310.f, height)];
    [toolsBar setFrame:CGRectMake(6.f, height-39.f, 308.f, 40.f)];
    
    // 用户信息栏
    if ( !_fromSelf )
    {
        // 头像
        [avatorButton setImageWithURL:[NSURL URLWithString:_trends.user.avator]
                     placeholderImage:[UIImage imageNamed:@"default_man.png"]];
    }
    
    [unameLabel setText:_trends.user.uname];
    
    NSString *timesAgo = [NSDate stringTimesAgo:_trends.ctime];
    CGSize size = [timesAgo sizeWithFont:FONT_SIZE(12) byWidth:300.f];
    size.width += 20.f;
    [timeLabel setFrame:CGRectMake(310.f-size.width-6.f, 10.f, size.width, 20.f)];
    [timeLabel setText:timesAgo];
    [timeBGImageView setFrame:CGRectMake(310.f-size.width, 10.f, size.width-1.f, 20.f)];
    
    // 正文栏
    size = [_trends.title sizeWithFont:FONT_SIZE(14) byWidth:(_fromSelf ? 290.f : 230.f)];
    [contentLabel setText:_trends.title];
    
    CGRect rc = contentLabel.frame;
    rc.size.height = size.height;
    contentLabel.frame = rc;
    
    rc = coverImageView.frame;
    rc.origin.y = contentLabel.frame.origin.y + contentLabel.frame.size.height + 8.f;
    coverImageView.frame = rc;
    
    if ( _trends.images.count > 0 )
    {
        coverImageView.hidden = NO;
        [coverImageView setImageWithURL:[NSURL URLWithString:[_trends imageAtIndex:0]] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    }
    else
    {
        coverImageView.hidden = YES;
    }
    
    // 位置
    CGPoint position = CGPointMake(_fromSelf?10:70, rc.origin.y+(_trends.images.count>0?(rc.size.height+10):0));
    UIImageView *iconImageView = (UIImageView *)[bubbleImageView viewWithTag:kIconImageTag];
    iconImageView.frame = CGRectMake(position.x, position.y, 16, 16);
    
    UILabel *locationLabel = (UILabel *)[bubbleImageView viewWithTag:kLocationTag];
    locationLabel.frame = CGRectMake(position.x+20, position.y, 300-(position.x+20), 16);
    [locationLabel setText:[NSString stringWithFormat:@"位置 : %@", _trends.address.length > 0 ? _trends.address : @"未知"]];
    
    UILabel *groupLabel = (UILabel *)[bubbleImageView viewWithTag:kGroupTag];
    groupLabel.frame = CGRectMake(position.x, position.y+16, 300-position.x, 16);
    [groupLabel setText:[NSString stringWithFormat:@"圈子 : %@", _trends.weiba]];
    
    // 评论和点赞
    BHButton *commentButton = (BHButton *)[toolsBar.subviews objectAtIndex:0];
    [commentButton setImage:[UIImage imageNamed:@"icon_comment.png"] number:_trends.cnum];
    
    BHButton *praiseButton = (BHButton *)[toolsBar.subviews objectAtIndex:1];
    [praiseButton setImage:[UIImage imageNamed:_trends.digg ? @"icon_praised.png" : @"icon_praise.png"] number:_trends.dnum];
}

- (void)addPraise:(BOOL)toggle
{
    BHButton *praiseButton = (BHButton *)[toolsBar.subviews objectAtIndex:1];
    [praiseButton setImage:[UIImage imageNamed:toggle ? @"icon_praised.png" : @"icon_praise.png"] number:++_trends.dnum];
    [praiseButton setEnabled:NO];
}


#pragma mark -
#pragma mark private methods

- (void)addProfileBar:(BOOL)bSelf
{
    if ( !bSelf )
    {
        // 头像
        avatorButton = [[UIButton alloc] initWithFrame:CGRectMake(10.f, 10.f, 50.f, 50.f)];
        avatorButton.layer.masksToBounds = YES;
        avatorButton.layer.cornerRadius = 5.f;
        [avatorButton addTarget:self action:@selector(avatorAction:) forControlEvents:UIControlEventTouchUpInside];
        [bubbleImageView addSubview:avatorButton];
    }
    
    CGFloat x = bSelf ? 10.f : 70.f;
    
    // 昵称
    unameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 10.f, 140.f, 25.f)];
    unameLabel.backgroundColor = [UIColor clearColor];
    unameLabel.font = BOLD_FONT_SIZE(16);
    [bubbleImageView addSubview:unameLabel];
    
    // 日期
    timeBGImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_timeline.png" stretched:CGPointMake(10.f, 0.f)]];
    timeBGImageView.frame = CGRectMake(200.f, 10.f, 99.f, 20.f);
    [bubbleImageView addSubview:timeBGImageView];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210.f, 10.f, 80.f, 20.f)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = FONT_SIZE(12);
    timeLabel.textAlignment = UITextAlignmentRight;
    timeLabel.textColor = [UIColor whiteColor];
    [bubbleImageView addSubview:timeLabel];
    
    // 划线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, 40.f, (bSelf ? 310.f-x*2 : 230.f), 1.f)];
    line.backgroundColor = [UIColor flatWhiteColor];
    [bubbleImageView addSubview:line];
    [line release];
}

- (void)addContentView:(BOOL)bSelf
{
    CGFloat x = bSelf ? 10.f : 70.f;
    
    // 动态的内容
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 48.f, (bSelf ? 290.f : 230.f), 20.f)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = FONT_SIZE(14);
    contentLabel.numberOfLines = 0;
    [bubbleImageView addSubview:contentLabel];
    
    // 动态的图片
    coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 76.f, 60.f, 60.f)];
    coverImageView.backgroundColor = [UIColor clearColor];
    coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    coverImageView.userInteractionEnabled = YES;
    [bubbleImageView addSubview:coverImageView];
    coverImageView.hidden = YES;
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [coverImageView addGestureRecognizer:tap];
    [tap release];
    
    // 位置
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location.png"]];
    iconImageView.frame = CGRectMake(10.f, 80.f, 12.f, 12.f);
    iconImageView.tag = kIconImageTag;
    [bubbleImageView addSubview:iconImageView];
    [iconImageView release];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 80.f, 150.f, 16.f)];
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.tag = kLocationTag;
    locationLabel.font = FONT_SIZE(10);
    locationLabel.textColor = RGB(147, 202, 183);
    [bubbleImageView addSubview:locationLabel];
    [locationLabel release];
    
    UILabel *groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 96.f, 170.f, 16.f)];
    groupLabel.backgroundColor = [UIColor clearColor];
    groupLabel.tag = kGroupTag;
    groupLabel.font = FONT_SIZE(10);
    groupLabel.textColor = [UIColor darkGrayColor];
    [bubbleImageView addSubview:groupLabel];
    [groupLabel release];
}

- (void)addToolsBar
{
    toolsBar = [[UIView alloc] initWithFrame:CGRectMake(6.f, 220.f-41.f, 308.f, 39.f)];
    toolsBar.backgroundColor = [UIColor clearColor];
    [self addSubview:toolsBar];
    
    BHButton *commentButton = [[BHButton alloc] initWithFrame:CGRectMake(20.f, 6.f, 50.f, 28.f)];
    [commentButton setImage:[UIImage imageNamed:@"icon_comment.png"] number:0];
    [commentButton setTextColor:[UIColor flatBlueColor]];
    [commentButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [toolsBar addSubview:commentButton];
    [commentButton release];
    
    BHButton *praiseButton = [[BHButton alloc] initWithFrame:CGRectMake(240.f, 6.f, 50.f, 28.f)];
    [praiseButton setImage:[UIImage imageNamed:@"icon_praise.png"] number:0];
    [praiseButton setTextColor:[UIColor flatOrangeColor]];
    [praiseButton addTarget:self action:@selector(praise:) forControlEvents:UIControlEventTouchUpInside];
    [toolsBar addSubview:praiseButton];
    [praiseButton release];
    
    UIView *hline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 308, 1)];
    hline.backgroundColor = [UIColor flatWhiteColor];
    [toolsBar addSubview:hline];
    [hline release];
}


#pragma mark -
#pragma mark private methods

- (void)avatorAction:(id)sender
{
    if ( [self.delegate respondsToSelector:@selector(trendsCell:didSelectUser:)] )
    {
        [self.delegate trendsCell:self didSelectUser:self.trends.user];
    }
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if ( imageView == bubbleImageView )
    {
        if ( [self.delegate respondsToSelector:@selector(trendsCell:didSelectAtIndex:)] )
        {
            [self.delegate trendsCell:self didSelectAtIndex:self.row];
        }
    }
    else
    {
        if ( [self.delegate respondsToSelector:@selector(trendsCell:didSelectImageView:)] )
        {
            [self.delegate trendsCell:self didSelectImageView:imageView];
        }
    }
}

- (void)comment:(id)sender
{
    if ( [self.delegate respondsToSelector:@selector(trendsCellDidEnterComment:)] )
    {
        [self.delegate trendsCellDidEnterComment:self];
    }
}

- (void)praise:(id)sender
{
    if ( [BHUserModel sharedInstance].uid <= 0 )
    {
        [self presentMessageTips:@"请登录"];
        return;
    }
    
    if ( [self.delegate respondsToSelector:@selector(trendsCellDidStartPraise:)] )
    {
        [self.delegate trendsCellDidStartPraise:self];
    }
}

@end
