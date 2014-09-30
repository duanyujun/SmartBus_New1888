//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "TSLocateView.h"

#define kDuration 0.3

@interface TSLocateView ()
{
    UIPickerView *_pickerView;
    id<UIPickerSheetDelegate> _delegate;
}
@end

@implementation TSLocateView

@synthesize locate = _locate;

#define kContentViewTag 1990

- (void)removeFromSuperview
{
    [_pickerView removeFromSuperview];
    [super removeFromSuperview];
}

- (void)dealloc
{
    SAFE_RELEASE(_pickerView);
    SAFE_RELEASE(_locate);
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title delegate:(id<UIPickerSheetDelegate>)delegate
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        _delegate = delegate;
        
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
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.f, 44.f, 320.f, 216.f)];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [contentView addSubview:_pickerView];
        
        [self addSubview:contentView];
        [contentView release];
        
        //加载数据
        NSString *resource = @"ProvincesAndCities.plist";
        provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resource ofType:nil]];
        
        cities = [[provinces objectAtIndex:0] objectForKey:@"Cities"];
        
        //初始化默认数据
        self.locate = [[TSLocation alloc] init];
        self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"State"];
        self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
        self.locate.latitude = [[[cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
        self.locate.longitude = [[[cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
    }
    return self;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if ([_delegate respondsToSelector:@selector(pickerSheetWillDismiss:)]) {
        [_delegate pickerSheetWillDismiss:self];
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
        [contentView.layer addAnimation:animation forKey:@"LocatePickerSheet"];
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
    } else {
        [contentView setAlpha:0.f];
        [self removeFromSuperview];
    }
    
    if ([_delegate respondsToSelector:@selector(pickerSheet:selectWithButtonIndex:)]) {
        [_delegate pickerSheet:self selectWithButtonIndex:buttonIndex];
    }
}

- (void)showInView:(UIView *) view
{
    if ([_delegate respondsToSelector:@selector(pickerSheetWillPresent:)]) {
        [_delegate pickerSheetWillPresent:self];
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
    [contentView.layer addAnimation:animation forKey:@"LocatePickerSheet"];
    
    contentView.frame = CGRectMake(0.f, self.frame.size.height-260.f, 320.f, 260.f);
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[provinces objectAtIndex:row] objectForKey:@"State"];
            break;
        case 1:
            return [[cities objectAtIndex:row] objectForKey:@"city"];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            cities = [[provinces objectAtIndex:row] objectForKey:@"Cities"];
            [_pickerView selectRow:0 inComponent:1 animated:NO];
            [_pickerView reloadComponent:1];
            
            self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"State"];
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            self.locate.latitude = [[[cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
            self.locate.longitude = [[[cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
            break;
        case 1:
            self.locate.city = [[cities objectAtIndex:row] objectForKey:@"city"];
            self.locate.latitude = [[[cities objectAtIndex:row] objectForKey:@"lat"] doubleValue];
            self.locate.longitude = [[[cities objectAtIndex:row] objectForKey:@"lon"] doubleValue];
            break;
        default:
            break;
    }
}


#pragma mark - Button lifecycle

- (void)choose:(id)sender
{
    [self dismissWithClickedButtonIndex:1 animated:YES];
}

- (void)cancel:(id)sender
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)locate:(id)sender
{
    [self dismissWithClickedButtonIndex:1 animated:YES];
}

@end
