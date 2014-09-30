//
//  BHScrollerView.h
//  SmartBus
//
//  Created by launching on 13-6-5.
//  Copyright (c) 2013年 kukuasir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"

@protocol BHScrollerDataSource;
@protocol BHScrollerDelegate;

@interface BHScrollerView : UIView<UIScrollViewDelegate>
{
@private
    UIImageView *_backgroundImageView;
    UIScrollView *_scrollView;
    SMPageControl *_pageControl;
    UIView *_titleBar;
    UILabel *_titleLabel;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    BOOL _autoScrolled;
    
    NSMutableArray *_curViews;
}

@property (nonatomic, assign) SMPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) id<BHScrollerDataSource> dataSource;
@property (nonatomic, assign) id<BHScrollerDelegate> delegate;
@property (nonatomic, assign) BOOL autoScrolled;

- (void)reloadData;
- (void)setSelectedIndex:(NSInteger)idx animated:(BOOL)animated;

@end


@protocol BHScrollerDelegate <NSObject>
@optional
- (NSString *)titleAtIndex:(NSInteger)index;
- (void)photoView:(BHScrollerView *)photoView didSelectAtIndex:(NSInteger)index;
@end

@protocol BHScrollerDataSource <NSObject>
@required
- (NSInteger)numberOfImages;
- (UIView *)imageViewAtIndex:(NSInteger)index;
@optional
- (UIImage *)backgroundImage;
- (CGRect)frameForPageControl;
@end
