//
//  NSString+Tool.m
//  WSChat
//
//  Created by fengren on 13-4-1.
//  Copyright (c) 2013年 WSChat. All rights reserved.
//

#import "NSString+Tool.h"

@implementation NSString (Tool)

- (BOOL) fileExist {
    if(![[NSFileManager defaultManager] fileExistsAtPath:self])
        return NO;
    return YES;
}
- (BOOL) directoryExist {
    BOOL isDir = YES;
    if(![[NSFileManager defaultManager] fileExistsAtPath: self isDirectory:&isDir]){
        return NO;
    }
    return YES;
}

- (BOOL) isEmpty {
    if (self &&self.length > 0) {
        return NO;
    }
    return YES;
}

- (BOOL) isInArray : (NSArray *) datas {
    for (NSString *d in datas) {
        if ([d isEqualToString:self]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *) urlEncode {
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlDecode {
    NSMutableString *new = [[self mutableCopy] autorelease];
    [new replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, [new length])];
    [new replaceOccurrencesOfString:@"+" withString:@"%20" options:0 range:NSMakeRange(0, [new length])];
    [new replaceOccurrencesOfString:@"&nbsp;" withString:@"%20" options:0 range:NSMakeRange(0, [new length])];
    return [new stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


@end