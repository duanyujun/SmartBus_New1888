//
//  BHAnnouceCell.h
//  SmartBus
//
//  Created by launching on 13-12-10.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_UITableViewCell.h"

#define kAnnouceCellHeight  55.f

@class BHAnnouceModel;

@interface BHAnnouceCell : BeeUITableViewCell

@property (nonatomic, retain) BHAnnouceModel *annouce;

@end
