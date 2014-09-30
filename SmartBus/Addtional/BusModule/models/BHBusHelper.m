//
//  BHBusModel.m
//  SmartBus
//
//  Created by launching on 13-9-29.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHBusHelper.h"
#import "BUSDBHelper.h"
#import "BHUtil.h"
#import "BHDefines.h"

// 范围
#define kArroundRange   500

@implementation BHBusHelper

@synthesize nodes = _nodes, buses = _buses, paths = _paths, addInfo = _addInfo, jnURL = _jnURL;

- (void)load
{
    _nodes = [[NSMutableArray alloc] initWithCapacity:0];
    _buses = [[NSMutableArray alloc] initWithCapacity:0];
    _paths = [[NSMutableArray alloc] initWithCapacity:0];
    _addInfo = [[LKAdditionInfo alloc] init];
    [super load];
}

- (void)unload
{
    [_nodes removeAllObjects];
    [_buses removeAllObjects];
    [_paths removeAllObjects];
    SAFE_RELEASE(_nodes);
    SAFE_RELEASE(_buses);
    SAFE_RELEASE(_paths);
    SAFE_RELEASE(_addInfo);
    SAFE_RELEASE(_jnURL);
    [super unload];
}

- (void)getStationInfo:(NSInteger)st_id
{
    NSDictionary *params = @{@"st_id":[NSNumber numberWithInt:st_id],
                             @"uid":[NSNumber numberWithInt:[BHUserModel sharedInstance].uid]};
    NSString *url = [NSString stringWithFormat:@"%@line/getStation", SBDomain];
    self
    .HTTP_GET( url )
    .PARAM ([SMBusEncryption encryption:params])
    .USER_INFO ( @"getStationInfo" )
    .TIMEOUT( 10 );
}

- (void)getNewDynamic:(int)weiba_id inStation:(int)st_id
{
    NSDictionary *dictionary = @{@"app":@"api",
                                 @"mod":@"Info",
                                 @"act":@"getNewWeibaInfo",
                                 @"wid":[NSNumber numberWithInt:weiba_id],
                                 @"key":[BHUtil encrypt:[NSString stringWithFormat:@"%d", weiba_id] method:@"getNewWeibaInfo"]};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    if ( st_id > 0 ) {
        [params setObject:[NSNumber numberWithInt:st_id] forKey:@"sid"];
    }
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( params )
    .USER_INFO( @"getNewWeibaInfo" )
    .TIMEOUT( 10 );
}

- (void)getLEDByStationId:(NSInteger)staid
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[NSString stringWithFormat:@"%d", staid] forKey:@"sid"];
    [parameters setObject:[BHUtil encrypt:[NSString stringWithFormat:@"%d", staid] method:@"LEDByStationId"] forKey:@"key"];
    
    self
    .HTTP_GET( [BHUtil urlStringWithMethod:@"LEDByStationId" parameters:parameters] )
    .USER_INFO( @"LEDByStationId" )
    .TIMEOUT( 10 );
}

- (void)getLineInfo:(int)line_id updown:(int)ud_type station:(int)st_id
{
    NSDictionary *param = @{@"line_id":[NSNumber numberWithInt:line_id],
                            @"updown_type":[NSNumber numberWithInt:ud_type],
                            @"st_id":[NSNumber numberWithInt:st_id],
                            @"uid":[NSNumber numberWithInt:[BHUserModel sharedInstance].uid]};
    NSString *url = [NSString stringWithFormat:@"%@line/getLineAd", SBDomain];
    self
    .HTTP_GET( url )
    .PARAM ([SMBusEncryption encryption:param])
    .USER_INFO ( @"getLineInfo" )
    .TIMEOUT( 10 );
}

- (void)getLineDetail:(int)line_id updown:(int)ud_type station:(int)st_id
{
    NSDictionary *param = @{@"line_id":[NSNumber numberWithInt:line_id],
                            @"updown_type":[NSNumber numberWithInt:ud_type],
                            @"st_id":[NSNumber numberWithInt:st_id]};
    NSString *url = [NSString stringWithFormat:@"%@line/getLine", SBDomain];
    self
    .HTTP_GET( url )
    .PARAM ([SMBusEncryption encryption:param])
    .USER_INFO ( @"getLineDetail" )
    .TIMEOUT( 10 );
}

- (void)getRealTimeDataByRouteId:(int)line_id andUDType:(int)ud_type
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[NSString stringWithFormat:@"%d", line_id] forKey:@"line_id"];
    [parameters setObject:[NSString stringWithFormat:@"%d", ud_type] forKey:@"updown_type"];
    
    NSString *url = [NSString stringWithFormat:@"%@Bus/getBuses",SBDomain];
    self
    .HTTP_POST ( url )
    .PARAM ( [SMBusEncryption encryption:parameters] )
    .USER_INFO (@"getRealtimeData")
    .TIMEOUT (10);
}

