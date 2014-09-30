//
//  EGOTableView.h
//  JstvNews
//
//  Created by kukuasir on 13-7-7.
//  Copyright (c) 2013年 kukuasir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGOLoadMoreTableFooterView.h"

@interface EGOTableView : UIView
<
EGORefreshTableHeaderDelegate,
EGOLoadMoreTableFooterDelegate,
UITableViewDataSource,
UITableViewDelegate
>
{
@private
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGOLoadMoreTableFooterView *_loadMoreFooterView;
    BOOL _refreshing;
    BOOL _loading;
}

/* tableview */
@property (nonatomic, retain) UITableView *egoTableView;

/* 是否开启EGORefreshTableHeaderView控件 */
@property (nonatomic, assign) BOOL enableRefreshHeader;

/* 是否开启EGOLoadMoreTableFooterView控件 */
@property (nonatomic, assign) BOOL enableLoadMoreFooter;

/* 是否加载完毕 */
@property (nonatomic, assign) BOOL isLoadingOver;

- (void)refreshTableViewDataSource;
- (void)loadTableViewDataSource;

- (void)egoAllRequest;
- (void)reloadDataSucceed:(BOOL)succeed;

@end
