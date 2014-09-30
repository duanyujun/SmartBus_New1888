//
//  UIControl+Create.h
//  Collage
//
//  Created by fengren on 13-1-7.
//
//

#import <Foundation/Foundation.h>


@interface UILabel (Create)

+ (UILabel *)newLabel:(NSString *)text withFrame:(CGRect)frame withFont:(UIFont *)font;
@end



@interface UISlider (Create)

+ (UISlider *)newSlider:(int)nTag withFrame:(CGRect)frame minimumValue:(float)minimumValue maximumValue:(float)maximumValue defaultValue:(float)value withObject:(id)object;

@end

@interface UIButton (Create)

+ (UIButton *)newButton:(NSInteger)nTag withFrame:(CGRect)frame withImage:(UIImage *)image withObject:(id)object;

@end


