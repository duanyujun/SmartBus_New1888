//
//  ZipArchiveHandler.h
//  SmartBus
//
//  Created by launching on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZipArchiveHandler : NSObject

// 把工程下的ZIP包解压到沙盒中
+ (BOOL)handleUnzip;

@end
