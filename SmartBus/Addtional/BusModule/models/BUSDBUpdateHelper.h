//
//  BUSDBUpdateHelper.h
//  SmartBus
//
//  Created by 王 正星 on 14-6-26.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "Bee_Model.h"

@protocol BUSDBUpdateHelperDelegate;

@interface BUSDBUpdateHelper : NSObject

@property (nonatomic, assign) id<BUSDBUpdateHelperDelegate> delegate;

- (BOOL)checkUpdate:(NSDictionary *)dic;

@end

@protocol BUSDBUpdateHelperDelegate <NSObject>
@optional
- (void)DBUpdateInfo:(NSString *)info;
- (void)DBUpdateFinish;
@end