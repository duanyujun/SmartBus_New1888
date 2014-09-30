//
//  BHButton.h
//  SmartBus
//
//  Created by kukuasir on 13-11-10.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHButton : UIControl

- (void)setBackgroundImage:(UIImage *)backgroundImage;
- (void)setImage:(UIImage *)image number:(NSInteger)number;
- (void)setTextColor:(UIColor *)color;
- (NSInteger)number;

@end
