//
//  BHTrendsCell.h
//  SmartBus
//
//  Created by launching on 13-11-13.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHTrendsModel.h"

@class BHTrendsCell;

@protocol BHTrendsCellDelegate <NSObject>
@optional
- (void)trendsCell:(BHTrendsCell *)cell didSelectAtIndex:(NSInteger)idx;
- (void)trendsCell:(BHTrendsCell *)cell didSelectUser:(BHUserModel *)user;
- (void)trendsCellDidEnterComment:(BHTrendsCell *)cell;
- (void)trendsCellDidStartPraise:(BHTrendsCell *)cell;
- (void)trendsCell:(BHTrendsCell *)cell didSelectImageView:(UIImageView *)view;
@end

@interface BHTrendsCell : BeeUITableViewCell

@property (nonatomic, assign) id<BHTrendsCellDelegate> delegate;
@property (nonatomic, retain) BHTrendsModel *trends;
@property (nonatomic, assign) NSInteger row;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier bSelf:(BOOL)bSelf;

- (void)addPraise:(BOOL)toggle;

@end
