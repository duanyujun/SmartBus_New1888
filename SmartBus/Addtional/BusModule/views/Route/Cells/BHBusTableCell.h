//
//  BHBusTableCell.h
//  BusHelper
//
//  Created by launching on 13-8-28.
//  Copyright (c) 2013年 仲 阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHRealTimeData.h"

#define kBusTableCellHeight  52.f

@interface BHBusTableCell : BeeUITableViewCell

- (void)setRealTimeData:(BHRealTimeData *)data;

@end
