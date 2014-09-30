//
//  BHAppHelper.m
//  SmartBus
//
//  Created by launching on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAppHelper.h"

@implementation BHAppHelper

@synthesize app = _app;

- (void)load
{
    _app = [[BHAppModel alloc] init];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(_app);
    [super unload];
}

- (void)getAppHomeInfo
{
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Home" )
    .PARAM( @"act", @"index" )
    .PARAM( @"key", [BHUtil encrypt:@"1" method:@"index"] )
    .USER_INFO( @"getAppInfo" )
    .TIMEOUT( 10 );
}

- (void)getAppAdverts
{
    NSString *url = [NSString stringWithFormat:@"%@advert/getadverts", SBDomain];
    self
    .HTTP_POST ( url )
    .PARAM ( [SMBusEncryption encryption:nil] )
    .USER_INFO (@"getAdverts")
    .TIMEOUT (10);
}

+ (void)submitAdvInfoById:(NSInteger)adid andType:(NSInteger)type
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:@"1" forKey:@"from"];
    [parameters setObject:[NSString stringWithFormat:@"%d", adid] forKey:@"adid"];
    [parameters setObject:[NSString stringWithFormat:@"%d", type] forKey:@"type"];
    [parameters setObject:[NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid] forKey:@"mid"];
    [parameters setObject:[NSString stringWithFormat:@"%f", [BHUserModel sharedInstance].coordinate.latitude] forKey:@"lat"];
    [parameters setObject:[NSString stringWithFormat:@"%f", [BHUserModel sharedInstance].coordinate.longitude] forKey:@"long"];
    [parameters setObject:[BeeSystemInfo deviceUUID] forKey:@"DeviceId"];
    
    self
    .HTTP_GET( [BHUtil urlStringWithMethod:@"ADInfo" parameters:parameters] )
    .USER_INFO( @"submitAdvInfo" )
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
        
        if ( [request.userInfo is:@"getAppInfo"] )
        {
            NSDictionary *data = result[@"data"];
            
            NSDictionary *recommendinfo = data[@"recommend"];
            BHSectionModel *recommend = [[BHSectionModel alloc] init];
            recommend.subject = [recommendinfo[@"tit"] asNSString];
            recommend.summary = [recommendinfo[@"con"] asNSString];
            recommend.cover = [recommendinfo[@"pic"] asNSString];
            _app.recommend = recommend;
            [recommend release];
            
            NSDictionary *liveinfo = data[@"liveinfo"];
            BHSectionModel *live = [[BHSectionModel alloc] init];
            live.subject = [liveinfo[@"tit"] asNSString];
            live.summary = [liveinfo[@"con"] asNSString];
            live.cover = [liveinfo[@"pic"] asNSString];
            _app.liveinfo = live;
            [live release];
        }
        else if ( [request.userInfo is:@"getAdverts"] )
        {
            [_app.banners removeAllObjects];
            
            NSArray *banners = result[@"adverts"];
            for (NSDictionary *bannerinfo in banners)
            {
                BHBannerModel *banner = [[BHBannerModel alloc] init];
                banner.bid = [bannerinfo[@"advert_id"] integerValue];
                banner.cover = bannerinfo[@"pic_iphone"];
                banner.direct = bannerinfo[@"redirect"];
                [_app addBanner:banner];
                [banner release];
            }
        }
	}
}


@end
