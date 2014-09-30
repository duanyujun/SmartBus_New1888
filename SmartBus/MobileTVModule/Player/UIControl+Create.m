//
//  UIControl+Create.m
//  Collage
//
//  Created by fengren on 13-1-7.
//
//

#import "UIControl+Create.h"


@implementation UILabel (Create)

+ (UILabel *)newLabel:(NSString *)text withFrame:(CGRect)frame withFont:(UIFont *)font;
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = text;    
    return label;
}

@end

////////////////////////////////////////////////
@implementation UISlider (Create)

+ (UISlider *)newSlider:(int)nTag withFrame:(CGRect)frame minimumValue:(float)minimumValue maximumValue:(float)maximumValue defaultValue:(float)value  withObject:(id)object
{
    UISlider * slider = [[UISlider alloc] initWithFrame:frame];
    slider.tag = nTag;
    slider.minimumValue = minimumValue;
    slider.maximumValue = maximumValue;
    slider.value = value;
    [slider addTarget:object action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:object action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
    return slider;
}
@end

@implementation UIButton (Create)
+ (UIButton *)newButton:(NSInteger)nTag withFrame:(CGRect)frame withImage:(UIImage *)image withObject:(id)object
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = nTag;
    [button setFrame:frame];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:image forState:UIControlStateNormal];
    
    [button addTarget:object action:@selector(touchButton:) forControlEvents: UIControlEventTouchUpInside];
    
    return button;
}
@end