//
//  ZipArchiveHandler.m
//  SmartBus
//
//  Created by launching on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "ZipArchiveHandler.h"
#import "ZipArchive.h"

//#define ZIP_PWD  @"nicholas"

#define KEY_UNZIPED   @"key_unziped"
#define KEY_VERSION   @"key_current_version"

@implementation ZipArchiveHandler

+ (BOOL)handleUnzip
{
    NSString *l_zipfile = [[NSBundle mainBundle] pathForResource:@"ibus_datas" ofType:@"zip"];
    
    NSString *unzipto = [DOCUMENTS stringByAppendingPathComponent:@"caches"];
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:unzipto] ) {
		[[NSFileManager defaultManager] createDirectoryAtPath:unzipto withIntermediateDirectories:YES attributes:nil error:NULL];
	}
    
    // 判断是否已解压,当版本一致并且已解压时跳过
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [defaults objectForKey:KEY_VERSION];
    NSString *unziped = [defaults objectForKey:KEY_UNZIPED];
    BOOL ret = [version is:IosAppVersion] && unziped && [unziped is:@"true"];
    if ( ret ) {
        return YES;
    }
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    ret = [zip UnzipOpenFile:l_zipfile];
    if ( ret )
    {
        ret = [zip UnzipFileTo:unzipto overWrite:YES];
        if ( ret )
        {
            ret = [zip UnzipCloseFile];
            if ( ret ) {
                // 解压后设置已解压标志和当前版本号
                [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:KEY_UNZIPED];
                [[NSUserDefaults standardUserDefaults] setObject:IosAppVersion forKey:KEY_VERSION];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    [zip release];
    
    return ret;
}

@end
