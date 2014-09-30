//
//  BHModifyPwdBoard.h
//  SmartBus
//
//  Created by kukuasir on 13-11-10.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSampleBoard.h"

@interface BHModifyPwdBoard : BHSampleBoard

AS_SIGNAL( MODIFY_PWD );

@property (nonatomic, assign) BOOL forgeted;  // 是否是忘记密码
@property (nonatomic, retain) NSString *uphone;

@end
