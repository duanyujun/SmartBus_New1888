//
//  BHGroupHeader.m
//  SmartBus
//
//  Created by launching on 13-12-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHGroupHeader.h"
#import "UIButton+WebCache.h"
#import "BHGroupModel.h"

@interface BHGroupHeader ()
{
    UIButton *coverButton;
    UILabel *gnameLabel;
    
    id<BHGroupHeaderDelegate> _delegate;
    BOOL _foucs;
}

- (void)setSelected:(BOOL)selected onButton:(UIButton *)button;

@end

#define kToggleBtnTag   21500
#define kTitleLabelTag  21501
#define kSubTitleLblTag 21502
#define kItemBaseTag    21641

@implementation BHGroupHeader

@synthesize selectedIndex = __selectedIndex;

- (id)initWithFrame:(CGRect)frame delegate:(id<BHGroupHeaderDelegate>)delegate
{
    if ( self = [super initWithFrame:frame] )
    {
        _delegate = delegate;
        __selectedIndex = NSNotFound;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowOpacity = 0.7f;
        self.layer.shadowRadius = 1.f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.3f);
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        // 背景图
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_bg.png"]];
        backgroundImageView.frame = CGRectMake(0.f, 0.f, 320.f, 95.f);
        [self addSubview:backgroundImageView];
        [backgroundImageView release];
        
        // 头像
        coverButton = [[UIButton alloc] initWithFrame:CGRectMake(10.f, 55.f, 70.f, 70.f)];
        coverButton.backgroundColor = [UIColor whiteColor];
        coverButton.layer.masksToBounds = YES;
        coverButton.layer.cornerRadius = 8.f;
        coverButton.layer.shadowColor = [UIColor blackColor].CGColor;
        coverButton.layer.shadowOffset = CGSizeMake(0, 1);
        coverButton.layer.shadowOpacity = 0.8;
        coverButton.layer.shadowRadius = 8.f;
        //[coverButton addTarget:self action:@selector(coverAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coverButton];
        
        // 用户名
        gnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(88.f, 70.f, 220.f, 20.f)];
        gnameLabel.backgroundColor = [UIColor clearColor];
        gnameLabel.font = BOLD_FONT_SIZE(16);
        gnameLabel.textColor = [UIColor whiteColor];
        [self addSubview:gnameLabel];
        
        // 发帖
        UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        createButton.frame = CGRectMake(88.f, 100.f, 60.f, 25.f);
        [createButton setImage:[UIImage imageNamed:@"btn_fatie.png"] forState:UIControlStateNormal];
        [createButton addTarget:self action:@selector(createPosts:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:createButton];
        
        // 关注/取消关注
        UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toggleButton.frame = CGRectMake(160.f, 100.f, 60.f, 25.f);
        toggleButton.tag = kToggleBtnTag;
        [toggleButton setImage:[UIImage imageNamed:@"icon_addFollow.png"] forState:UIControlStateNormal];
        [toggleButton setImage:[UIImage imageNamed:@"icon_haveFollwed.png"] forState:UIControlStateSelected];
        [toggleButton addTarget:self action:@selector(foucsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:toggleButton];
        
        // 划线
        UIView *hline = [[UIView alloc] initWithFrame:CGRectMake(0.f, 135.f, 320.f, 1.f)];
        hline.backgroundColor = [UIColor flatWhiteColor];
        [self addSubview:hline];
        [hline release];
        
        // 选项
        NSArray *items = [NSArray arrayWithObjects:@"圈子详情", @"帖子", @"粉丝", nil];
        CGFloat kWidth = 320.f / items.count;
        for (int i = 0; i < items.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(kWidth*i, 135.f, kWidth, 45.f);
            button.backgroundColor = [UIColor clearColor];
            button.tag = kItemBaseTag + i;
            
            CGRect frame = i > 0 ? CGRectMake(5.f, 5.f, kWidth-10.f, 20.f) : CGRectMake((kWidth-30.f)/2, 5.f, 30.f, 35.f);
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.tag = kTitleLabelTag;
            titleLabel.font = i > 0 ? BOLD_FONT_SIZE(15) : BOLD_FONT_SIZE(12);
            titleLabel.textColor = [UIColor darkGrayColor];
            titleLabel.textAlignment = UITextAlignmentCenter;
            titleLabel.numberOfLines = 0;
            titleLabel.text = i > 0 ? @"0" : [items objectAtIndex:0];
            [button addSubview:titleLabel];
            [titleLabel release];
            
            if ( i > 0 )
            {
                UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 25.f, kWidth-10.f, 15.f)];
                subtitleLabel.backgroundColor = [UIColor clearColor];
                subtitleLabel.tag = kSubTitleLblTag;
                subtitleLabel.font = FONT_SIZE(12);
                subtitleLabel.textColor = [UIColor lightGrayColor];
                subtitleLabel.textAlignment = UITextAlignmentCenter;
                subtitleLabel.text = items[i];
                [button addSubview:subtitleLabel];
                [subtitleLabel release];
            }
            
            // 竖线
            if ( i < items.count - 1 )
            {
                UIView *vline = [[UIView alloc] initWithFrame:CGRectMake(kWidth-1.f, 0.f, 1.f, 45.f)];
                vline.backgroundColor = [UIColor flatWhiteColor];
                [button addSubview:vline];
                [vline release];
            }
            
            [button addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    return self;
}


#pragma mark -
#pragma mark public methods

- (void)reloadGroupData:(BHGroupModel *)group
{
    [coverButton setImageWithURL:[NSURL URLWithString:group.cover] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    gnameLabel.text = group.gpname;
    
    // 更新帖子数
    UIButton *button = (UIButton *)[self viewWithTag:kItemBaseTag + 1];
    UILabel *titleLabel = (UILabel *)[button viewWithTag:kTitleLabelTag];
    [titleLabel setText:[NSString stringWithFormat:@"%d", group.postnum]];
    
    // 跟新关注数
    button = (UIButton *)[self viewWithTag:kItemBaseTag + 2];
    titleLabel = (UILabel *)[button viewWithTag:kTitleLabelTag];
    [titleLabel setText:[NSString stringWithFormat:@"%d", group.attnum]];
}

- (void)toggleFoucs:(BOOL)foucs
{
    _foucs = foucs;
    UIButton *button = (UIButton *)[self viewWithTag:kToggleBtnTag];
    button.selected = _foucs;
}


#pragma mark -
#pragma mark getter / setter methods

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if ( __selectedIndex == selectedIndex ) return;
    
    UIButton *button = (UIButton *)[self viewWithTag:kItemBaseTag + selectedIndex];
    [self itemAction:button];
    
    __selectedIndex = selectedIndex;
}


#pragma mark -
#pragma mark private methods

- (void)setSelected:(BOOL)selected onButton:(UIButton *)button
{
    UILabel *titleLabel = (UILabel *)[button viewWithTag:kTitleLabelTag];
    UILabel *subtitleLabel = (UILabel *)[button viewWithTag:kSubTitleLblTag];
    if ( selected )
    {
        [titleLabel setTextColor:[UIColor flatRedColor]];
        [subtitleLabel setTextColor:[UIColor flatRedColor]];
    }
    else
    {
        [titleLabel setTextColor:[UIColor darkGrayColor]];
        [subtitleLabel setTextColor:[UIColor lightGrayColor]];
    }
}


#pragma mark -
#pragma mark button events

- (void)createPosts:(id)sender
{
    if ( [_delegate respondsToSelector:@selector(groupHeaderDidCreatePosts:)] )
    {
        [_delegate groupHeaderDidCreatePosts:self];
    }
}

- (void)foucsAction:(id)sender
{
    if ( [_delegate respondsToSelector:@selector(groupHeader:toggleFoucs:)] )
    {
        [_delegate groupHeader:self toggleFoucs:_foucs];
    }
}

- (void)itemAction:(id)sender
{
    for (int i = 0; i < 3; i++)
    {
        UIButton *button = (UIButton *)[self viewWithTag:kItemBaseTag + i];
        [self setSelected:NO onButton:button];
    }
    
    [self setSelected:YES onButton:sender];
    
    if ( [_delegate respondsToSelector:@selector(groupHeader:didSelectAtIndex:)] )
    {
        [_delegate groupHeader:self didSelectAtIndex:[sender tag] - kItemBaseTag];
    }
}

@end
