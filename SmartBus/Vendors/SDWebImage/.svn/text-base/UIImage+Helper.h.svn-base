//
//  UIImage+Helper.h
//  JstvNews
//
//  Created by launching on 13-6-12.
//  Copyright (c) 2013年 kukuasir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Helper)

/*
 * Creates an image from the contents of a URL
 */
+ (UIImage*)imageWithContentsOfURL:(NSURL*)url;

/*
 * Creates an image with a path compontent relative to
 * the main bundle's resource path
 */
+ (UIImage*)imageWithResourcesPathCompontent:(NSString*)pathCompontent;

/*
 * Scales the image to the given size, NOT aspect
 */
- (UIImage*)scaleToSize:(CGSize)size;

/*
 * Fits the image to the given size, NOT aspect
 */
- (UIImage*)fitToSize:(CGSize)size;

/*
 * Aspect scale with border color, and corner radius, and shadow
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withBorderSize:(CGFloat)borderSize borderColor:(UIColor*)aColor cornerRadius:(CGFloat)aRadius shadowOffset:(CGSize)aOffset shadowBlurRadius:(CGFloat)aBlurRadius shadowColor:(UIColor*)aShadowColor;

/*
 * Aspect scale with a shadow
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withShadowOffset:(CGSize)aOffset blurRadius:(CGFloat)aRadius color:(UIColor*)aColor;

/*
 * Aspect scale with corner radius
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withCornerRadius:(CGFloat)aRadius;

/*
 * Aspect scales the image to a max size
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size;

/*
 * Aspect scales the image to a rect size
 */
- (UIImage*)aspectScaleToSize:(CGSize)size;

/*
 * Masks the context with the image, then fills with the color
 */
- (void)drawInRect:(CGRect)rect withAlphaMaskColor:(UIColor*)aColor;

/*
 * Masks the context with the image, then fills with the gradient (two colors in an array)
 */
- (void)drawInRect:(CGRect)rect withAlphaMaskGradient:(NSArray*)colors;

/*
 * Aspect scales the image to a max size
 */
- (CGSize)aspectScaleSize:(CGFloat)size;

@end
