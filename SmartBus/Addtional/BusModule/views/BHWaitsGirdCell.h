//
//  BHWaitsGirdCell.h
//  SmartBus
//
//  Created by launching on 14-3-4.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "Bee_UITableViewCell.h"

#define kNumberPerRow     4
#define kWaitsGridHeight  100.0

typedef void (^GirdCellBasicBlock)(BHUserModel *user);

@interface BHWaitsGirdCell : BeeUITableViewCell<CLLocationManagerDelegate>

@property (nonatomic, retain) NSArray *users;

- (void)gridCellSelectionBlock:(GirdCellBasicBlock)block;

@end
