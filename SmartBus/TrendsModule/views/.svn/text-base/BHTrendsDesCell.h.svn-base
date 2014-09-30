//
//  BHTrendsDesCell.h
//  SmartBus
//
//  Created by launching on 13-12-12.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_UITableViewCell.h"
#import "BHTrendsModel.h"

@class BHTrendsDesCell;

@protocol BHTrendsDesCellDelegate <NSObject>
@optional
- (void)trendsDesCell:(BHTrendsDesCell *)cell didSelectUser:(BHUserModel *)user;
- (void)trendsDesCellDidEnterWeiba:(BHTrendsDesCell *)cell;
- (void)trendsDesCellDidStartPraise:(BHTrendsDesCell *)cell;
- (void)trendsDesCell:(BHTrendsDesCell *)cell didSelectImageView:(UIImageView *)view;
@end

@interface BHTrendsDesCell : BeeUITableViewCell

@property (nonatomic, assign) id<BHTrendsDesCellDelegate> delegate;
@property (nonatomic, retain) BHTrendsModel *trends;

- (void)addPraise:(BOOL)toggle;

@end
