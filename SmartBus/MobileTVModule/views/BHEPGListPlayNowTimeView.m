//
//  BHEPGListPlayNowTimeView.m
//  SmartBus
//
//  Created by 王 正星 on 13-11-19.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHEPGListPlayNowTimeView.h"

#define TIME_TAG 12000

@implementation BHEPGListPlayNowTimeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:4.f];
        [self setBackgroundColor:[UIColor redColor]];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(5.f, 0.f, 20.f, 20.f)];
        [icon setImage:[UIImage imageNamed:@"icon_play"]];
        [self addSubview:icon];
        icon.centerY = self.height/2.f;
        [icon release];
        
        UILabel *timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(25.f, 2.f, 33.f, 16.f)];
        [timeLbl setTextColor:[UIColor whiteColor]];
        [timeLbl setTag:TIME_TAG];
        [timeLbl setFont:[UIFont systemFontOfSize:12.f]];
        [timeLbl setText:@"--:--"];
        [timeLbl setTextAlignment:NSTextAlignmentCenter];
        [timeLbl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:timeLbl];
        timeLbl.centerY = self.height/2.f;
        [timeLbl release];
    }
    return self;
}

- (void)setTime:(NSString *)time
{
    UILabel *timeLbl = (UILabel *)[self viewWithTag:TIME_TAG];
    [timeLbl setText:time];
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
