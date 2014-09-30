//
//  BHEPGDatePicker.h
//  SmartBus
//
//  Created by 王 正星 on 13-10-24.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BHEPGDatePickerDelegate;
@interface BHEPGDatePicker : UIScrollView
{
    NSMutableArray *m_epgdate;
    UIView *redLine;
}

@property (nonatomic, assign) id <BHEPGDatePickerDelegate> datedelegate;

@property (assign, nonatomic) NSInteger weekindex;
@property (assign, nonatomic) NSInteger selectIndex;

- (id)initWithFrame:(CGRect)frame withDelegate:(id)dele;
@end

@protocol BHEPGDatePickerDelegate <NSObject>

@optional
- (void)dayOfWeekView:(BHEPGDatePicker*)view didSelIndex:(NSInteger)_index withDateString:(NSString *)epgdate;

@end