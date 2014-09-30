//
//  BHAppAlert.h
//  SmartBus
//
//  Created by launching on 14-3-13.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHAppAlert : UIView

AS_SIGNAL( CANCEL );
AS_SINGLETON( BHAppAlert );

- (void)showMessage:(NSString *)message inView:(UIView *)view;
- (void)hide;

@end
