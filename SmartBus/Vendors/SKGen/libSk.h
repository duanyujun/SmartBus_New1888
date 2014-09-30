//
//  libSk.h
//  libSk
//
//  Created by user on 13-1-18.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface libSk : NSObject

+ (NSString *)gen:(NSString *)url withKey:(NSString *)key withIp:(NSString *)ip;
+ (NSString *)skUrl:(NSString *)url;
+ (NSString *)postSk:(NSString *)url;
@end
