//
//  BHUsersCell.h
//  SmartBus
//
//  Created by launching on 13-11-14.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_UITableViewCell.h"

#define kUsersCellHeight  66.f

@class BHUsersCell;

@protocol BHUsersCellDelegate <NSObject>
- (void)usersCellDidSelectAvator:(BHUsersCell *)cell;
@optional
- (void)usersCell:(BHUsersCell *)cell toggleFocus:(BOOL)toggle;
@end

@interface BHUsersCell : BeeUITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier hideFocus:(BOOL)hide;

@property (nonatomic, retain) BHUserModel *user;
@property (nonatomic, assign) id<BHUsersCellDelegate> delegate;

@end