- (void)getRoutePathsById:(NSInteger)rid
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[NSString stringWithFormat:@"%d", rid] forKey:@"lid"];
    [parameters setObject:[BHUtil encrypt:[NSString stringWithFormat:@"%d", rid] method:@"getlinepath"] forKey:@"key"];
    
    self
    .HTTP_GET( [BHUtil urlStringWithMethod:@"getlinepath" parameters:parameters] )
    .USER_INFO( @"getLinePath" )
    .TIMEOUT( 10 );
}

- (void)getJNBusInfoByRoute:(LKRoute *)route
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[NSString stringWithFormat:@"%d", route.line_code] forKey:@"line_id"];
    [parameters setObject:[NSString stringWithFormat:@"%d", route.ud_type] forKey:@"updown_type"];
    
    NSString *url = [NSString stringWithFormat:@"%@line/getJNing", SBDomain];
    self
    .HTTP_POST ( url )
    .PARAM ( [SMBusEncryption encryption:parameters] )
    .USER_INFO (@"getJiangNing")
    .TIMEOUT (10);
}

- (void)getWaitsForStation:(NSInteger)st_id
{
    NSDictionary *param = @{@"st_id":[NSNumber numberWithInt:st_id]};
    NSString *url = [NSString stringWithFormat:@"%@line/getStationWaiters", SBDomain];
    
    self
    .HTTP_GET( url )
    .PARAM ([SMBusEncryption encryption:param])
    .USER_INFO ( @"getStationWaiters" )
    .TIMEOUT( 10 );
}

- (void)checkInStation:(NSInteger)sid
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    NSString *enc = [BHUserModel sharedInstance].uid > 0 ? str_mid : @"1";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[NSString stringWithFormat:@"%d", sid] forKey:@"sid"];
    [parameters setObject:str_mid forKey:@"mid"];
    [parameters setObject:[BHUtil encrypt:enc method:@"station_check"] forKey:@"key"];
    
    self
    .HTTP_GET( [BHUtil urlStringWithMethod:@"station_check" parameters:parameters] )
    .USER_INFO( @"checkInStation" )
    .TIMEOUT( 10 );
}

