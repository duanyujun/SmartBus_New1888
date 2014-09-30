//
//  BHTrendsRelayInfo.m
//  SmartBus
//
//  Created by 王 正星 on 14-1-9.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHTrendsRelayInfo.h"
#import "UIImageView+WebCache.h"

@interface BHTrendsRelayInfo ()
{
    UIImageView *icon;
    UILabel *name;
    UILabel *content;
}

@end
@implementation BHTrendsRelayInfo

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(icon);
    SAFE_RELEASE_SUBVIEW(name);
    SAFE_RELEASE_SUBVIEW(content);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor flatWhiteColor]];
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(1.0f,1.0f);
        self.layer.shadowOpacity = .5f;
        self.layer.shadowRadius = 4.0f;
        
        icon = [[UIImageView alloc]initWithFrame:CGRectMake(5.f, 5.f, 50.f, 50.f)];
        [self addSubview:icon];
        
        name = [[UILabel alloc]initWithFrame:CGRectMake(60.f, 5.f, self.width - 70.f, 20.f)];
        [name setBackgroundColor:[UIColor clearColor]];
        [name setTextColor:[UIColor grayColor]];
        [name setFont:FONT_SIZE(14)];
        [self addSubview:name];
        
        content = [[UILabel alloc]initWithFrame:CGRectMake(60.f, 25.f, self.width - 70.f, 30.f)];
        [content setBackgroundColor:[UIColor clearColor]];
        [content setTextColor:[UIColor grayColor]];
        [content setNumberOfLines:0];
        [content setFont:FONT_SIZE(12.f)];
        [self addSubview:content];
        
    }
    return self;
}

- (void)setInfo:(BHTrendsModel *)info
{
    [icon setImageWithURL:[NSURL URLWithString:info.user.avator] placeholderImage:nil];
    
    [name setText:[NSString stringWithFormat:@"@%@",info.user.uname]];
    
    [content setText:info.content];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
