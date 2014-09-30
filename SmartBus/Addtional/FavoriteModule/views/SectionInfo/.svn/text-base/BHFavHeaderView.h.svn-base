//
//  BHFavHeaderView.h
//  SmartBus
//
//  Created by launching on 13-10-14.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_UIView.h"
#import "BHPlanResult.h"

typedef enum {
    HeaderStyleStation = 0,
    HeaderStyleRoute
} HeaderStyle;

@protocol BHBHFavHeaderDelegate;

@interface BHFavHeaderView : BeeUIView

@property (nonatomic, assign) NSInteger section;

- (id)initWithFrame:(CGRect)frame delegate:(id<BHBHFavHeaderDelegate>)delegate;

- (void)toggleOpenWithUserAction:(BOOL)userAction;
- (void)setHeaderStyle:(HeaderStyle)style;

@end


@protocol BHBHFavHeaderDelegate <NSObject>
@optional
- (void)sectionHeaderView:(BHFavHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section;
- (void)sectionHeaderView:(BHFavHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section;
@end
