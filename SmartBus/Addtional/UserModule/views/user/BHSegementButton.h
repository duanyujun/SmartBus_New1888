//
//  BHSegementButton.h
//  SmartBus
//
//  Created by user on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHSegementButton : UIButton

- (id)initWithPosition:(CGPoint)point;

- (void)setSelected:(BOOL)selected;
- (void)setScore:(NSInteger)score;
- (NSString *)getScore;
- (void)setScoreTitle:(NSString *)title;
- (void)setscoreLabelTitle:(NSString *)title;
@end
