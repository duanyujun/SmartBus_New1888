//
//  BHFavoriteHelper.m
//  SmartBus
//
//  Created by launching on 13-10-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHFavoriteHelper.h"
#import "BUSDBHelper.h"
#import "NSString+BeeExtension.h"

@implementation BHFavoriteHelper

@synthesize favorites = _favorites;
@synthesize succeed = _succeed;

- (void)load
{
    self.favorites = [NSMutableArray arrayWithCapacity:0];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(_favorites);
    [super unload];
}

- (void)addStationCollect:(int)st_id
{
    NSNumber *n_uid = [NSNumber numberWithInt:[BHUserModel sharedInstance].uid];
    NSDictionary *params = @{@"uid":n_uid, @"st_id":[NSNumber numberWithInt:st_id]};
    NSString *urlString = [NSString stringWithFormat:@"%@collect/addStation", SBDomain];
    
    self
    .HTTP_GET( urlString )
    .PARAM ( [SMBusEncryption encryption:params] )
    .USER_INFO ( @"addStation‍Collect" )
    .TIMEOUT( 10 );
}

- (void)removeStationCollect:(int)collect_id
{
    NSNumber *n_uid = [NSNumber numberWithInt:[BHUserModel sharedInstance].uid];
    NSDictionary *params = @{@"uid":n_uid, @"id":[NSNumber numberWithInt:collect_id]};
    NSString *urlString = [NSString stringWithFormat:@"%@collect/removeStation", SBDomain];
    
    self
    .HTTP_GET( urlString )
    .PARAM ( [SMBusEncryption encryption:params] )
    .USER_INFO ( @"removeStationCollect‍" )
    .TIMEOUT( 10 );
}

- (void)addLineCollect:(int)line_id updown:(int)ud_type stationId:(int)st_id
{
    NSNumber *n_uid = [NSNumber numberWithInt:[BHUserModel sharedInstance].uid];
    NSDictionary *params = @{@"uid":n_uid, @"st_id":[NSNumber numberWithInt:st_id], @"line_id":[NSNumber numberWithInt:line_id], @"updown_type":[NSNumber numberWithInt:ud_type]};
    NSString *urlString = [NSString stringWithFormat:@"%@collect/addLineStation", SBDomain];
    
    self
    .HTTP_GET( urlString )
    .PARAM ( [SMBusEncryption encryption:params] )
    .USER_INFO ( @"addLineCollect‍" )
    .TIMEOUT( 10 );
}

- (void)removeLineCollect:(int)collect_id
{
    NSNumber *n_uid = [NSNumber numberWithInt:[BHUserModel sharedInstance].uid];
    NSDictionary *params = @{@"uid":n_uid, @"id":[NSNumber numberWithInt:collect_id]};
    NSString *urlString = [NSString stringWithFormat:@"%@collect/removeLineStation", SBDomain];
    
    self
    .HTTP_GET( urlString )
    .PARAM ( [SMBusEncryption encryption:params] )
    .USER_INFO ( @"removeLineCollect" )
    .TIMEOUT( 10 );
}

- (void)getFavorites
{
    NSNumber *n_uid = [NSNumber numberWithInt:[BHUserModel sharedInstance].uid];
    NSString *urlString = [NSString stringWithFormat:@"%@collect/getCollects", SBDomain];
    
    self
    .HTTP_GET( urlString )
    .PARAM ([SMBusEncryption encryption:@{@"uid":n_uid}])
    .USER_INFO ( @"getCollects" )
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
        NSLog(@"%@->%@", request.userInfo, result);
        
        if ( ![result[@"status"] is:@"ok"] )
        {
            NSLog(@"[EROOR]%@_%@", request.userInfo, result[@"message"][@"text"]);
            self.succeed = NO;
            return;
        }
        else
        {
            self.succeed = YES;
        }
        
		if ( [request.userInfo is:@"getCollects"] )
        {
            [self.favorites removeAllObjects];
            
            // 站台列表
            NSMutableArray *st_favs = [NSMutableArray arrayWithCapacity:0];
            NSArray *stations = [result[@"stations"] asNSArray];
            for ( NSDictionary *st_info in stations )
            {
                NSInteger st_id = [st_info[@"st_id"] intValue];
                NSString *st_name = st_info[@"st_name"];
                
                LKStation *station = (LKStation *)[[BUSDBHelper sharedInstance] queryStationByID:st_id];
                [station.st_routes addObjectsFromArray:[[BUSDBHelper sharedInstance] queryRoutesByStationName:st_name]];
                
                BHFavoriteModel *favorite = [[BHFavoriteModel alloc] init];
                favorite.favid = [st_info[@"id"] intValue];
                favorite.type = FAVORITE_TYPE_STATION;
                favorite.entity = [station retain];
                [st_favs addObject:favorite];
                [favorite release];
            }
            [self.favorites addObject:st_favs];
            
            // 线路列表
            NSMutableArray *line_favs = [NSMutableArray arrayWithCapacity:0];
            NSArray *lines = [result[@"line_sts"] asNSArray];
            for ( NSDictionary *line_info in lines )
            {
                int line_id = [line_info[@"line_id"] intValue];
                int updown = [line_info[@"updown_type"] intValue];
                int st_id = [line_info[@"st_id"] intValue];
                
                LKRoute *route = (LKRoute *)[[BUSDBHelper sharedInstance] queryRouteByID:line_id udType:updown];
                LKStation *site = (LKStation *)[[BUSDBHelper sharedInstance] queryStationByID:st_id];
                route.st_appoint = site;
                
                BHFavoriteModel *favorite = [[BHFavoriteModel alloc] init];
                favorite.favid = [line_info[@"id"] intValue];
                favorite.type = FAVORITE_TYPE_ROUTE;
                favorite.entity = [route retain];
                [line_favs addObject:favorite];
                [favorite release];
            }
            [self.favorites addObject:line_favs];
        }
        else if ( [request.userInfo is:@"addStation‍Collect"] || [request.userInfo is:@"addLineCollect‍"] )
        {
            self.collect_id = [result[@"id"] intValue];
            [self presentSuccessTips:@"添加收藏成功"];
        }
        else if ( [request.userInfo is:@"removeStationCollect‍"] || [request.userInfo is:@"removeLineCollect"] )
        {
            [self presentSuccessTips:@"取消收藏成功"];
        }
	}
	else if ( request.failed )
	{
		NSLog(@"error :%@", request.error);
	}
}


@end
