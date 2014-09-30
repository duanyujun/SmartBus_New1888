//
//  BHMsgLoadMoreHeader.h
//  SmartBus
//
//  Created by launching on 13-12-13.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	MSGLoadStatePulling = 0,
	MSGLoadStateNormal,
	MSGLoadStateLoading,
} MSGLoadState;

@protocol BHMsgLoadMoreHeaderDelegate;

@interface BHMsgLoadMoreHeader : UIView
{
    id _delegate;
	MSGLoadState _state;
    UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
}

@property (nonatomic,assign) id <BHMsgLoadMoreHeaderDelegate> delegate;
@property (nonatomic, assign) BOOL over;

- (id)initWithFrame:(CGRect)frame;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndScrollAnimation:(UIScrollView *)scrollView;

@end


@protocol BHMsgLoadMoreHeaderDelegate
- (void)msgLoadMoreDidTriggerRefresh:(BHMsgLoadMoreHeader *)view;
- (BOOL)msgLoadMoreDataSourceIsLoading:(BHMsgLoadMoreHeader *)view;
@end

