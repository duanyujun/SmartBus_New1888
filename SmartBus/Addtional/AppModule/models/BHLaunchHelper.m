//
//  BHLaunchHelper.m
//  SmartBus
//
//  Created by launching on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHLaunchHelper.h"
#import "NSDate+Helper.h"

@implementation BHLaunchHelper

DEF_NOTIFICATION( TIPS_IMPORTANT );

- (void)getLaunchInfo
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:@"api" forKey:@"app"];
    [parameters setObject:@"User" forKey:@"mod"];
    [parameters setObject:@"loadingios" forKey:@"act"];
    [parameters setObject:[BeeSystemInfo deviceUUID] forKey:@"deviceid"];
    [parameters setObject:[BeeSystemInfo appVersion] forKey:@"version"];
    [parameters setObject:[BHUtil encrypt:@"1" method:@"loadingios"] forKey:@"key"];
    
    if ( [BHUtil userID] > 0 )
    {
        [parameters setObject:[BHUtil getUserPhoneFromCache] forKey:@"phone"];
    }
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( parameters )
    .USER_INFO( @"getLaunchInfo" )
    .TIMEOUT( 10 );
}

- (void)submitAppToken:(NSString *)token
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:@"api" forKey:@"app"];
    [parameters setObject:@"User" forKey:@"mod"];
    [parameters setObject:@"putiostoken" forKey:@"act"];
    [parameters setObject:[BeeSystemInfo deviceUUID] forKey:@"deviceid"];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:[BeeSystemInfo appVersion] forKey:@"version"];
    [parameters setObject:[BHUtil encrypt:@"1" method:@"putiostoken"] forKey:@"key"];
    
    if ( [BHUtil userID] > 0 )
    {
        [parameters setObject:[BHUtil getUserPhoneFromCache] forKey:@"phone"];
    }
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( parameters )
    .USER_INFO( @"submitAppToken" )
    .TIMEOUT( 10 );
}

- (void)getImportNotice
{
    NSString *urlString = @"http://trafficomm.jstv.com/smartBus/Module=BusHelper/Controller=Message/Action=ImportentNotie";
    self
    .HTTP_GET( urlString )
    .USER_INFO( @"getImportNotice" )
    .TIMEOUT( 10 );
}

- (void)checkTime
{
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Home" )
    .PARAM( @"act", @"checkTime" )
    .PARAM( @"key", [BHUtil encrypt:@"1" method:@"checkTime"] )
    .USER_INFO( @"checkTime" )
    .TIMEOUT( 10 );
}

- (void)SBGetVersion
{
    NSString *url = [NSString stringWithFormat:@"%@Startup/getVersion",SBDomain];
    self
    .HTTP_GET( url )
    .PARAM( @"category", @"10" )
    .USER_INFO( @"SBGetVersion" )
    .TIMEOUT( 10 );
}

#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    [super handleRequest:request];
    
	if ( request.succeed )
	{
        NSDictionary *result = [request.responseString objectFromJSONString];
        if ( [result[@"message"][@"code"] integerValue] > 0 )
        {
            NSLog(@"[EROOR]%@_%@", request.userInfo, result[@"message"][@"text"]);
            self.succeed = NO;
            return;
        }
        else
        {
            self.succeed = YES;
        }
        
        if ( [request.userInfo is:@"getLaunchInfo"] )
        {
            NSDictionary *data = result[@"data"];
            NSDictionary *ad = data[@"Ad"];
            NSDictionary *ios = data[@"IOS"];
            
            [BHLaunchModel sharedInstance].adv_id = [ad[@"id"] integerValue];
            [BHLaunchModel sharedInstance].splash = ad[@"iosimage_url"];
            [BHLaunchModel sharedInstance].adv = ad[@"url"];
            [BHLaunchModel sharedInstance].version = ios[@"Version"];
            [BHLaunchModel sharedInstance].tips = ios[@"tips"];
            [BHLaunchModel sharedInstance].forced = [ios[@"force"] boolValue];
            if ( IS_IPHONE_5 ) {
                [BHLaunchModel sharedInstance].splash = ad[@"ios7image_url"];
            }
        }
        else if ( [request.userInfo is:@"submitAppToken"] )
        {
            // 提交了就OK
        }
        else if ( [request.userInfo is:@"getImportNotice"] )
        {
            NSDictionary *data = [[result objectForKey:@"data"] asNSDictionary];
            if ( [BHUtil judgeTipsMessage:[[result objectForKey:@"id"] intValue]] )
            {
                NSString *notice = [[data objectForKey:@"notice"] asNSString];
                if ( notice && notice.length > 0 ) {
                    [self postNotification:self.TIPS_IMPORTANT withObject:notice];
                }
            }
        }
		else if ( [request.userInfo is:@"checkTime"] )
        {
            double secs = [result[@"data"][@"time"] doubleValue];
            NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:secs];
            [BHAPP setTimeIntervalWithServer:[[NSDate date] timeIntervalSinceDate:serverDate]];
        }
        else if ( [request.userInfo is:@"SBGetVersion"] )
        {
            NSLog(@"SBGetVersion -> %@",result);
            
            // 时间校正
            double secs = [result[@"timestamp"] doubleValue];
            [BHAPP setTimeIntervalWithServer:([[NSDate date] timeIntervalSince1970]- secs)];
            
            NSDictionary *advert = result[@"advert"];
            NSDictionary *version = result[@"version"];
            
            [BHLaunchModel sharedInstance].adv_id = [advert[@"advert_id"] integerValue];
            [BHLaunchModel sharedInstance].splash = IS_IPHONE_5 ? advert[@"pic_iphone5"] : advert[@"pic_iphone"];
            [BHLaunchModel sharedInstance].adv = advert[@"redirect"];
            [BHLaunchModel sharedInstance].version = version[@"number"];
            [BHLaunchModel sharedInstance].tips = version[@"tips"];
            [BHLaunchModel sharedInstance].forced = [version[@"force"] boolValue];
        }
	}
	else if ( request.failed )
	{
		NSLog(@"[ERROR] %@:%@", request.userInfo, request.error);
	}
}

@end