- (void)getStationChecks
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    NSString *enc = [BHUserModel sharedInstance].uid > 0 ? str_mid : @"1";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:str_mid forKey:@"mid"];
    [parameters setObject:[BHUtil encrypt:enc method:@"getStationCheckList"] forKey:@"key"];
    
    self
    .HTTP_GET( [BHUtil urlStringWithMethod:@"getStationCheckList" parameters:parameters] )
    .USER_INFO( @"getStationCheckList" )
    .TIMEOUT( 10 );
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    [super handleRequest:request];
    
    if ( request.sending )
    {
        // TODO:
    }
	else if ( request.succeed )
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
        
		if ( [request.userInfo is:@"getStationInfo"] )
        {
            NSLog(@"getStationInfo :%@", result);
            
            _addInfo.wait = [result[@"waiters"] intValue];
            _addInfo.collect_id = [result[@"collect"] intValue];
            
            [_addInfo removeAllBanners];
            
            if ( [result[@"advert"] isKindOfClass:[NSArray class]] )
            {
                NSArray *adverts = result[@"advert"];
                for ( NSDictionary *advert in adverts )
                {
                    BHBannerModel *banner = [[BHBannerModel alloc] init];
                    banner.bid = [advert[@"advert_id"] intValue];
                    banner.cover = advert[@"pic_iphone"];
                    banner.direct = advert[@"redirect"];
                    [_addInfo addBanner:banner];
                    [banner release];
                }
            }
            else
            {
                BHBannerModel *banner = [[BHBannerModel alloc] init];
                banner.bid = [result[@"advert"][@"advert_id"] intValue];
                banner.cover = result[@"advert"][@"pic_iphone"];
                banner.direct = result[@"advert"][@"redirect"];
                [_addInfo addBanner:banner];
                [banner release];
            }
        }
        else if ( [request.userInfo is:@"getNewWeibaInfo"] )
        {
            NSDictionary *data = result[@"data"];
            _addInfo.section.wid = [[[data objectForKey:@"wid"] asNSString] integerValue];
            _addInfo.section.subject = [[data objectForKey:@"title"] asNSString];
            _addInfo.section.summary = [[data objectForKey:@"content"] asNSString];
            _addInfo.section.cover = [[data objectForKey:@"conimg"] asNSString];
        }
        else if ( [request.userInfo is:@"getLineInfo"] )
        {
            NSLog(@"getLineInfo :%@", result);
            
            _addInfo.collect_id = [result[@"collect"] intValue];
            _addInfo.notice = result[@"notice"];
            
            [_addInfo removeAllBanners];
            BHBannerModel *banner = [[BHBannerModel alloc] init];
            banner.bid = [result[@"advert"][@"advert_id"] intValue];
            banner.cover = result[@"advert"][@"pic_iphone"];
            banner.direct = result[@"advert"][@"redirect"];
            [_addInfo addBanner:banner];
            [banner release];
        }
        else if ( [request.userInfo is:@"getLineDetail"] )
        {
            NSLog(@"getLineDetail->%@", result);
        }
        else if ( [request.userInfo is:@"LEDByStationId"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for ( NSDictionary *data in datas )
            {
                BHLEDDesc *led = [[BHLEDDesc alloc] init];
                led.rid = [[data objectForKey:@"lineid"] integerValue];
                led.rname = [data objectForKey:@"line_name"];
                led.dest = [data objectForKey:@"destination"];
                led.busId = [[data objectForKey:@"busId"] integerValue];
                led.currentLevel = [[data objectForKey:@"currentLevel"] integerValue];
                led.theLevel = [[data objectForKey:@"thelevel"] integerValue];
                led.distance = [[data objectForKey:@"Distance"] floatValue];
                led.rtime = [[data objectForKey:@"reloadTime"] integerValue];
                [self.nodes addObject:led];
                [led release];
            }
        }
        else if ( [request.userInfo is:@"getRealtimeData"] )
        {
            NSArray *buses = [result objectForKey:@"buses"];
            //NSLog(@"buses :%@", buses);
            
            [_buses removeAllObjects];
            
            for ( NSDictionary *busInfo in buses)
            {
                LKBus *bus = [[LKBus alloc] init];
                bus.bus_id = [busInfo[@"id"] intValue];
                bus.bus_speed = [busInfo[@"speed"] floatValue];
                bus.bus_coor = CLLocationCoordinate2DMake([busInfo[@"st_real_lat"] doubleValue], [busInfo[@"st_real_lon"] doubleValue]);
                bus.st_id = [busInfo[@"st_id"] intValue];
                bus.st_level = [busInfo[@"st_level"] intValue];
                bus.st_dis = [busInfo[@"st_dis"] doubleValue];
                bus.rtime = [busInfo[@"updated"] intValue];
                [_buses addObject:bus];
                [bus release];
            }
        }
        else if ( [request.userInfo is:@"getLinePath"] )
        {
            [self.paths removeAllObjects];
            
            NSDictionary *data = [result objectForKey:@"data"];
            NSArray *paths = [(NSString *)[data objectForKey:@"pathinfo"] objectFromJSONString];
            for ( NSDictionary *path in paths )
            {
                [self.paths addObject:path];
            }
        }
        else if ( [request.userInfo is:@"getJiangNing"] )
        {
            NSString *urlString = result[@"url"];
            self.jnURL = [NSURL URLWithString:urlString];
        }
        else if ( [request.userInfo is:@"getStationWaiters"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *waiters = [result objectForKey:@"waiters"];
            for ( NSDictionary *waiter in waiters )
            {
                BHUserModel *user = [[BHUserModel alloc] init];
                user.uid = [waiter[@"user"][@"uid"] intValue];
                user.uname = waiter[@"user"][@"uname"];
                user.avator = waiter[@"user"][@"avatar"];
                user.ugender = [waiter[@"user"][@"sex"] intValue];
                user.coordinate = CLLocationCoordinate2DMake([waiter[@"lat"] doubleValue], [waiter[@"lon"] doubleValue]);
                [self.nodes addObject:user];
                [user release];
            }
        }
        else if ( [request.userInfo is:@"checkInStation"] )
        {
            if ( self.succeed ) {
                [self presentMessageTips:@"签到成功"];
            } else {
                [self presentMessageTips:@"已签到"];
            }
        }
        else if ( [request.userInfo is:@"getStationCheckList"] )
        {
            NSArray *datas = [result objectForKey:@"data"];
            for (NSDictionary *data in datas)
            {
                BHCheckModel *check = [[BHCheckModel alloc] init];
                check.ctime = [data objectForKey:@"ctime"];
                check.staid = [[data objectForKey:@"station_id"] integerValue];
                check.userid = [[data objectForKey:@"uid"] integerValue];
                check.coor = CLLocationCoordinate2DMake([data[@"gd_lat"] doubleValue], [data[@"gd_long"] doubleValue]);
                [self.nodes addObject:check];
                [check release];
            }
        }
	}
	else if ( request.failed )
	{
		NSLog(@"[ERROR] :%@", [NSString stringWithFormat:@"%@_%@", request.userInfo, request.error]);
	}
}

@end
