//
//  BHProfileHeader.m
//  SmartBus
//
//  Created by launching on 13-11-8.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHProfileHeader.h"
#import "UIButton+WebCache.h"

@interface BHProfileHeader ()
{
    UIButton *avatorButton;
    UILabel *unameLabel;
    UIImageView *genderImageView;
    UILabel *addressLabel;
    UILabel *scoreLabel;
    
    id<BHProfileDelegate> _delegate;
    NSInteger _selectIndex;
    BOOL _foucs;
}
- (void)setSelected:(BOOL)selected onButton:(UIButton *)button;
@end

#define kAttentBtnTag  68721
#define kFoucsBtnTag   68722
#define kItemBaseTag   7451

@implementation BHProfileHeader

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(avatorButton);
    SAFE_RELEASE_SUBVIEW(unameLabel);
    SAFE_RELEASE_SUBVIEW(genderImageView);
    _delegate = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<BHProfileDelegate>)delegate
{
    if ( self = [super initWithFrame:frame] )
    {
        _delegate = delegate;
        _selectIndex = NSNotFound;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowOpacity = 0.7f;
        self.layer.shadowRadius = 1.f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.3f);
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        // 背景图
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_bg.png"]];
        backgroundImageView.frame = CGRectMake(0.f, 0.f, 320.f, 95.f);
        backgroundImageView.userInteractionEnabled = YES;
        [self addSubview:backgroundImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [backgroundImageView addGestureRecognizer:tap];
        [tap release];
        [backgroundImageView release];
        
        // 头像
        avatorButton = [[UIButton alloc] initWithFrame:CGRectMake(10.f, 55.f, 70.f, 70.f)];
        avatorButton.backgroundColor = [UIColor clearColor];
        avatorButton.layer.masksToBounds = YES;
        avatorButton.layer.cornerRadius = 8.f;
        avatorButton.layer.shadowOpacity = 0.7f;
        avatorButton.layer.shadowRadius = 1.f;
        avatorButton.layer.shadowOffset = CGSizeMake(0.0f, 0.3f);
        avatorButton.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        [avatorButton addTarget:self action:@selector(avatorAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:avatorButton];
        
        // 用户名
        unameLabel = [[UILabel alloc] initWithFrame:CGRectMake(88.f, 70.f, 100.f, 20.f)];
        unameLabel.backgroundColor = [UIColor clearColor];
        unameLabel.font = BOLD_FONT_SIZE(16);
        unameLabel.textColor = [UIColor whiteColor];
        [self addSubview:unameLabel];
        
        // 性别
        genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(188.f, 72.f, 16.f, 16.f)];
        [self addSubview:genderImageView];
        
        // 地址
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(210.f, 75.f, 100.f, 15.f)];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.font = FONT_SIZE(12);
        addressLabel.textColor = [UIColor whiteColor];
        addressLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:addressLabel];
        
        // 积分
        UIImageView *scoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_reward.png"]];
        scoreImageView.frame = CGRectMake(88.f, 105.f, 14.f, 14.f);
        [self addSubview:scoreImageView];
        [scoreImageView release];
        
        scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(108.f, 105.f, 80.f, 16.f)];
        scoreLabel.backgroundColor = [UIColor clearColor];
        
        scoreLabel.font = FONT_SIZE(12);
        scoreLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:scoreLabel];
        
        // 划线
        UIView *hline = [[UIView alloc] initWithFrame:CGRectMake(0.f, 135.f, 320.f, 1.f)];
        hline.backgroundColor = [UIColor flatWhiteColor];
        [self addSubview:hline];
        [hline release];
        
        // 选项
        NSArray *items = [NSArray arrayWithObjects:@"动态", @"相册", @"关注", @"粉丝", nil];
        for (int i = 0; i < items.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(80.f*i, 135.f, 80.f, 45.f);
            button.backgroundColor = [UIColor clearColor];
            button.tag = kItemBaseTag + i;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 5.f, 70.f, 20.f)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = BOLD_FONT_SIZE(15);
            titleLabel.textColor = [UIColor darkGrayColor];
            titleLabel.textAlignment = UITextAlignmentCenter;
            titleLabel.text = @"0";
            [button addSubview:titleLabel];
            [titleLabel release];
            
            UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 25.f, 70.f, 15.f)];
            subtitleLabel.backgroundColor = [UIColor clearColor];
            subtitleLabel.font = FONT_SIZE(12);
            subtitleLabel.textColor = [UIColor lightGrayColor];
            subtitleLabel.textAlignment = UITextAlignmentCenter;
            subtitleLabel.text = items[i];
            [button addSubview:subtitleLabel];
            [subtitleLabel release];
            
            // 竖线
            if ( i < items.count - 1 )
            {
                UIView *vline = [[UIView alloc] initWithFrame:CGRectMake(79.f, 0.f, 1.f, 45.f)];
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

- (void)setSelectAtIndex:(NSInteger)idx
{
    if ( _selectIndex == idx ) return;
    
    UIButton *button = (UIButton *)[self viewWithTag:kItemBaseTag + idx];
    [self itemAction:button];
    
    _selectIndex = idx;
}

- (void)reloadUserData:(BHUserModel *)user
{
    [avatorButton setImageWithURL:[NSURL URLWithString:user.avator] placeholderImage:[UIImage imageNamed:@"default_man.png"]];
    
    CGSize size = [user.uname sizeWithFont:BOLD_FONT_SIZE(16) byWidth:200.f];
    [unameLabel setFrame:CGRectMake(88.f, 70.f, size.width, 20.f)];
    unameLabel.text = user.uname;
    
    [genderImageView setFrame:CGRectMake(93.f+size.width, 72.f, 16.f, 16.f)];
    if ( [BHUserModel sharedInstance].ugender == 1 ) {
        genderImageView.image = [UIImage imageNamed:@"icon_male.png"];
    } else if ( [BHUserModel sharedInstance].ugender == 2 ) {
        genderImageView.image = [UIImage imageNamed:@"icon_female.png"];
    }
    
    size = [[BHUserModel sharedInstance].location sizeWithFont:FONT_SIZE(12) byWidth:100.f];
    [addressLabel setFrame:CGRectMake(315.f-size.width, 75.f, size.width, 15.f)];
    addressLabel.text = [BHUserModel sharedInstance].location;
    
    scoreLabel.text = user.score;
}

- (void)reloadNumbers:(BHUserModel *)user
{
    NSInteger number = 0;
    for (int i = 0; i < 4; i++)
    {
        switch ( i )
        {
            case 0:
                number = user.bbsnum;
                break;
            case 1:
                number = user.picnum;
                break;
            case 2:
                number = user.attnum;
                break;
            case 3:
                number = user.fansnum;
                break;
            default:
                number = 0;
                break;
        }
        
        UIButton *button = (UIButton *)[self viewWithTag:kItemBaseTag + i];
        UILabel *titleLabel = (UILabel *)[button.subviews objectAtIndex:0];
        [titleLabel setText:[NSString stringWithFormat:@"%d", number]];
    }
}

- (void)setNumber:(NSInteger)number atIndex:(NSInteger)idx
{
    UIButton *button = (UIButton *)[self viewWithTag:kItemBaseTag + idx];
    UILabel *titleLabel = (UILabel *)[button.subviews objectAtIndex:0];
    [titleLabel setText:[NSString stringWithFormat:@"%d", number]];
}

- (NSInteger)numberAtIndex:(NSInteger)idx
{
    UIButton *button = (UIButton *)[self viewWithTag:kItemBaseTag + idx];
    UILabel *titleLabel = (UILabel *)[button.subviews objectAtIndex:0];
    return [titleLabel.text integerValue];
}

- (void)setTargetUser:(NSInteger)userId
{
    if ( userId != [BHUserModel sharedInstance].uid )
    {
        UIButton *msgbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        msgbutton.frame = CGRectMake(190.f, 100.f, 56.f, 25.f);
        msgbutton.backgroundColor = [UIColor flatDarkRedColor];
        msgbutton.layer.masksToBounds = YES;
        msgbutton.layer.cornerRadius = 3.f;
        msgbutton.titleLabel.font = FONT_SIZE(12);
        [msgbutton setTitle:@"私信Ta" forState:UIControlStateNormal];
        [msgbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [msgbutton addTarget:self action:@selector(sendMsgAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:msgbutton];
        
        UIButton *foucsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        foucsButton.frame = CGRectMake(255.f, 100.f, 56.f, 25.f);
        foucsButton.tag = kFoucsBtnTag;
        foucsButton.layer.masksToBounds = YES;
        foucsButton.layer.cornerRadius = 3.f;
        [foucsButton setImage:[UIImage imageNamed:@"icon_addFollow.png"] forState:UIControlStateNormal];
        [foucsButton setImage:[UIImage imageNamed:@"icon_haveFollwed.png"] forState:UIControlStateSelected];
        [foucsButton addTarget:self action:@selector(foucsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:foucsButton];
    }
    else
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(255.f, 100.f, 56.f, 25.f);
        button.backgroundColor = [UIColor flatDarkRedColor];
        button.layer.cornerRadius = 3.f;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = FONT_SIZE(12);
        [button setTitle:@"我的私信" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selfMsgAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)toggleFoucs:(BOOL)foucs
{
    _foucs = foucs;
    UIButton *button = (UIButton *)[self viewWithTag:kFoucsBtnTag];
    button.selected = _foucs;
}


#pragma mark - 
#pragma mark private methods

- (void)setSelected:(BOOL)selected onButton:(UIButton *)button
{
    UILabel *titleLabel = (UILabel *)[button.subviews objectAtIndex:0];
    UILabel *subtitleLabel = (UILabel *)[button.subviews objectAtIndex:1];
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

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    if ( [_delegate respondsToSelector:@selector(profileHeaderDidSelectBackDrop:)] )
    {
        [_delegate profileHeaderDidSelectBackDrop:self];
    }
}

- (void)avatorAction:(UIButton *)sender
{
    if ( [_delegate respondsToSelector:@selector(profileHeaderDidSelectAvator:)] )
    {
        [_delegate profileHeaderDidSelectAvator:self];
    }
}

- (void)itemAction:(UIButton *)sender
{
    for (int i = 0; i < 4; i++)
    {
        UIButton *button = (UIButton *)[self viewWithTag:kItemBaseTag + i];
        [self setSelected:NO onButton:button];
    }
    
    [self setSelected:YES onButton:sender];
    
    if ( [_delegate respondsToSelector:@selector(profileHeader:didSelectAtIndex:)] )
    {
        [_delegate profileHeader:self didSelectAtIndex:sender.tag - kItemBaseTag];
    }
}

- (void)sendMsgAction:(UIButton *)sender
{
    if ( [_delegate respondsToSelector:@selector(profileHeaderDidSendMessage:)] )
    {
        [_delegate profileHeaderDidSendMessage:self];
    }
}

- (void)selfMsgAction:(UIButton *)sender
{
    if ( [_delegate respondsToSelector:@selector(profileHeaderDidSelectSelfMessage:)] )
    {
        [_delegate profileHeaderDidSelectSelfMessage:self];
    }
}

- (void)foucsAction:(UIButton *)sender
{
    if ( [_delegate respondsToSelector:@selector(profileHeader:didToggleFoucs:)] )
    {
        [_delegate profileHeader:self didToggleFoucs:_foucs];
    }
}

@end
