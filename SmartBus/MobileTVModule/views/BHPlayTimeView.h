//
//  BHPlayTimeView.h
//  SmartBus
//
//  Created by 王 正星 on 13-10-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    BHPlayTimeTypeBegin,
    BHPlayTimeTypeEnd
}BHPlayTimeType;

@interface BHPlayTimeView : UIView

- (id)initWithFrame:(CGRect)frame withType:(BHPlayTimeType)type;
- (void)setTime:(NSString *)time;

@end
