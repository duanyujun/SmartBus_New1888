//
//  BHTextBubble.h
//  SmartBus
//
//  Created by kukuasir on 13-11-8.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BubbleModeTextField,
    BubbleModeButton
} BubbleMode;

@interface BHTextBubble : UIView<UITextFieldDelegate>

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIButton *textButton;

- (id)initWithPosition:(CGPoint)point title:(NSString *)title;
- (void)setMode:(BubbleMode)mode placeholder:(NSString *)placeholer;
- (void)addTarget:(id)target action:(SEL)selector;

@end
