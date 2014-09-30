//
//  BHGroupHeader.h
//  SmartBus
//
//  Created by launching on 13-12-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHGroupModel;
@protocol BHGroupHeaderDelegate;

#define kGroupHeader 180.f

@interface BHGroupHeader : UIView

@property (nonatomic, assign) NSInteger selectedIndex;

- (id)initWithFrame:(CGRect)frame delegate:(id<BHGroupHeaderDelegate>)delegate;

// 更新圈子信息
- (void)reloadGroupData:(BHGroupModel *)group;

// 关注/取消关注
- (void)toggleFoucs:(BOOL)foucs;

@end


@protocol BHGroupHeaderDelegate <NSObject>
@optional
- (void)groupHeaderDidCreatePosts:(BHGroupHeader *)header;
- (void)groupHeader:(BHGroupHeader *)header toggleFoucs:(BOOL)foucs;
- (void)groupHeader:(BHGroupHeader *)header didSelectAtIndex:(NSInteger)idx;
@end
