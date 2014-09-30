//
//  SETextHelper.m
//  JstvNews
//
//  Created by launching on 14-2-18.
//  Copyright (c) 2014年 kukuasir. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "SETextHelper.h"
#import "SECompatibility.h"

@implementation SETextHelper

+ (SETextHelper *)sharedInstance
{
    static SETextHelper *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SETextHelper alloc] init];
    });
    
    return sharedInstance;
}

- (NSAttributedString *)attributedStringWithText:(NSString *)text
{
    if ( !text )
    {
        return [[[NSAttributedString alloc] init] autorelease];
    }
    
    UIFont *font = [UIFont systemFontOfSize:15];
    
    id textfont = (__bridge id)CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:(id)kCTFontAttributeName value:textfont range:NSMakeRange(0, text.length)];
    
    return [attributedString autorelease];
}

@end
