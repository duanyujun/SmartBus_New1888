//
//  BHRegHeaderView.m
//  SmartBus
//
//  Created by 王 正星 on 13-12-16.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHRegHeaderView.h"
#import "NSDate+Helper.h"
#import "RTLabel.h"

@interface BHRegHeaderView ()
{
    BeeUIButton *button;
    UILabel *tips;
    RTLabel *con_tips;
    UIView *container;
    UIImageView *container_Bg;
}
@end

@implementation BHRegHeaderView

- (void)dealloc
{
    [super dealloc];
    SAFE_RELEASE_SUBVIEW(button);
    SAFE_RELEASE_SUBVIEW(tips);
    SAFE_RELEASE_SUBVIEW(con_tips);
    SAFE_RELEASE_SUBVIEW(container);
    SAFE_RELEASE_SUBVIEW(container_Bg);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        container = [[UIView alloc]initWithFrame:CGRectMake(10.f, 5.f, 300.f, frame.size.height-10.f)];
        container_Bg = [[UIImageView alloc]initWithFrame:container.bounds];
        [container_Bg setImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:5.f]];
        [container addSubview:container_Bg];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 10.f, 95.f/2.f,93.f/2.f)];
        [icon setImage:[UIImage imageNamed:@"registrat_Icon"]];
        [container addSubview:icon];
        [icon release];
        
        UILabel *dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.f, 10.f, 130.f, 20.f)];
        [dateLbl setFont:FONT_SIZE(14.f)];
        [dateLbl setText:[NSDate stringFromDate:[NSDate date] withFormat:@"yyyy年MM月dd日"]];
        [dateLbl setBackgroundColor:[UIColor clearColor]];
        [container addSubview:dateLbl];
        [dateLbl release];
        
        NSArray *weekArray = [[NSArray alloc]initWithObjects:@"星期天",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];


        UILabel *weekLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.f, 30.f, 130.f, 20.f)];
        [weekLbl setBackgroundColor:[UIColor clearColor]];
        [weekLbl setText:[weekArray objectAtIndex:[NSDate weekday]-1]];
        [weekLbl setTextColor:[UIColor redColor]];
        [weekLbl setFont:FONT_SIZE(12.f)];
        [container addSubview:weekLbl];
        [weekLbl release];
        
        button = [[BeeUIButton alloc]initWithFrame:CGRectMake(200.f, 10.f, 90.f, 30.f)];
        [button setSignal:@"regist"];
        [container addSubview:button];
        
        
        NSString *tipString = @"<font size=12 color=gray>已连续打卡<font size=12 color=red>0</font>天</font>";
        con_tips = [[RTLabel alloc]initWithFrame:CGRectMake(200.f, 45.f, 90.f, 20.f)];
        [con_tips setText:tipString];
        [con_tips setTextAlignment:RTTextAlignmentCenter];
        [con_tips setBackgroundColor:[UIColor clearColor]];
        [container addSubview:con_tips];
        
        tips = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 65.f, 290.f, 20.f)];
        [tips setText:@"恭喜打卡成功,获得x金币,明天继续加油吧"];
        [tips setFont:FONT_SIZE(12.f)];
        [tips setTextColor:[UIColor grayColor]];
        [tips setBackgroundColor:[UIColor clearColor]];
        [tips setTextAlignment:NSTextAlignmentRight];
        [tips setAlpha:0];
        [container addSubview:tips];
        
        [self addSubview:container];
    }
    return self;
}

- (void)setRegist:(BOOL)hasRegist
{
    [button setTitle:!hasRegist?@"打卡":@"已打卡" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hasRegist?@"task_regist_gray_btn":@"task_regist_red_btn"] forState:UIControlStateNormal];
    [button setEnabled:!hasRegist];
    
}

- (void)setConNum:(int)num
{
    [con_tips setText:[NSString stringWithFormat:@"<font size=12 color=gray>已连续打卡<font size=12 color=red>%d</font>天</font>",num]];
}

- (void)showTips:(int)num
{
    int lv = num/10;
    NSString *tipString = @"";
    switch (lv) {
        case 0:
            tipString = [NSString stringWithFormat:@"恭喜打卡成功，获得%d银币，明天继续加油吧",num];
            break;
        case 1:
            tipString = [NSString stringWithFormat:@"恭喜打卡成功，获得%d银币，今天运气不错呀",num];
            break;
        case 2:
            tipString = [NSString stringWithFormat:@"恭喜打卡成功，获得%d银币，土豪真耀眼啊",num];
            break;
            
        default:
            break;
    }
    [tips setText:tipString];
    [tips setAlpha:1];
    [container setFrame:CGRectMake(10.f, 10.f, 300.f, 90.f)];
    [container_Bg setFrame:container.bounds];
}

ON_SIGNAL2(BeeUIButton, signal)
{
    [super handleUISignal:signal];
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
