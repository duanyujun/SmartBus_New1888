//
//  BHModifyUserBoard.h
//  SmartBus
//
//  Created by launching on 13-11-7.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSampleBoard.h"

@interface BHModifyUserBoard : BHSampleBoard

AS_SIGNAL( EDIT_AVATOR );
AS_SIGNAL( TOGGLE_EDIT );
AS_NOTIFICATION( HAVE_UPDATE );

@property (nonatomic, assign) BOOL registed;  // 是否来自注册

- (id)initWithUserId:(NSInteger)uid;

@end
