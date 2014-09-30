//
//  BHTrendsDesCell.m
//  SmartBus
//
//  Created by launching on 13-12-12.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTrendsDesCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "BHButton.h"
#import "NSDate+Helper.h"

@interface BHTrendsDesCell ()
{
    UIImageView *bubbleImageView;
    UIButton *avatorButton;
    UILabel *unameLabel;
    UIImageView *timeBGImageView;
    UILabel *timeLabel;
    UIImageView *genderImageView;
    UILabel *uageLabel;
    UILabel *contentLabel;
    UIImageView *contentImageView;
    UIView *toolsBar;
}
- (void)addProfileBar;
- (void)addContentView;
- (void)addToolsBar;
@end

#define kQZLabelTag  69354

@implementation BHTrendsDesCell

@synthesize trends = _trends;
@synthesize delegate = _delegate;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(bubbleImageView);
    SAFE_RELEASE_SUBVIEW(avatorButton);
    SAFE_RELEASE_SUBVIEW(unameLabel);
    SAFE_RELEASE_SUBVIEW(timeLabel);
    SAFE_RELEASE_SUBVIEW(genderImageView);
    SAFE_RELEASE_SUBVIEW(uageLabel);
    SAFE_RELEASE_SUBVIEW(contentLabel);
    SAFE_RELEASE_SUBVIEW(contentImageView);
    SAFE_RELEASE_SUBVIEW(toolsBar);
    SAFE_RELEASE(_trends)
    _delegate = nil;
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        // 背景图片
        bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f]];
        bubbleImageView.frame = CGRectMake(10.f, 3.f, 300.f, 220.f);
        bubbleImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:bubbleImageView];
        
        [self addProfileBar];
        [self addContentView];
        [self addToolsBar];
    }
    return self;
}


#pragma mark -
#pragma mark public methods

- (void)setTrends:(BHTrendsModel *)trends
{
    SAFE_RELEASE(_trends);
    _trends = [trends retain];
    
    CGFloat height = [_trends getDescHeight];
    [bubbleImageView setFrame:CGRectMake(10.f, 3.f, 300.f, height)];
    [toolsBar setFrame:CGRectMake(2.f, height-80.f, 296.f, 80.f)];
    
    // 用户信息栏
    [avatorButton setImageWithURL:[NSURL URLWithString:_trends.user.avator]
                 placeholderImage:[UIImage imageNamed:@"default_man.png"]];
    
    [unameLabel setText:_trends.user.uname];
    
    NSString *timesAgo = [NSDate stringTimesAgo:_trends.ctime];
    CGSize size = [timesAgo sizeWithFont:FONT_SIZE(12) byWidth:300.f];
    size.width += 20.f;
    [timeLabel setFrame:CGRectMake(300.f-size.width-6.f, 10.f, size.width, 20.f)];
    [timeLabel setText:timesAgo];
    [timeBGImageView setFrame:CGRectMake(300.f-size.width, 10.F, size.width-1.f, 20.f)];
    
    [genderImageView setImage:[UIImage imageNamed: _trends.user.ugender == USER_GENDER_FEMALE ? @"icon_female.png" : @"icon_male.png"]];
    
    if ( _trends.user.birth && _trends.user.birth.length > 0 )
    {
        [uageLabel setText:[NSString stringWithFormat:@"%d岁", [NSDate ageFromString:_trends.user.birth withFormat:@"yyyy-MM-dd"]]];
    }
    
    // 正文栏
    size = [_trends.content sizeWithFont:FONT_SIZE(14) byWidth:220.f];
    //NSString *content = [_trends]
    [contentLabel setText:_trends.content];
    
    CGRect rc = contentLabel.frame;
    rc.size.height = size.height;
    contentLabel.frame = rc;
    
    rc = contentImageView.frame;
    rc.origin.y = contentLabel.frame.origin.y + contentLabel.frame.size.height + 8.f;
    contentImageView.frame = rc;
    
    if ( _trends.images.count > 0 )
    {
        contentImageView.hidden = NO;
        [contentImageView setImageWithURL:[NSURL URLWithString:[_trends imageAtIndex:0]] placeholderImage:[UIImage imageNamed:@"pic_defalut.png"]];
    }
    else
    {
        contentImageView.hidden = YES;
    }
    
    // 工具栏
    UILabel *locationLabel = (UILabel *)[toolsBar.subviews objectAtIndex:1];
    [locationLabel setText:_trends.address.length > 0 ? _trends.address : @"未知"];
    
    BHButton *commentButton = (BHButton *)[toolsBar.subviews objectAtIndex:2];
    [commentButton setImage:[UIImage imageNamed:@"icon_comment.png"] number:_trends.cnum];
    
    BHButton *praiseButton = (BHButton *)[toolsBar.subviews objectAtIndex:3];
    [praiseButton setImage:[UIImage imageNamed:_trends.digg ? @"icon_praised.png" : @"icon_praise.png"] number:_trends.dnum];
    
    UIButton *button = (UIButton *)[toolsBar.subviews objectAtIndex:4];
    UILabel *qzLabel = (UILabel *)[button viewWithTag:kQZLabelTag];
    [qzLabel setText:_trends.weiba];
}

- (void)addPraise:(BOOL)toggle
{
    BHButton *praiseButton = (BHButton *)[toolsBar.subviews objectAtIndex:3];
    [praiseButton setImage:[UIImage imageNamed:toggle ? @"icon_praised.png" : @"icon_praise.png"] number:++_trends.dnum];
    [praiseButton setEnabled:NO];
}


#pragma mark -
#pragma mark private methods

