//
//  UIPickerSheetDelegate.h
//  SmartBus
//
//  Created by launching on 13-11-7.
//  Copyright (c) 2013年 launching. All rights reserved.
//

@protocol UIPickerSheetDelegate <NSObject>
@optional
- (void)pickerSheetWillPresent:(UIView *)sheet;
- (void)pickerSheetWillDismiss:(UIView *)sheet;
- (void)pickerSheet:(UIView *)sheet selectWithButtonIndex:(NSInteger)buttonIndex;
@end
