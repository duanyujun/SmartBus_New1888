//
//  BHPlayTimeView.m
//  SmartBus
//
//  Created by 王 正星 on 13-10-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPlayTimeView.h"

#define TIME_TAG 12000

@implementation BHPlayTimeView

- (id)initWithFrame:(CGRect)frame withType:(BHPlayTimeType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, 20.f, 20.f)];
        [icon setImage:[UIImage imageNamed:type == BHPlayTimeTypeBegin ?@"icon_play":@"icon_time"]];
        [self addSubview:icon];
        icon.centerY = self.height/2.f;
        [icon release];
        
        UILabel *timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(20.f, 2.f, 33.f, 16.f)];
        if (type == BHPlayTimeTypeBegin) {
            [timeLbl.layer setMasksToBounds:YES];
            [timeLbl.layer setCornerRadius:4.f];
            [timeLbl setBackgroundColor:[UIColor redColor]];
            [timeLbl setTextColor:[UIColor whiteColor]];
        }else{
            [timeLbl setBackgroundColor:[UIColor clearColor]];
            [timeLbl setTextColor:[UIColor lightGrayColor]];
        }
        [timeLbl setTag:TIME_TAG];
        [timeLbl setFont:[UIFont systemFontOfSize:12.f]];
        [timeLbl setText:@"--:--"];
        [timeLbl setTextAlignment:NSTextAlignmentCenter];
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
