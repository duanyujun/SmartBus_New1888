//
//  BHUserCheckBoard.h
//  SmartBus
//
//  Created by launching on 13-11-7.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSampleBoard.h"

typedef enum {
    CheckModeUserName,
    CheckModeGender,
    CheckModeBirthday,
    CheckModeAddress,
    CheckModeProfession,
    CheckModeSignature
} CheckMode;

@interface BHUserCheckBoard : BHSampleBoard

AS_SIGNAL( DONE_MODIFY );

@property (nonatomic, assign) BOOL registered;  // 是否来自注册

- (id)initWithCheckMode:(CheckMode)mode;

@end
