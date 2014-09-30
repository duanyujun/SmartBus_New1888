//
//  BHChannelTagView.m
//  SmartBus
//
//  Created by 王 正星 on 13-10-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHChannelTagView.h"
#import "UIImageView+WebCache.h"

#define ICON_TAG 12000
#define TITLE_TAG   12001
#define BG_TAG  12002

@implementation BHChannelTagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:238/255.f green:238/255.f blue:238/255.f alpha:0.8];
        
        UIImageView *bg = [[UIImageView alloc]initWithFrame:self.frame];
        [bg setTag:BG_TAG];
        [self addSubview:bg];
        [bg release];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, 25.f, 25.f)];
        [icon setTag:ICON_TAG];
        [self addSubview:icon];
        icon.center = CGPointMake(15.f, self.height/2.f);
        [icon release];
        
        UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(30.f, 0.f, self.width-30.f, 20.f)];
        [titleLbl setBackgroundColor:[UIColor clearColor]];
        [titleLbl setTag:TITLE_TAG];
        [titleLbl setFont:[UIFont systemFontOfSize:12.f]];
        [self addSubview:titleLbl];
        titleLbl.center = CGPointMake(28+titleLbl.width/2.f, self.height/2.f);
        [titleLbl release];
    }
    return self;
}


- (void)setTitle:(NSString *)title withIconUrl:(NSString *)url withBg:(UIImage *)img
{
    UIImageView *bg = (UIImageView*)[self viewWithTag:BG_TAG];
    [bg setImage:img];
    
    UIImageView *icon = (UIImageView *)[self viewWithTag:ICON_TAG];
    [icon setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    UILabel *titleLbl = (UILabel *)[self viewWithTag:TITLE_TAG];
    [titleLbl setText:title];
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
