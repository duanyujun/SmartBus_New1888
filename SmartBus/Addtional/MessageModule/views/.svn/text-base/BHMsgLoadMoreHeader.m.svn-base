//
//  BHMsgLoadMoreHeader.m
//  SmartBus
//
//  Created by launching on 13-12-13.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHMsgLoadMoreHeader.h"

@interface BHMsgLoadMoreHeader (Private)
- (void)setState:(MSGLoadState)aState;
@end

@implementation BHMsgLoadMoreHeader

@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.f, frame.size.height - 38.0f, 280.f, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor lightGrayColor];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel = label;
		[label release];
        
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(150.f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		[self setState:MSGLoadStateNormal];
		
    }
	
    return self;
	
}

#pragma mark -
#pragma mark Setters

- (void)setState:(MSGLoadState)aState
{
	switch (aState)
    {
		case MSGLoadStatePulling:
            _statusLabel.alpha = 1;
            _statusLabel.text = self.over ? @"没有历史记录了" : @"以上是历史记录";
			break;
		case MSGLoadStateNormal:
            _statusLabel.alpha = 1;
            _statusLabel.text = self.over ? @"没有历史记录了" : @"以上是历史记录";
            [_activityView stopAnimating];
			break;
		case MSGLoadStateLoading:
            _statusLabel.alpha = 0;
			[_activityView startAnimating];
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)refreshLastUpdatedDate
{
    
}

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( self.over ) {
        return;
    }
    
	if (_state == MSGLoadStateLoading)
    {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
	}
    else if (scrollView.isDragging)
    {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(msgLoadMoreDataSourceIsLoading:)])
        {
			_loading = [_delegate msgLoadMoreDataSourceIsLoading:self];
		}
		
		if (_state == MSGLoadStatePulling && scrollView.contentOffset.y > -50.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:MSGLoadStateNormal];
		} else if (_state == MSGLoadStateNormal && scrollView.contentOffset.y < -50.0f && !_loading) {
			[self setState:MSGLoadStatePulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if ( self.over ) {
        return;
    }
    
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(msgLoadMoreDataSourceIsLoading:)]) {
		_loading = [_delegate msgLoadMoreDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 50.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(msgLoadMoreDidTriggerRefresh:)]) {
			[_delegate msgLoadMoreDidTriggerRefresh:self];
		}
		
		[self setState:MSGLoadStateLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:MSGLoadStateNormal];
    
}

- (void)egoRefreshScrollViewDidEndScrollAnimation:(UIScrollView *)scrollView {
    [self egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate = nil;
	_activityView = nil;
    [super dealloc];
}

@end
