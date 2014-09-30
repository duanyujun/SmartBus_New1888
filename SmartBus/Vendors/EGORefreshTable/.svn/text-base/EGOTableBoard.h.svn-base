//
//  EGOTableBoard.h
//  SmartBus
//
//  Created by launching on 13-5-7.
//  Copyright (c) 2013年 Werner IT Consultancy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHSampleBoard.h"
#import "EGORefreshTableHeaderView.h"
#import "EGOLoadMoreTableFooterView.h"

@interface EGOTableBoard : BHSampleBoard
<
EGORefreshTableHeaderDelegate,
EGOLoadMoreTableFooterDelegate,
UITableViewDataSource,
UITableViewDelegate
>

/* tableview */
@property (nonatomic, retain) BeeUITableView *egoTableView;

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
