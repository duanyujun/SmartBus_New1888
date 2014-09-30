//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "UIPickerSheetDelegate.h"
#import "TSLocation.h"

@interface TSLocateView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
{
@private
    NSArray *provinces;
    NSArray	*cities;
}

@property (retain, nonatomic) TSLocation *locate;

- (id)initWithTitle:(NSString *)title delegate:(id<UIPickerSheetDelegate>)delegate;

- (void)showInView:(UIView *)view;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

- (void)cancel:(id)sender;
- (void)locate:(id)sender;

@end
