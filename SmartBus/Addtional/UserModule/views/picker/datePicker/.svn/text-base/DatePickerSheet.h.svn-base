//
//  DatePickerSheet.h
//  WSChat
//
//  Created by launching on 13-4-18.
//  Copyright (c) 2013年 WSChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPickerSheetDelegate.h"

@interface DatePickerSheet : UIView
{
    id<UIPickerSheetDelegate> delegate_;
}

- (id)initWithTitle:(NSString *)title delegate:(id<UIPickerSheetDelegate>)delegate;

- (void)setDateString:(NSString *)dateString animated:(BOOL)animated;
- (NSString *)dateString;

- (void)showInView:(UIView *)view;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end
