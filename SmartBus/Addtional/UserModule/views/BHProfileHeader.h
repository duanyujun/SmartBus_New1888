//
//  BHProfileHeader.h
//  SmartBus
//
//  Created by launching on 13-11-8.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BHProfileDelegate <NSObject>
- (void)profileHeaderDidSelectAvator:(UIView *)header;
- (void)profileHeaderDidSelectBackDrop:(UIView *)header;
- (void)profileHeaderDidSelectSelfMessage:(UIView *)header;
- (void)profileHeaderDidSendMessage:(UIView *)header;
- (void)profileHeader:(UIView *)header didToggleFoucs:(BOOL)foucs;
- (void)profileHeader:(UIView *)header didSelectAtIndex:(NSInteger)idx;
@end

#define kProfileHeaderHeight  180.f

@interface BHProfileHeader : UIView

- (id)initWithFrame:(CGRect)frame delegate:(id<BHProfileDelegate>)delegate;

// 选择某一选项
- (void)setSelectAtIndex:(NSInteger)idx;

// 更新用户
- (void)reloadUserData:(BHUserModel *)user;
- (void)reloadNumbers:(BHUserModel *)user;

// 设置数值
- (void)setNumber:(NSInteger)number atIndex:(NSInteger)idx;
- (NSInteger)numberAtIndex:(NSInteger)idx;

// 设置目标用户ID
- (void)setTargetUser:(NSInteger)userId;

// 关注/取消关注
- (void)toggleFoucs:(BOOL)foucs;

@end
