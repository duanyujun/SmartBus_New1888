//
//  BHAppSectionView.h
//  SmartBus
//
//  Created by launching on 13-10-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_UIView.h"

#define kSectionHeaderHeight  30.f

typedef enum {
    AppStyleNews,    // 新闻风格
    AppStyleTrends   // 动态风格
} AppStyle;

@protocol BHAppSectionDelegate <NSObject>
@optional
- (void)appSectionViewDidTapped:(UIView *)view;
- (void)appSectionViewDidSelectMore:(UIView *)view;
@end

@interface BHAppSectionView : BeeUIView

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIColor *tintColor;
@property (nonatomic, assign) BOOL hideMore;

- (id)initWithPosition:(CGPoint)point;
- (id)initWithPosition:(CGPoint)point delegate:(id<BHAppSectionDelegate>)delegate;
- (void)setStyle:(AppStyle)style dataSource:(id)dataSource;

@end
