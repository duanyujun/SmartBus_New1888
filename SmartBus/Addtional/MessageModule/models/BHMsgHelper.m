//
//  BHMsgHelper.m
//  SmartBus
//
//  Created by launching on 13-12-9.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHMsgHelper.h"

@implementation BHMsgHelper

@synthesize nodes = _nodes;

- (void)load
{
    _nodes = [[NSMutableArray alloc] initWithCapacity:0];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(_nodes);
    [super unload];
}


#pragma mark -
#pragma mark public methods

- (void)getMessageListAtPage:(NSInteger)page
{
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Message" )
    .PARAM( @"act", @"MyMSGList" )
    .PARAM( @"mid", [NSNumber numberWithInt:[BHUserModel sharedInstance].uid] )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid] method:@"MyMSGList"] )
    .USER_INFO( @"getMessageList" )
    .TIMEOUT( 10 );
}

- (void)getMessageDetail:(NSInteger)msgid toUserId:(NSInteger)uid atPage:(NSInteger)page
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Message" )
    .PARAM( @"act", @"MessageDetailList" )
    .PARAM( @"list_id", msgid > 0 ? [NSNumber numberWithInt:msgid] : @"" )
    .PARAM( @"to_uid", [NSNumber numberWithInt:uid] )
    .PARAM( @"mid", str_mid )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:str_mid method:@"MessageDetailList"] )
    .USER_INFO( @"getMessageDetail" )
    .TIMEOUT( 10 );
}

- (void)postMessage:(BHMsgModel *)msg
{
    self
    .HTTP_POST( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Message" )
    .PARAM( @"act", @"postMessage" )
    .PARAM( @"from_uid", [NSNumber numberWithInt:msg.sender.uid] )
    .PARAM( @"to_uid", [NSNumber numberWithInt:msg.receiver.uid] )
    .PARAM( @"content", msg.content )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", msg.sender.uid] method:@"postMessage"] )
    .USER_INFO( @"postMessage" )
    .TIMEOUT( 20 );
}

- (void)removeMessage:(NSInteger)msgid
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Message" )
    .PARAM( @"act", @"delAllMessage" )
    .PARAM( @"list_id", [NSNumber numberWithInt:msgid] )
    .PARAM( @"mid", str_mid )
    .PARAM( @"key", [BHUtil encrypt:str_mid method:@"delAllMessage"] )
    .USER_INFO( @"deleteMessage" )
    .TIMEOUT( 10 );
}

- (void)getNewMessage
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Message" )
    .PARAM( @"act", @"getnewMessage" )
    .PARAM( @"mid", str_mid )
    .PARAM( @"key", [BHUtil encrypt:str_mid method:@"getnewMessage"] )
    .USER_INFO( @"getNewMessage" )
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
        
        if ( [request.userInfo is:@"getMessageList"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for (NSDictionary *data in datas)
            {
                BHMsgModel *msg = [[BHMsgModel alloc] init];
                msg.mstid = [[[data objectForKey:@"list_id"] asNSString] integerValue];
                msg.content = [[data objectForKey:@"last_message"] asNSString];
                msg.dtime = [[[data objectForKey:@"last_ctime"] asNSString] doubleValue];
                msg.sender.uid = [[[data objectForKey:@"last_message_from_uid"] asNSString] integerValue];
                msg.sender.uname = [[data objectForKey:@"last_message_from_uname"] asNSString];
                msg.receiver.uid = [[[data objectForKey:@"to_uid"] asNSString] integerValue];
                msg.receiver.uname = [[data objectForKey:@"to_name"] asNSString];
                msg.receiver.avator = [[data objectForKey:@"to_avatar"] asNSString];
                [self.nodes addObject:msg];
                [msg release];
            }
        }
        else if ( [request.userInfo is:@"getMessageDetail"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for (NSDictionary *data in datas)
            {
                BHMsgModel *msg = [[BHMsgModel alloc] init];
                msg.mstid = [[[data objectForKey:@"list_id"] asNSString] integerValue];
                msg.msgid = [[[data objectForKey:@"message_id"] asNSString] integerValue];
                msg.content = [[data objectForKey:@"content"] asNSString];
                msg.dtime = [[[data objectForKey:@"mtime"] asNSString] doubleValue];
                msg.sender.uid = [[[data objectForKey:@"from_uid"] asNSString] integerValue];
                msg.sender.uname = [[data objectForKey:@"uname"] asNSString];
                msg.sender.avator = [[data objectForKey:@"avatar"] asNSString];
                [self.nodes addObject:msg];
                [msg release];
            }
        }
        else if ( [request.userInfo is:@"postMessage"] )
        {
            //
        }
        else if ( [request.userInfo is:@"deleteMessage"] )
        {
            //
        }
        else if ( [request.userInfo is:@"getNewMessage"] )
        {
            NSDictionary *data = [result objectForKey:@"data"];
            self.newnum = [[data objectForKey:@"num"] intValue];
        }
	}
	else if ( request.failed )
	{
		NSLog(@"[ERROR]-%@-%@", request.userInfo, request.error);
	}
}

@end
