//
//  BHInputBar.h
//  SmartBus
//
//  Created by launching on 13-11-12.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHInputBar;

@protocol BHInputBarDelegate <NSObject>
- (void)inputBar:(BHInputBar *)inputBar sendMessage:(NSString *)message;
@optional
- (void)inputBar:(BHInputBar *)inputBar keyBoardWillShow:(NSNotification *)notitication;
- (void)inputBar:(BHInputBar *)inputBar keyBoardWillHide:(NSNotification *)notitication;
@end

#define kInputBarHeight 56.f

@interface BHInputBar : UIView

@property(nonatomic, assign) id<BHInputBarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;

// 隐藏键盘
- (BOOL)resignFirstResponder;

@end
