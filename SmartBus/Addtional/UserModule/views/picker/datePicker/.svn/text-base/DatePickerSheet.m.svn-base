//
//  DatePickerSheet.m
//  WSChat
//
//  Created by launching on 13-4-18.
//  Copyright (c) 2013年 WSChat. All rights reserved.
//

#import "DatePickerSheet.h"
#import "NSDate+Helper.h"

#define kMaxUserAge     12  // 设置最大使用人群的年龄
#define kContentViewTag 1990
#define kDatePickerTag  1991

@implementation DatePickerSheet

- (id)initWithTitle:(NSString *)title delegate:(id<UIPickerSheetDelegate>)delegate
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        delegate_ = delegate;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 220.f, 320.f, 260.f)];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.tag = kContentViewTag;
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
        titleImageView.backgroundColor = [UIColor flatRedColor];
        [contentView addSubview:titleImageView];
        [titleImageView release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 11.f, 320.f, 21.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = title;
        [contentView addSubview:titleLabel];
        [titleLabel release];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(10.f, 1.f, 42.f, 42.f);
        [cancelButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [cancelButton setImage:[UIImage imageNamed:@"cancel_press.png"] forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:cancelButton];
        
        UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake(268.f, 1.f, 42.f, 42.f);
        [chooseButton setImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateNormal];
        [chooseButton setImage:[UIImage imageNamed:@"choose_press.png"] forState:UIControlStateHighlighted];
        [chooseButton addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:chooseButton];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.f, 44.f, 320.f, 216.f)];
        datePicker.tag = kDatePickerTag;
        
        // 设置时间格式
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        // 设置默认日期
        datePicker.date = [NSDate dateFromString:@"1900-01-01" withFormat:@"yyyy-MM-dd"];
        
        // 设置最大和最小日期
        NSString *maximumDateString = [NSString stringWithFormat:@"%d-12-31", [NSDate year] - kMaxUserAge];
        datePicker.maximumDate = [NSDate dateFromString:maximumDateString withFormat:@"yyyy-MM-dd"];
        datePicker.minimumDate = [NSDate dateFromString:@"1900-01-01" withFormat:@"yyyy-MM-dd"];
        
        [contentView addSubview:datePicker];
        [datePicker release];
        
        [self addSubview:contentView];
        [contentView release];
    }
    return self;
}


- (void)setDateString:(NSString *)dateString animated:(BOOL)animated
{
    if (dateString == nil || dateString.length == 0) {
        return;
    }
    
    if ([[dateString componentsSeparatedByString:@"-"] count] < 3) {
        return;
    }
    
    UIDatePicker *datePicker = (UIDatePicker *)[self viewWithTag:kDatePickerTag];
    [datePicker setDate:[NSDate dateFromString:dateString withFormat:@"yyyy-MM-dd"] animated:YES];
}


- (void)showInView:(UIView *)view
{
    if ([delegate_ respondsToSelector:@selector(pickerSheetWillPresent:)]) {
        [delegate_ pickerSheetWillPresent:self];
    }
    
    [view addSubview:self];
    [self setFrame:view.frame];
    
    UIView *contentView = [self viewWithTag:kContentViewTag];
    contentView.frame = CGRectMake(0.f, self.frame.size.height, 320.f, 260.f);
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [contentView.layer addAnimation:animation forKey:@"DatePickerSheet"];
    
    contentView.frame = CGRectMake(0.f, self.frame.size.height-260.f, 320.f, 260.f);
}

- (NSString *)dateString
{
    UIDatePicker *datePicker = (UIDatePicker *)[self viewWithTag:kDatePickerTag];
    NSDate *date = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return dateString;
}


#pragma mark - private methods

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if ([delegate_ respondsToSelector:@selector(pickerSheetWillDismiss:)]) {
        [delegate_ pickerSheetWillDismiss:self];
    }
    
    UIView *contentView = [self viewWithTag:kContentViewTag];
    
    if (animated) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
        [contentView setAlpha:0.f];
        [contentView.layer addAnimation:animation forKey:@"DatePickerSheet"];
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
    } else {
        [contentView setAlpha:0.f];
        [self removeFromSuperview];
    }
    
    if ([delegate_ respondsToSelector:@selector(pickerSheet:selectWithButtonIndex:)]) {
        [delegate_ pickerSheet:self selectWithButtonIndex:buttonIndex];
    }
}


#pragma mark - Button lifecycle

- (void)cancel:(id)sender {
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)choose:(id)sender {
    [self dismissWithClickedButtonIndex:1 animated:YES];
}

@end
