//
//  BHAnnouceHelper.m
//  SmartBus
//
//  Created by user on 13-10-29.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAnnouceHelper.h"

@implementation BHAnnouceHelper

@synthesize nodes = _nodes;

- (void)load
{
    [super load];
    _nodes = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)unload
{
    [_nodes removeAllObjects];
    SAFE_RELEASE(_nodes);
    [super unload];
}

- (void)getNoticeList
{
    self.HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Home" )
    .PARAM( @"act", @"NoticeList" )
    .PARAM( @"id", @"1" )
    .PARAM( @"key", [BHUtil encrypt:@"1" method:@"NoticeList"] )
    .USER_INFO( @"noticeList" )
    .TIMEOUT( 10 );
}

- (void)getNewNotice
{
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Home" )
    .PARAM( @"act", @"NewNotice" )
    .PARAM( @"key", [BHUtil encrypt:@"1" method:@"NewNotice"] )
    .USER_INFO( @"newNotice" )
    .TIMEOUT( 10 );
}

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
            return;
        }
        
        if ( [request.userInfo is:@"noticeList"] )
        {
            [_nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for (NSDictionary *data in datas)
            {
                BHAnnouceModel *model = [[BHAnnouceModel alloc] init];
                model.annid = [data[@"id"] integerValue];
                model.ctime = [[data[@"ctime"] asNSString] doubleValue];
                model.title = [data[@"title"] asNSString];
                model.content = [data[@"content"] asNSString];
                model.conimg = [data[@"conimg"] asNSString];
                model.conurl = [data[@"conurl"] asNSString];
                model.read = NO;
                [_nodes addObject:model];
                [model release];
            }
        }
        else if ( [request.userInfo is:@"newNotice"] )
        {
            NSDictionary *data = [result objectForKey:@"data"];
            BHAnnouceModel *model = [[BHAnnouceModel alloc] init];
            model.annid = [data[@"id"] integerValue];
            model.ctime = [[data[@"ctime"] asNSString] doubleValue];
            model.title = [data[@"title"] asNSString];
            [_nodes addObject:model];
            [model release];
        }
	}
	else if ( request.failed )
	{
		//
	}
}

@end
