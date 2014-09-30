//
//  BHTransferBar.h
//  SmartBus
//
//  Created by launching on 13-10-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_UIView.h"

#define kTransferBarHeight  120.f

@interface BHTransferBar : BeeUIView

@property (nonatomic, retain) BeeUITextField *startTextField;
@property (nonatomic, retain) BeeUITextField *endTextField;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coor;  // 我的位置的经纬度

- (void)disActiveAllKeyboard;

@end
