//
//  LCSegmentedControl.m
//  LitchiCommunity
//
//  Created by launching on 14-2-13.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "LCSegmentedControl.h"

@implementation LCSegmentedControl

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    if ( self = [super initWithFrame:frame items:items iconPosition:IconPositionRight] )
    {
        self.color = [UIColor whiteColor];
        self.borderWidth = 1.0;
        self.borderColor = RGB(0, 121, 254);
        self.selectedColor = RGB(0, 121, 254);
        self.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:RGB(0, 121, 254)};
        self.selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]};
    }
    return self;
}

@end
