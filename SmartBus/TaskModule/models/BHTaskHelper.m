//
//  BHTaskHelper.m
//  SmartBus
//
//  Created by launching on 13-12-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTaskHelper.h"
#import "NSDate+Helper.h"

@implementation BHTaskHelper

@synthesize succeed, taskReg;

- (void)load
{
    taskReg = [[BHTaskRegModel alloc] init];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(taskReg);
    [super unload];
}

- (void)sigInTask
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Home" )
    .PARAM( @"act", @"check_in" )
    .PARAM( @"mid", str_mid )
    .PARAM( @"key", [BHUtil encrypt:str_mid method:@"check_in"] )
    .USER_INFO( @"taskReg" )
    .TIMEOUT( 10 );
}

- (void)getCheckList
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Home" )
    .PARAM( @"act", @"monthCheckList" )
    .PARAM( @"mid", str_mid )
    .PARAM( @"key", [BHUtil encrypt:str_mid method:@"monthCheckList"] )
    .USER_INFO( @"getCheckList" )
    .TIMEOUT( 10 );
}

- (void)postStatus:(NSString *)status
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    self
    .HTTP_POST( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Home" )
    .PARAM( @"act", @"putWeibo" )
    .PARAM( @"mid", str_mid )
    .PARAM( @"content", status )
    .PARAM( @"key", [BHUtil encrypt:str_mid method:@"putWeibo"] )
    .USER_INFO( @"postStatus" )
    .TIMEOUT( 20 );
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
        
		if ( [request.userInfo is:@"taskReg"] )
        {
            NSDictionary *datainfo = [result objectForKey:@"data"];
            self.coin = [[datainfo objectForKey:@"sorc"] integerValue];
        }
        else if ( [request.userInfo is:@"getCheckList"] )
        {
            NSDictionary *datainfo = [result objectForKey:@"data"];
            taskReg.publish = [[datainfo objectForKey:@"today"] boolValue];
            self.con_num = [[datainfo objectForKey:@"con_num"] integerValue];
            NSArray *ctimes = [[datainfo objectForKey:@"ctime"] asNSArray];
            for (NSString *ctime in ctimes)
            {
                double interval = [ctime doubleValue];
                NSString *date = [NSDate stringFromTimeInterval:interval withFormat:@"dd"];
                [taskReg.dates addObject:date];
            }
        }
        else if ( [request.userInfo is:@"postStatus"] )
        {
            //
        }
	}
}

@end