- (void)addProfileBar
{
    // 头像
    avatorButton = [[UIButton alloc] initWithFrame:CGRectMake(10.f, 10.f, 50.f, 50.f)];
    avatorButton.layer.masksToBounds = YES;
    avatorButton.layer.cornerRadius = 5.f;
    [avatorButton addTarget:self action:@selector(avatorAction:) forControlEvents:UIControlEventTouchUpInside];
    [bubbleImageView addSubview:avatorButton];
    
    // 昵称
    unameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.f, 10.f, 140.f, 25.f)];
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
    
    // 性别
    genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70.f, 40.f, 14.f, 14.f)];
    [bubbleImageView addSubview:genderImageView];
    
    // 年龄
    uageLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.f, 40.f, 80.f, 14.f)];
    uageLabel.backgroundColor = [UIColor clearColor];
    uageLabel.font = FONT_SIZE(12);
    uageLabel.textColor = [UIColor darkGrayColor];
    [bubbleImageView addSubview:uageLabel];
    
    // 划线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(70.f, 59.f, 220.f, 1.f)];
    line.backgroundColor = [UIColor flatWhiteColor];
    [bubbleImageView addSubview:line];
    [line release];
}

- (void)addContentView
{
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.f, 68.f, 220.f, 20.f)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = FONT_SIZE(14);
    contentLabel.numberOfLines = 0;
    [bubbleImageView addSubview:contentLabel];
    
    contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70.f, 96.f, 60.f, 60.f)];
    contentImageView.backgroundColor = [UIColor clearColor];
    contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    contentImageView.userInteractionEnabled = YES;
    [bubbleImageView addSubview:contentImageView];
    contentImageView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [contentImageView addGestureRecognizer:tap];
    [tap release];
}

- (void)addToolsBar
{
    toolsBar = [[UIView alloc] initWithFrame:CGRectMake(2.f, 220.f-80.f, 296.f, 80.f)];
    [bubbleImageView addSubview:toolsBar];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location.png"]];
    iconImageView.frame = CGRectMake(10.f, 14.f, 12.f, 12.f);
    [toolsBar addSubview:iconImageView];
    [iconImageView release];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.f, 12.f, 150.f, 16.f)];
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.font = FONT_SIZE(10);
    locationLabel.textColor = RGB(147, 202, 183);
    [toolsBar addSubview:locationLabel];
    [locationLabel release];
    
    BHButton *commentButton = [[BHButton alloc] initWithFrame:CGRectMake(180.f, 6.f, 50.f, 28.f)];
    [commentButton setBackgroundImage:[UIImage imageNamed:@"bg_comment_hl.png" stretched:CGPointMake(7.f, 0.f)]];
    [commentButton setImage:[UIImage imageNamed:@"icon_comment.png"] number:0];
    [commentButton setTextColor:[UIColor whiteColor]];
    [toolsBar addSubview:commentButton];
    [commentButton release];
    
    BHButton *praiseButton = [[BHButton alloc] initWithFrame:CGRectMake(240.f, 6.f, 50.f, 28.f)];
    [praiseButton setImage:[UIImage imageNamed:@"icon_praise.png"] number:0];
    [praiseButton setTextColor:[UIColor flatOrangeColor]];
    [praiseButton addTarget:self action:@selector(praise:) forControlEvents:UIControlEventTouchUpInside];
    [toolsBar addSubview:praiseButton];
    [praiseButton release];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15.f, 40.f, 270.f, 32.f);
    button.backgroundColor = [UIColor clearColor];
    [button setBackgroundImage:[UIImage imageNamed:@"bg_quanzi.png" stretched:CGPointMake(15.f, 0.f)] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(qzAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *qzImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_quanzi.png"]];
    qzImageView.frame = CGRectMake(10.f, 7.f, 18.f, 18.f);
    [button addSubview:qzImageView];
    [qzImageView release];
    
    UILabel *qzLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.f, 7.f, 210.f, 18.f)];
    qzLabel.backgroundColor = [UIColor clearColor];
    qzLabel.tag = kQZLabelTag;
    qzLabel.font = FONT_SIZE(12);
    qzLabel.textColor = [UIColor darkGrayColor];
    [button addSubview:qzLabel];
    [qzLabel release];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right_arrow.png"]];
    arrowImageView.frame = CGRectMake(254.f, 10.f, 6.f, 12.f);
    [button addSubview:arrowImageView];
    [arrowImageView release];
    
    [toolsBar addSubview:button];
}


#pragma mark -
#pragma mark button events

- (void)avatorAction:(id)sender
{
    if ( [self.delegate respondsToSelector:@selector(trendsDesCell:didSelectUser:)] )
    {
        [self.delegate trendsDesCell:self didSelectUser:self.trends.user];
    }
}

- (void)qzAction:(id)sender
{
    if ( [self.delegate respondsToSelector:@selector(trendsDesCellDidEnterWeiba:)] )
    {
        [self.delegate trendsDesCellDidEnterWeiba:self];
    }
}

- (void)praise:(id)sender
{
    if ( [BHUserModel sharedInstance].uid <= 0 )
    {
        [self presentMessageTips:@"请登录"];
        return;
    }
    
    if ( [self.delegate respondsToSelector:@selector(trendsDesCellDidStartPraise:)] )
    {
        [self.delegate trendsDesCellDidStartPraise:self];
    }
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    if ( [self.delegate respondsToSelector:@selector(trendsDesCell:didSelectImageView:)] )
    {
        [self.delegate trendsDesCell:self didSelectImageView:(UIImageView *)recognizer.view];
    }
}

@end
