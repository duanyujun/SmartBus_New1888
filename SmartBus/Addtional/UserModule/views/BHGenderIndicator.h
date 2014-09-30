//
//  BHGenderIndicator.h
//  SmartBus
//
//  Created by launching on 14-3-6.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kIndecatorHeight  15

@interface BHGenderIndicator : UIView

- (id)initWithPosition:(CGPoint)point;
- (void)indicatorUser:(BHUserModel *)user;

@end
