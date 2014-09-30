//
//  BHScrollerView.m
//  SmartBus
//
//  Created by launching on 13-6-5.
//  Copyright (c) 2013年 kukuasir. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BHScrollerView.h"

@interface BHScrollerView ()
- (void)scroll;
- (void)getDisplayImagesWithCurpage:(int)page;
- (int)validPageValue:(NSInteger)value;
@end

@implementation BHScrollerView

@synthesize pageControl = _pageControl;
@synthesize currentPage = _curPage;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize autoScrolled = _autoScrolled;

- (void)dealloc
{
    [_backgroundImageView removeFromSuperview];
    [_backgroundImageView release], _backgroundImageView = nil;
    
    [_titleBar removeFromSuperview];
    [_titleBar release], _titleBar = nil;
    
    [_titleLabel removeFromSuperview];
    [_titleLabel release], _titleLabel = nil;
    
    [_scrollView removeFromSuperview];
    [_scrollView release], _scrollView = nil;
    
    [_pageControl removeFromSuperview];
    [_pageControl release], _pageControl = nil;
    
    [_curViews removeAllObjects];
    [_curViews release], _curViews = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        _backgroundImageView.layer.shadowOpacity = 0.7f;
//        _backgroundImageView.layer.shadowRadius = 1.5f;
//        _backgroundImageView.layer.shadowOffset = CGSizeMake(0.0f, 0.3f);
//        _backgroundImageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//        _backgroundImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        [self addSubview:_backgroundImageView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        _titleBar = [[UIView alloc] initWithFrame:CGRectMake(0.f, frame.size.height-30.f, frame.size.width, 30.f)];
        _titleBar.backgroundColor = RGBA(27.f, 27.f, 27.f, 0.7f);
        [self addSubview:_titleBar];
        [self bringSubviewToFront:_titleBar];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, frame.size.height-30.f, 200.f, 30.f)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = FONT_SIZE(14);
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
        _pageControl = [[SMPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.coreSelectedColor = RGB(113.f, 181.f, 244.f);
        _pageControl.coreNormalColor = [UIColor whiteColor];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.gapWidth = 3.f;
        _pageControl.diameter = 8.f;
        [self addSubview:_pageControl];
        
        _curPage = 0;
    }
    return self;
}

- (void)setDataSource:(id<BHScrollerDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData
{
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if ([subViews count] > 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    // 设置背景图片
    if ([_dataSource respondsToSelector:@selector(backgroundImage)]) {
        UIImage *image = [_dataSource backgroundImage];
        [_backgroundImageView setImage:[image stretchableImageWithLeftCapWidth:10.f topCapHeight:10.f]];
    }
    
    _totalPages = [_dataSource numberOfImages];
    _pageControl.numberOfPages = _totalPages;
    
    if (_totalPages == 0)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topimage.png"]];
        imageView.frame = _scrollView.bounds;
        [_scrollView addSubview:imageView];
        [imageView release];
        
        _titleBar.hidden = YES;
        _titleLabel.hidden = YES;
        
        [_scrollView setScrollEnabled:NO];
        return;
    }
    
    _titleBar.hidden = NO;
    _titleLabel.hidden = NO;
    
    if (_totalPages == 1) {
        [_scrollView setScrollEnabled:NO];
    } else {
        [_scrollView setScrollEnabled:YES];
    }
    
    [self loadData];
    
    if ( self.autoScrolled && _totalPages > 1 )
    {
        [self performSelector:@selector(scroll) withObject:nil afterDelay:3];
    }
}

- (void)setSelectedIndex:(NSInteger)idx animated:(BOOL)animated
{
    [_scrollView setContentOffset:CGPointMake(2*_scrollView.width, 0.f) animated:animated];
}

- (void)loadData
{
    _pageControl.currentPage = _curPage;
    
    CGFloat width = 8.f * _totalPages + _pageControl.gapWidth * (_totalPages - 1);
    _titleLabel.frame = CGRectMake(10.f, self.frame.size.height-30.f, self.frame.size.width-15.f-width, 30.f);
    
    if ([_dataSource respondsToSelector:@selector(frameForPageControl)]) {
        _pageControl.frame = [_dataSource frameForPageControl];
    } else {
        _pageControl.frame = CGRectMake(self.frame.size.width-width, self.frame.size.height-25.f, width, 20.f);
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++)
    {
        UIImageView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        [singleTap release];
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
    
    if ([_delegate respondsToSelector:@selector(titleAtIndex:)]) {
        _titleLabel.text = [_delegate titleAtIndex:_curPage];
    }
    
    if (_titleLabel.text.length > 0) {
        _titleBar.backgroundColor = RGBA(27.f, 27.f, 27.f, 0.7f);
    } else {
        _titleBar.backgroundColor = [UIColor clearColor];
    }
}

- (void)scroll
{
    [self setSelectedIndex:self.currentPage animated:YES];
}


#pragma mark - private methods

- (void)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_curViews removeAllObjects];
    
    [_curViews addObject:[_dataSource imageViewAtIndex:pre]];
    [_curViews addObject:[_dataSource imageViewAtIndex:page]];
    [_curViews addObject:[_dataSource imageViewAtIndex:last]];
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(photoView:didSelectAtIndex:)]) {
        [_delegate photoView:self didSelectAtIndex:_curPage];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self reloadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self reloadData];
    }
    
    if ( self.autoScrolled && _totalPages > 1 )
    {
        [self performSelector:@selector(scroll) withObject:nil afterDelay:3];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
}


@end
