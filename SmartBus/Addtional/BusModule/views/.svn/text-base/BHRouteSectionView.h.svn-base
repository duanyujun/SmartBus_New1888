//
//  BHRouteSectionView.h
//  SmartBus
//
//  Created by launching on 13-10-24.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKStation;

@protocol BHRouteSectionDelegate <NSObject>
@optional
- (void)routeSectionView:(UIView *)sectionView didSelectAtIndex:(NSInteger)index;
@end

@interface BHRouteSectionView : BeeUIView

AS_SIGNAL( ITEM_SELECT )

- (id)initWithPosition:(CGPoint)point delegate:(id<BHRouteSectionDelegate>)delegate;
- (id)initWithPosition:(CGPoint)point;

- (void)setStationInfo:(LKStation *)station;

@end
