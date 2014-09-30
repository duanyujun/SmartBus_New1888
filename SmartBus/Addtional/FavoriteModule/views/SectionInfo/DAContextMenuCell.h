//
//  DAContextMenuCell.h
//  SmartBus
//
//  Created by launching on 13-11-15.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_UITableViewCell.h"

typedef enum {
    BubbleVerticalAlignmentTop,
    BubbleVerticalAlignmentMiddle,
    BubbleVerticalAlignmentBottom
} BubbleVerticalAlignment;

@class DAContextMenuCell;

@protocol DAContextMenuCellDelegate <NSObject>
@optional
- (void)contextMenuCellDidSelectRow:(DAContextMenuCell *)cell;
- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell;
@end

@interface DAContextMenuCell : BeeUITableViewCell

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) BubbleVerticalAlignment verticalAlignment;
@property (nonatomic, assign) id<DAContextMenuCellDelegate> delegate;

- (void)setHeightForMenu:(CGFloat)height;

@end
