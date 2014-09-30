//
//  BHPraiseHelper.m
//  SmartBus
//
//  Created by user on 13-10-30.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPraiseHelper.h"

@implementation BHPraiseHelper
@synthesize praiseCallBackBlock;

- (void) commintPraise:(NSString*)feedid andMid:(NSString *)mid withReturnCallBlock:(PraiseCallBackBlock)block;
{
    [praiseCallBackBlock release];
    praiseCallBackBlock = [block copy];
    self.HTTP_POST(BHDomain)
    .USER_INFO(@"praise")
    .PARAM(@"app", @"api")
    .PARAM(@"mod", @"WeiboStatuses")
    .PARAM(@"act", @"add_digg")
    .PARAM(@"feed_id", feedid)
    .PARAM(@"mid", mid)
    .TIMEOUT( 10 );
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    [super handleRequest:request];
    
	if ( request.succeed )
	{
        if ([request.userInfo isEqualToString:@"praise"])
        {
            NSDictionary *result = [request.responseString objectFromJSONString];
            NSString *code = result[@"message"][@"code"]; // 0.成功  1.失败  2.已赞

            if(self.praiseCallBackBlock){
                self.praiseCallBackBlock(code);
            }
        }
    }
	else if ( request.failed )
	{
		
	}
}

@end
