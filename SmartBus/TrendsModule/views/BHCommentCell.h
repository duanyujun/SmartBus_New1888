//
//  BHCommentCell.h
//  SmartBus
//
//  Created by launching on 13-11-12.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_UITableViewCell.h"

#define kCommentCellHeight  70.f

@interface BHCommentCell : BeeUITableViewCell

- (void)setComment:(id)comment;
- (void)setFinal:(BOOL)final;

@end
