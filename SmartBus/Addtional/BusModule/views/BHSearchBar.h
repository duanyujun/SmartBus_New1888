//
//  BHSearchBar.h
//  SmartBus
//
//  Created by launching on 13-10-8.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_UIView.h"

#define kSearchBarHeight  40.f

@interface BHSearchBar : BeeUIView

@property (nonatomic, retain) NSString *placeholder;

- (void)setActive:(BOOL)flag;
- (NSString *)content;
- (void)clear;

@end
