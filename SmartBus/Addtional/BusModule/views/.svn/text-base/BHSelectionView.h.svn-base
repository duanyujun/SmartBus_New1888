//
//  BHSelectionView.h
//  BusHelper
//
//  Created by launching on 13-9-5.
//  Copyright (c) 2013年 仲 阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKRoute;

typedef void (^BHSelectionBlock)(LKRoute *route);

@interface BHSelectionView : UIView

- (id)initWithRoutes:(NSArray *)routes;

- (void)show;
- (void)dismiss;

- (void)didSelectBlock:(BHSelectionBlock)block;

@end
