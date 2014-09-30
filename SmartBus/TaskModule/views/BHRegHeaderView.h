//
//  BHRegHeaderView.h
//  SmartBus
//
//  Created by 王 正星 on 13-12-16.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHRegHeaderView : UIView

- (void)setRegist:(BOOL)hasRegist;
- (void)setConNum:(int)num;
- (void)showTips:(int)num;
@end
