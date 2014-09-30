//
//  BHUtil.m
//  SmartBus
//
//  Created by launching on 13-9-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHUtil.h"
#import "NSDate+Helper.h"
#import "SFHFKeychainUtils.h"
#import "BHLaunchModel.h"

BOOL connectedToNetwork(void)
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

@implementation BHUtil

+ (BOOL)existNewVersion
{
    NSString *appVersion = [BeeSystemInfo appVersion];  // 本地应用版本号
    NSString *systemVersion = [BHLaunchModel sharedInstance].version;  // 服务器上版本号
    if ( systemVersion && systemVersion.length > 0 )
    {
        return [appVersion compare:systemVersion options:NSNumericSearch] == NSOrderedAscending;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)judgeTipsMessage:(int)msgId
{
    BOOL result = YES;
    
    // 实现逻辑: 判断本地缓存通知ID与此次通知的ID是否一致。一致则不提示;否则提示
    NSString *localTipsId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOCAL_MSG_ID"];
    if ( (localTipsId && localTipsId.length > 0) && ([localTipsId intValue] == msgId) )
    {
        result = NO;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", msgId] forKey:@"LOCAL_MSG_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return result;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-35-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)saveUserID:(int)uid
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:uid] forKey:@"USERID"];
    [defaults synchronize];
}

+ (int)userID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [(NSString*)[defaults objectForKey:@"USERID"] integerValue];
}

+ (void)saveUserPhone:(NSString *)uphone andPassword:(NSString *)pwd
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ( uphone && uphone.length > 0 )
    {
        [defaults setObject:uphone forKey:@"USER_PHONE"];
    }
    [defaults setObject:pwd forKey:@"USER_PWD"];
    [defaults synchronize];
}

+ (NSString *)getUserPhoneFromCache
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_PHONE"];
}

+ (NSString *)getPasswordFromCache
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_PWD"];
}


+ (NSDate *)correctDate
{
    return [NSDate dateWithTimeIntervalSinceNow:-[BHAPP timeIntervalWithServer]];
}

+ (NSString *)correctDateString
{
    NSDate *date = [BHUtil correctDate];
    return [NSDate stringFromDate:date];
}

+ (NSString *)urlStringWithMethod:(NSString *)method parameters:(NSDictionary *)parameters
{
    NSMutableString *urlString = [NSMutableString stringWithCapacity:0];
    [urlString appendString:[BUSDomain stringByReplacingOccurrencesOfString:@":action" withString:method]];
    
    if ( parameters )
    {
        for ( NSString *key in [parameters allKeys] )
        {
            [urlString appendString:key];
            [urlString appendString:@"="];
            [urlString appendString:[parameters objectForKey:key]];
            [urlString appendString:@"/"];
        }
    }
    
    return [[urlString substringToIndex:urlString.length - 1] trim];
}

+ (NSString *)encrypt:(NSString *)str method:(NSString *)method
{
    NSString *string = [str MD5];
    string = [string stringByAppendingString:@"#"];
    string = [string stringByAppendingString:method];
    return [string MD5];
}

+ (void)clearDBCache
{
    // 清除数据库缓存
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *downloadDirectory = [DOCUMENTS stringByAppendingPathComponent:@"download"];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:downloadDirectory error:nil];
    for (NSString *dirContent in contents) {
        NSString *subpath = [downloadDirectory stringByAppendingPathComponent:dirContent];
        [fileManager removeItemAtPath:subpath error:nil];
    }
}

@end
