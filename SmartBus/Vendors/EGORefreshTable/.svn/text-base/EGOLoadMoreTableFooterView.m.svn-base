//
//  EGOLoadMoreTableFooterView.h
//
//  Created by Ye Dingding on 10-12-24.
//  Copyright 2010 Intridea, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


#import "EGOLoadMoreTableFooterView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#define LOAD_MORE_VIEW_HEIGHT 40.0f
#define CHANGE_STATE_RATE 1.2   //set load more view height * 1.2

@interface EGOLoadMoreTableFooterView (Private)
- (void)setState:(EGOPullLoadState)aState;
- (BOOL)loadMoreTableFooterViewenabled;
@end

@implementation EGOLoadMoreTableFooterView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 15.f, 320.f, 20.f)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:14.f];
        label.textColor = [UIColor blackColor];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.textAlignment = UITextAlignmentCenter;
        [self addSubview:label];
        _statusLabel = label;
        [label release];
        
		_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake(150.f, 15.f, 20.f, 20.f);
		[self addSubview:_activityView];
		self.hidden = YES;
		
		[self setState:EGOOPullLoadNormal];
		
    }
    return self;
}


#pragma mark -
#pragma mark Setters

- (void)setState:(EGOPullLoadState)aState {
	
	switch (aState) {
		case EGOOPullLoadPulling:
            _statusLabel.text = NSLocalizedString(@"上拉加载更多...", @"Pull up to load more ...");
            [_activityView stopAnimating];
			break;
		case EGOOPullLoadNormal:
            _statusLabel.text = NSLocalizedString(@"上拉加载更多...", @"Pull up to load more ...");
			[_activityView stopAnimating];
			break;
		case EGOOPullLoadLoading:
            _statusLabel.text = nil;
			[_activityView startAnimating];
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)setLoadOver:(BOOL)loadOver {
    _loadOver = loadOver;
    self.hidden = _loadOver;
}

- (BOOL)loadMoreTableFooterViewenabled
{
    // 设置是否显示(默认不显示)
    BOOL enabled = false;
    if ([_delegate respondsToSelector:@selector(enableEGOLoadMoreTableFooterView)]) {
        enabled = [_delegate enableEGOLoadMoreTableFooterView];
    }
    return enabled;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoLoadMoreScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![self loadMoreTableFooterViewenabled]) return;
    
    // 如果加载完成则不显示
    if (_loadOver) return;
    
	if (_state == EGOOPullLoadLoading) {
		CGFloat offset = MAX(0, -1 * (scrollView.contentSize.height- scrollView.frame.size.height - scrollView.contentOffset.y));
		offset = MIN(offset, LOAD_MORE_VIEW_HEIGHT);
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
	} else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoLoadMoreTableFooterDataSourceIsLoading:)]) {
			_loading = [_delegate egoLoadMoreTableFooterDataSourceIsLoading:self];
		}
		if (_state == EGOOPullLoadNormal && scrollView.contentOffset.y + scrollView.frame.size.height > (scrollView.contentSize.height) && !_loading) {
			self.frame = CGRectMake(0, scrollView.contentSize.height, self.frame.size.width, self.frame.size.height);
			self.hidden = NO;
		}
        
		if (_state == EGOOPullLoadPulling && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height && scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.frame.size.height + CHANGE_STATE_RATE * LOAD_MORE_VIEW_HEIGHT && !_loading) {
			[self setState:EGOOPullLoadNormal];
		} else if (_state == EGOOPullLoadNormal && scrollView.contentOffset.y >  scrollView.contentSize.height - scrollView.frame.size.height + CHANGE_STATE_RATE * LOAD_MORE_VIEW_HEIGHT  && !_loading) {
			[self setState:EGOOPullLoadPulling];
		}
        
		if (scrollView.contentInset.bottom != 0.f) {
            scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoLoadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if (![self loadMoreTableFooterViewenabled]) return;
    
    // 如果加载完成则不显示
    if (_loadOver) return;
    
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoLoadMoreTableFooterDataSourceIsLoading:)]) {
		_loading = [_delegate egoLoadMoreTableFooterDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height + CHANGE_STATE_RATE * LOAD_MORE_VIEW_HEIGHT) && scrollView.contentSize.height > scrollView.frame.size.height && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoLoadMoreTableFooterDidTriggerLoad:)]) {
			[_delegate egoLoadMoreTableFooterDidTriggerLoad:self];
		}
		
		[self setState:EGOOPullLoadLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, LOAD_MORE_VIEW_HEIGHT, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoLoadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullLoadNormal];
    
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate = nil;
	_activityView = nil;
    _statusLabel = nil;
    [super dealloc];
}


@end
