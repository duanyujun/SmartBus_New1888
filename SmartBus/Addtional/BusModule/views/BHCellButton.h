//
//  BHCellButton.h
//  SmartBus
//
//  Created by launching on 13-10-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_UIButton.h"

@interface BHCellButton : BeeUIButton

@property (nonatomic, assign) NSInteger number;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
