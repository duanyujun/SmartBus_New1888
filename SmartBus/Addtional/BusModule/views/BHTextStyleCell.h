//
//  BHTextStyleCell.h
//  SmartBus
//
//  Created by launching on 14-8-1.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "Bee_UITableViewCell.h"

@interface BHTextStyleCell : BeeUITableViewCell

@property (nonatomic, retain) UITextField *textField;

- (void)fillTitle:(NSString *)title placeholder:(NSString *)placeholder;

@end
