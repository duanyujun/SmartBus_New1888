//
//  SBCalloutView.h
//  SmartBus
//
//  Created by launching on 14-4-24.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBCalloutView : UIView
{
@private
    NSString *__title;
    NSString *__subtitle;
}

- (void)fillCalloutTitle:(NSString *)title andSubtitle:(NSString *)subtitle;
- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
