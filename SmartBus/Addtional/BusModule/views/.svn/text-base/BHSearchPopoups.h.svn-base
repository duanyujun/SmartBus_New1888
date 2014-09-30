//
//  BHSearchPopoups.h
//  SmartBus
//
//  Created by launching on 13-11-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CacheDBHelper.h"

@protocol BHSearchPopoupsDelegate <NSObject>
@optional
- (void)searchPopoups:(UIView *)view didSelectWithData:(id)data;
@end

@interface BHSearchPopoups : UIView

@property (nonatomic, assign) HISTORY_MODE his_mode;

- (id)initWithPlaceholder:(NSString *)placeholder delegate:(id<BHSearchPopoupsDelegate>)delegate;
- (id)initWithPlaceholder:(NSString *)placeholder;

- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)dismissWithAnimated:(BOOL)animated;

@end
