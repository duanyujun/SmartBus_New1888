//
//  UIColor+FlatColors.h
//  SmartBus
//
//  Created by launching on 13-10-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                  blue:((float)(rgbValue & 0xFF))/255.0 \
                                                 alpha:1.0]

@interface UIColor (FlatColors)

+ (UIColor *)flatRedColor;
+ (UIColor *)flatDarkRedColor;

+ (UIColor *)flatGreenColor;
+ (UIColor *)flatDarkGreenColor;

+ (UIColor *)flatBlueColor;
+ (UIColor *)flatDarkBlueColor;

+ (UIColor *)flatTealColor;
+ (UIColor *)flatDarkTealColor;

+ (UIColor *)flatPurpleColor;
+ (UIColor *)flatDarkPurpleColor;

+ (UIColor *)flatBlackColor;
+ (UIColor *)flatDarkBlackColor;

+ (UIColor *)flatYellowColor;
+ (UIColor *)flatDarkYellowColor;

+ (UIColor *)flatOrangeColor;
+ (UIColor *)flatDarkOrangeColor;

+ (UIColor *)flatWhiteColor;
+ (UIColor *)flatDarkWhiteColor;

+ (UIColor *)flatGrayColor;
+ (UIColor *)flatDarkGrayColor;

+ (UIColor *)randomFlatColor;
+ (UIColor *)randomFlatLightColor;
+ (UIColor *)randomFlatDarkColor;

@end
