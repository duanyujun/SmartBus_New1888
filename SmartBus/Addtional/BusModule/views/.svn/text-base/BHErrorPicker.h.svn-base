//
//  BHErrorPicker.h
//  SmartBus
//
//  Created by launching on 14-8-1.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHIDErrorBoard.h"

typedef void (^BHErrorPickHandler)(int);

@interface BHErrorPicker : UIView

- (id)initWithErrors:(NSArray *)errors;

- (void)show;
- (void)dismiss;

- (void)didSelectBlock:(BHErrorPickHandler)block;

@end
