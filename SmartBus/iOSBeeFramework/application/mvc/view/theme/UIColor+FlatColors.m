//
//  UIColor+FlatColors.m
//  SmartBus
//
//  Created by launching on 13-10-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "UIColor+FlatColors.h"

@implementation UIColor (FlatColors)

#pragma mark - Red
+ (UIColor *)flatRedColor
{
    return UIColorFromRGB(0xDB6A65);
}
+ (UIColor *)flatDarkRedColor
{
    return UIColorFromRGB(0xE42835);
}


#pragma mark - Green
+ (UIColor *)flatGreenColor
{
    return UIColorFromRGB(0x70BD79);
}
+ (UIColor *)flatDarkGreenColor
{
    return UIColorFromRGB(0x27AE60);
}


#pragma mark - Blue
+ (UIColor *)flatBlueColor
{
    return UIColorFromRGB(0x64A2DB);
}
+ (UIColor *)flatDarkBlueColor
{
    return UIColorFromRGB(0x2980B9);
}


#pragma mark - Teal
+ (UIColor *)flatTealColor
{
    return UIColorFromRGB(0x1ABC9C);
}
+ (UIColor *)flatDarkTealColor
{
    return UIColorFromRGB(0x16A085);
}

#pragma mark - Purple
+ (UIColor *)flatPurpleColor
{
    return UIColorFromRGB(0x9B59B6);
}
+ (UIColor *)flatDarkPurpleColor
{
    return UIColorFromRGB(0x8E44AD);
}


#pragma mark - Yellow
+ (UIColor *)flatYellowColor
{
    return UIColorFromRGB(0xF1C40F);
}
+ (UIColor *)flatDarkYellowColor
{
    return UIColorFromRGB(0xF39C12);
}


#pragma mark - Orange
+ (UIColor *)flatOrangeColor
{
    return UIColorFromRGB(0xEA7446);
}
+ (UIColor *)flatDarkOrangeColor
{
    return UIColorFromRGB(0xD35400);
}


#pragma mark - Gray
+ (UIColor *)flatGrayColor
{
    return UIColorFromRGB(0xE0E0E0);
}

+ (UIColor *)flatDarkGrayColor
{
    return UIColorFromRGB(0xC2C2C2);
}


#pragma mark - White
+ (UIColor *)flatWhiteColor
{
    return UIColorFromRGB(0xE8E9E2);
}

+ (UIColor *)flatDarkWhiteColor
{
    return UIColorFromRGB(0xBDC3C7);
}


#pragma mark - Black
+ (UIColor *)flatBlackColor
{
    return UIColorFromRGB(0x0F0F0F);
}

+ (UIColor *)flatDarkBlackColor
{
    return UIColorFromRGB(0x2C3E50);
}


#pragma mark - Random
+ (UIColor *)randomFlatColor
{
    return [UIColor randomFlatColorIncludeLightShades:YES darkShades:YES];
}

+ (UIColor *)randomFlatLightColor
{
    return [UIColor randomFlatColorIncludeLightShades:YES darkShades:NO];
}

+ (UIColor *)randomFlatDarkColor
{
    return [UIColor randomFlatColorIncludeLightShades:NO darkShades:YES];
}

+ (UIColor *)randomFlatColorIncludeLightShades:(BOOL)useLightShades
                                    darkShades:(BOOL)useDarkShades;
{
    const NSInteger numberOfLightColors = 10;
    const NSInteger numberOfDarkColors = 10;
    NSAssert(useLightShades || useDarkShades, @"Must choose random color using at least light shades or dark shades.");
    
    
    u_int32_t numberOfColors = 0;
    if(useLightShades){
        numberOfColors += numberOfLightColors;
    }
    if(useDarkShades){
        numberOfColors += numberOfDarkColors;
    }
    
    u_int32_t chosenColor = arc4random_uniform(numberOfColors);
    
    if(!useLightShades){
        chosenColor += numberOfLightColors;
    }
    
    UIColor *color = nil;
    switch (chosenColor) {
        case 0:
            color = [UIColor flatRedColor];
            break;
        case 1:
            color = [UIColor flatGreenColor];
            break;
        case 2:
            color = [UIColor flatBlueColor];
            break;
        case 3:
            color = [UIColor flatTealColor];
            break;
        case 4:
            color = [UIColor flatPurpleColor];
            break;
        case 5:
            color = [UIColor flatYellowColor];
            break;
        case 6:
            color = [UIColor flatOrangeColor];
            break;
        case 7:
            color = [UIColor flatGrayColor];
            break;
        case 8:
            color = [UIColor flatWhiteColor];
            break;
        case 9:
            color = [UIColor flatBlackColor];
            break;
        case 10:
            color = [UIColor flatDarkRedColor];
            break;
        case 11:
            color = [UIColor flatDarkGreenColor];
            break;
        case 12:
            color = [UIColor flatDarkBlueColor];
            break;
        case 13:
            color = [UIColor flatDarkTealColor];
            break;
        case 14:
            color = [UIColor flatDarkPurpleColor];
            break;
        case 15:
            color = [UIColor flatDarkYellowColor];
            break;
        case 16:
            color = [UIColor flatDarkOrangeColor];
            break;
        case 17:
            color = [UIColor flatDarkGrayColor];
            break;
        case 18:
            color = [UIColor flatDarkWhiteColor];
            break;
        case 19:
            color = [UIColor flatDarkBlackColor];
            break;
        default:
            NSAssert(0, @"Unrecognized color selected as random color");
            break;
    }
    
    return color;
}

@end
