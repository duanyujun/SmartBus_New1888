//
//  BHUsersCell.m
//  SmartBus
//
//  Created by launching on 13-11-14.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHUsersCell.h"
#import "UIButton+WebCache.h"
#import "NSDate+Helper.h"

@interface BHUsersCell ()
{
    UIButton *avatorButton;
    UILabel *unameLabel;
    UIImageView *ugenderImageView;
    UILabel *uageLabel;
    UILabel *signatureLabel;
    UILabel *distanceLabel;
    
    BOOL __hideFocus;
}
@end

@implementation BHUsersCell

@synthesize user = _user;
@synthesize delegate = _delegate;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier hideFocus:(BOOL)hide
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        __hideFocus = hide;
        
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)]];
        bubbleImageView.frame = CGRectMake(10.f, 0.f, 300.f, kUsersCellHeight);
        [self.contentView addSubview:bubbleImageView];
        [bubbleImageView release];
        
        // 头像
        avatorButton = [[UIButton alloc] initWithFrame:CGRectMake(20.f, 8.f, 50.f, 50.f)];
        avatorButton.backgroundColor = [UIColor clearColor];
        avatorButton.layer.masksToBounds = YES;
        avatorButton.layer.cornerRadius = 5.f;
        [avatorButton addTarget:self action:@selector(avatorAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:avatorButton];
        
        // 昵称
        unameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.f, 8.f, 140.f, 25.f)];
        unameLabel.backgroundColor = [UIColor clearColor];
        unameLabel.font = FONT_SIZE(16);
        [self.contentView addSubview:unameLabel];
        
        // 图标ICONS
        ugenderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_male.png"]];
        ugenderImageView.frame = CGRectMake(80.f, 33.f, 14.f, 14.f);
        [self.contentView addSubview:ugenderImageView];
        
        // 年龄
        uageLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.f, 33.f, 80.f, 14.f)];
        uageLabel.backgroundColor = [UIColor clearColor];
        uageLabel.font = FONT_SIZE(12);
        [self.contentView addSubview:uageLabel];
        
        // 签名
        signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.f, 52.f, 210.f, 20.f)];
        signatureLabel.backgroundColor = [UIColor clearColor];
        signatureLabel.font = FONT_SIZE(12);
        [self.contentView addSubview:signatureLabel];
        
        if ( !hide )
        {
            UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            toggleButton.frame = CGRectMake(232.f, 18.f, 68.f, 30.f);
            [toggleButton setImage:[UIImage imageNamed:@"icon_addFollow.png"] forState:UIControlStateNormal];
            [toggleButton setImage:[UIImage imageNamed:@"icon_haveFollwed.png"] forState:UIControlStateSelected];
            [toggleButton addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:toggleButton];
        }
    }
    
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithReuseIdentifier:reuseIdentifier hideFocus:NO];
}

- (void)setUser:(BHUserModel *)user
{
    SAFE_RELEASE(_user);
    _user = [user retain];
    
    [avatorButton setImageWithURL:[NSURL URLWithString:user.avator] placeholderImage:[UIImage imageNamed:@"default_man.png"]];
    unameLabel.text = user.uname ? user.uname : @"游客";
    [ugenderImageView setImage:[UIImage imageNamed:user.ugender == 2 ? @"icon_female.png" : @"icon_male.png"]];
    [signatureLabel setText:user.signature];
    
    if ( user.birth && user.birth.length > 0 ) {
        [uageLabel setText:[NSString stringWithFormat:@"%d岁", [NSDate ageFromString:user.birth withFormat:[NSDate dateFormatString]]]];
    }
    
    if ( !__hideFocus )
    {
        UIButton *toggleButton = (UIButton *)[self.contentView.subviews objectAtIndex:6];
        toggleButton.selected = user.focused;
        toggleButton.hidden = (user.uid == [BHUserModel sharedInstance].uid);
    }
}


- (void)avatorAction:(UIButton *)sender
{
    if ( _user.uid == [BHUserModel sharedInstance].uid ) {
        return;
    }
    
    if ( [_delegate respondsToSelector:@selector(usersCellDidSelectAvator:)] )
    {
        [_delegate usersCellDidSelectAvator:self];
    }
}

- (void)toggle:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if ( [_delegate respondsToSelector:@selector(usersCell:toggleFocus:)] )
    {
        [_delegate usersCell:self toggleFocus:sender.selected];
    }
}

@end
