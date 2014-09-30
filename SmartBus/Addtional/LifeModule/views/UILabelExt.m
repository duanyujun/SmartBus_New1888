//
//  UILabelExt.m
//  JstvNews
//
//  Created by launching on 13-5-28.
//  Copyright (c) 2013年 kukuasir. All rights reserved.
//

#import "UILabelExt.h"

@implementation UILabelExt

@synthesize contentVerticalAlignment = _contentVerticalAlignment;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}

- (void)setContentVerticalAlignment:(UIControlContentVerticalAlignment)contentVerticalAlignment {
    _contentVerticalAlignment = contentVerticalAlignment;
    [self setNeedsDisplay];
}


- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (_contentVerticalAlignment)
    {
        case UIControlContentVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case UIControlContentVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case UIControlContentVerticalAlignmentCenter:
            // default.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

- (void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
