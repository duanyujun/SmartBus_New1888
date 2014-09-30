//
//  BHEPGListCell.h
//  SmartBus
//
//  Created by 王 正星 on 13-10-24.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    DateTypeBefore,
    DateTypeNow,
    DateTypeAfter
}DateType;

@interface BHEPGListCell : UITableViewCell
{
    
}
- (void)setCellData:(NSDictionary *)dic withDateType:(DateType)type isNowIndex:(BOOL)isNow;

@end
