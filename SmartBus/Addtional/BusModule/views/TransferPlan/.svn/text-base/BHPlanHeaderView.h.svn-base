//
//  BHPlanHeaderView.h
//  SmartBus
//
//  Created by launching on 13-10-14.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_UIView.h"
#import "BHPlanResult.h"

#define kInitHeight  106.f

@protocol BHPlanHeaderDelegate;

@interface BHPlanHeaderView : BeeUIView

@property (nonatomic, assign) NSInteger section;

- (id)initWithFrame:(CGRect)frame delegate:(id<BHPlanHeaderDelegate>)delegate;

- (void)toggleOpenWithUserAction:(BOOL)userAction;
- (void)setTitle:(NSString *)title;
- (void)setPlanResult:(BHPlanResult *)result;

@end


@protocol BHPlanHeaderDelegate <NSObject>
@optional
- (void)sectionHeaderView:(BHPlanHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section;
- (void)sectionHeaderView:(BHPlanHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section;
@end
