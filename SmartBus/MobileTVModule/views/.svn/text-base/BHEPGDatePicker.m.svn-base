//
//  BHEPGDatePicker.m
//  SmartBus
//
//  Created by 王 正星 on 13-10-24.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHEPGDatePicker.h"

#define LABEL_WEEK_TAG  1101
#define LABEL_DATE_TAG  1102
@implementation BHEPGDatePicker
@synthesize delegate;
@synthesize weekindex,selectIndex;

- (id)initWithFrame:(CGRect)frame withDelegate:(id)dele
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor flatGrayColor];
        m_epgdate = [[NSMutableArray alloc]init];
        self.datedelegate = dele;
//        [self initBackground];
        [self initAll];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setContentOffset:CGPointMake(7*80-320.f, 0)];
    }
    return self;
}

- (void)dealloc
{
    [m_epgdate release];
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    [super dealloc];
}

- (void)initAll
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *datetime;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    datetime = [NSDate date];
    comps = [calendar components:unitFlags fromDate:datetime];
    weekindex = [comps weekday];
    
    CGFloat height = 44.f;
    CGFloat width = 80.f;
    CGFloat left = 0;
    CGFloat top = 0;
    
    NSArray *weekArray = [[NSArray alloc]initWithObjects:@"星期天",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    int line = 0;
    for (int i = weekindex-7; i < 7; i++) {
        if (i > weekindex-7) {
            UIImageView *separatLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_separat.png"]];
            separatLine.frame = CGRectMake(line*width +left - 5.f, 10.f, 10.f, 24.f);
            [self addSubview:separatLine];
            [separatLine release];
        }
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(line*width +left, top, width, height)];
        control.tag = line+1000;
        [control setBackgroundColor:[UIColor clearColor]];
        [control addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        line++;
        
        CGFloat labelTop = (height-20-12)/2.0;
        UILabel * lblweek = [[[UILabel alloc]initWithFrame:CGRectMake(0, labelTop, width, 20)] autorelease];
        [lblweek setText:[weekArray objectAtIndex:i>=0?i:i+7]];
        [lblweek setBackgroundColor:[UIColor clearColor]];
        [lblweek setFont:[UIFont systemFontOfSize:12]];
        [lblweek setTag:LABEL_WEEK_TAG];
        lblweek.textAlignment = UITextAlignmentCenter;
        [control addSubview:lblweek];
        
        labelTop += 20;
        UILabel * lbldate = [[[UILabel alloc]initWithFrame:CGRectMake(0, labelTop, width, 12)] autorelease];
        [lbldate setFont:[UIFont systemFontOfSize:10]];
        [lbldate setBackgroundColor:[UIColor clearColor]];
        [lbldate setTextColor:[UIColor grayColor]];
        [lbldate setTag:LABEL_DATE_TAG];
        lbldate.textAlignment = UITextAlignmentCenter;
        [control addSubview:lbldate];
        
        [self addSubview:control];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        if (weekindex == i+1)
        {
            lbldate.text = @"今天";
            lbldate.textColor = [UIColor redColor];
            lblweek.textColor = [UIColor redColor];
            selectIndex = line-1;
            NSLog(@"select Index = %d vs %d",selectIndex,control.tag-1000);
            [m_epgdate addObject:[dateFormatter stringFromDate:[NSDate date]]];
            redLine = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, width, 3)];
            [redLine setBackgroundColor:[UIColor redColor]];
            redLine.center = CGPointMake(control.center.x-5, control.center.y + 19.f);
            [self addSubview:redLine];
        }
        else
        {
            datetime = [NSDate date];
            datetime = [datetime dateByAddingTimeInterval:-(weekindex - (i +1))*3600*24];
            comps = [calendar components:unitFlags fromDate:datetime];
            lbldate.text = [NSString stringWithFormat:@"%d月%d日",[comps month],[comps day]];
//            lbldate.textColor = [UIColor redColor];
            [m_epgdate addObject:[dateFormatter stringFromDate:datetime]];
        }
    }
    [self setContentSize:CGSizeMake(line*width,self.frame.size.height)];
    if ([self.datedelegate respondsToSelector:@selector(dayOfWeekView:didSelIndex:withDateString:)])
        [self.datedelegate dayOfWeekView:self didSelIndex:selectIndex withDateString:[m_epgdate objectAtIndex:selectIndex]];
}

- (void)buttonSelect:(id)sender
{
    UIControl *control = nil;

    control = (UIControl *)sender;
    [self buttonDown:control];
    
    selectIndex = control.tag - 1000;
    
    if ([self.datedelegate respondsToSelector:@selector(dayOfWeekView:didSelIndex:withDateString:)])
        [self.datedelegate dayOfWeekView:self didSelIndex:selectIndex withDateString:[m_epgdate objectAtIndex:selectIndex]];
    
}

- (void)buttonDown:(UIControl *)control
{
//    UIControl *lastControl = (UIControl *)[self viewWithTag:selectIndex+1000];
    [self setControlColor:0 withIndex:selectIndex];
    [self setControlColor:1 withIndex:control.tag-1000];
    [UIView animateWithDuration:0.3 animations:^{
        redLine.center = CGPointMake(control.center.x-5, control.center.y + 19.f);
    }];
}

- (void)setControlColor:(int)status withIndex:(int)index
{
    UIControl *lastControl = (UIControl *)[self viewWithTag:index+1000];
    UILabel *label = (UILabel *)[lastControl viewWithTag:LABEL_WEEK_TAG];
    label.textColor = status == 1? [UIColor redColor]:[UIColor blackColor];
    label = (UILabel *)[lastControl viewWithTag:LABEL_DATE_TAG];
    label.textColor = status == 1? [UIColor redColor]:[UIColor grayColor];;
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
