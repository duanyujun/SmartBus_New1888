//
//  ProgressUtil.h
//  WSChat
//
//  Created by kukuasir on 13-4-1.
//  Copyright (c) 2013年 WSChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface ProgressUtil : NSObject {
@private
    MBProgressHUD *HUD;
}

+ (ProgressUtil *)sharedProgress;

- (void)showInView:(UIView *)view message:(NSString *)message;
- (void)showInView:(UIView *)view;
- (void)setMessage:(NSString *)message;
- (void)hide;

@end
