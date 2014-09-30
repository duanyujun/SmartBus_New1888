//
//  ProgressUtil.m
//  WSChat
//
//  Created by kukuasir on 13-4-1.
//  Copyright (c) 2013年 WSChat. All rights reserved.
//

#import "ProgressUtil.h"
//#import "Utilities.h"

static ProgressUtil *sharedProgress = nil;

@implementation ProgressUtil

+ (ProgressUtil *)sharedProgress {
    if (sharedProgress == nil) {
        sharedProgress = [[ProgressUtil alloc] init];
    }
    return sharedProgress;
}


- (void)showInView:(UIView *)view message:(NSString *)message {
    HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = message;
    [HUD show:YES];
    [view addSubview:HUD];
}

- (void)showInView:(UIView *)view {
    [self showInView:view message:@"正在加载,请稍候..."];
}

- (void)setMessage:(NSString *)message{
    if (HUD != nil) {
//        CATransition *animation = [CATransition animation];
//        animation.duration = 0.1f ;
//        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        HUD.labelText = message;
//        [HUD.layer addAnimation:animation forKey:@"animation"];
        
    }
}
- (void)hide {
    if (!HUD) return;
    [HUD hide:YES];
}

@end
