//
//  BHSetupHelper.m
//  SmartBus
//
//  Created by launching on 13-11-26.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSetupHelper.h"

@implementation BHSetupHelper

@synthesize status = _status;
@synthesize tips = _tips;

- (void)load
{
    self.status = [NSMutableArray arrayWithCapacity:0];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(_status);
    SAFE_RELEASE(_tips);
    [super unload];
}

- (void)feedback:(NSString *)content atPhone:(NSString *)phone username:(NSString *)uname
{
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Home" )
    .PARAM( @"act", @"Feedback" )
    .PARAM( @"username", uname )
    .PARAM( @"phone", phone )
    .PARAM( @"content", content )
    .PARAM( @"key", [BHUtil encrypt:phone method:@"Feedback"] )
    .USER_INFO( @"feedback" )
    .TIMEOUT( 10 );
}

- (void)getPrivacy
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Home" )
    .PARAM( @"act", @"getSettingPrivacy" )
    .PARAM( @"mid", str_mid )
    .PARAM( @"key", [BHUtil encrypt:str_mid method:@"getSettingPrivacy"] )
    .USER_INFO( @"getPrivacy" )
    .TIMEOUT( 10 );
}

- (void)setPrivacy:(PRIVACY_TYPE)type value:(NSInteger)value
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Home" )
    .PARAM( @"act", @"SettingPrivacy" )
    .PARAM( @"type", [NSNumber numberWithInt:type] )
    .PARAM( @"val", [NSNumber numberWithInt:value] )
    .PARAM( @"mid", str_mid )
    .PARAM( @"key", [BHUtil encrypt:str_mid method:@"SettingPrivacy"] )
    .USER_INFO( @"setPrivacy" )
    .TIMEOUT( 10 );
}

- (void)getInfosByType:(NSInteger)type
{
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Home" )
    .PARAM( @"act", @"Setting" )
    .PARAM( @"type", [NSNumber numberWithInt:type] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", type] method:@"Setting"] )
    .USER_INFO( @"getInfos" )
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
        
        if ( [request.userInfo is:@"getPrivacy"] )
        {
            NSArray *datas = [result objectForKey:@"data"];
            NSDictionary *datainfos = [datas objectAtIndex:0];
            
            [self.status removeAllObjects];
            
            NSString *dy = [datainfos objectForKey:@"dy"];
            [self.status addObject:dy];
            NSString *uc = [datainfos objectForKey:@"uc"];
            [self.status addObject:uc];
            NSString *si = [datainfos objectForKey:@"si"];
            [self.status addObject:si];
            NSString *bi = [datainfos objectForKey:@"bi"];
            [self.status addObject:bi];
        }
        else if ( [request.userInfo is:@"getInfos"] )
        {
            SAFE_RELEASE(_tips);
            _tips = [[result objectForKey:@"data"] retain];
        }
	}
	else if ( request.failed )
	{
		//
	}
}

@end
