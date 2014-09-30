//
//  BHGroupsHelper.m
//  SmartBus
//
//  Created by launching on 13-12-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHGroupsHelper.h"

@implementation BHGroupsHelper

@synthesize nodes = __nodes;

- (void)load
{
    __nodes = [[NSMutableArray alloc] initWithCapacity:0];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(__nodes);
    [super unload];
}

- (void)getMyGroupsAtPage:(NSInteger)page
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    self
    .HTTP_GET ( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"WeiboStatuses" )
    .PARAM( @"act", @"getAllFollowWeibaList" )
    .PARAM( @"mid", str_mid )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:str_mid method:@"getAllFollowWeibaList"] )
    .USER_INFO( @"getMyGroups" )
    .TIMEOUT( 10 );
}

- (void)getAllGroupsAtPage:(NSInteger)page
{
    self
    .HTTP_GET ( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"WeiboStatuses" )
    .PARAM( @"act", @"getTotalFollowWeibaList" )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:@"1" method:@"getTotalFollowWeibaList"] )
    .USER_INFO( @"getAllGroups" )
    .TIMEOUT( 10 );
}

- (void)toggleFav:(BOOL)toggle toGroup:(NSInteger)wid
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    NSString *method = toggle ? @"addFollowingWeiba" : @"delFollowingWeiba";
    
    self
    .HTTP_GET ( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"WeiboStatuses" )
    .PARAM( @"act", method )
    .PARAM( @"mid", str_mid )
    .PARAM( @"wid", [NSNumber numberWithInt:wid] )
    .PARAM( @"key", [BHUtil encrypt:str_mid method:method] )
    .USER_INFO( toggle ? @"addFavToGroup" : @"delFavToGroup" )
    .TIMEOUT( 10 );
}

- (void)getGroupDescById:(NSInteger)wid
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    self
    .HTTP_GET ( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"WeiboStatuses" )
    .PARAM( @"act", @"WeibaInfo" )
    .PARAM( @"mid", str_mid )
    .PARAM( @"wid", [NSString stringWithFormat:@"%d", wid] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", wid] method:@"WeibaInfo"] )
    .USER_INFO( @"getGroupDesc" )
    .TIMEOUT( 10 );
}

- (void)getTrendsById:(NSInteger)wid atPage:(NSInteger)page
{
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Info" )
    .PARAM( @"act", @"WeibaBBSList" )
    .PARAM( @"wid", [NSNumber numberWithInt:wid] )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", wid] method:@"WeibaBBSList"] )
    .USER_INFO( @"getTrends" )
    .TIMEOUT( 10 );
}

- (void)getFollowsById:(NSInteger)wid atPage:(NSInteger)page
{
    self
    .HTTP_GET ( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"WeiboStatuses" )
    .PARAM( @"act", @"WeibaFollowingUser" )
    .PARAM( @"wid", [NSString stringWithFormat:@"%d", wid] )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", wid] method:@"WeibaFollowingUser"] )
    .USER_INFO( @"getFollows" )
    .TIMEOUT( 10 );
}

- (void)searchGroupsInKeyword:(NSString *)key atPage:(NSInteger)page
{
    self
    .HTTP_GET ( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Info" )
    .PARAM( @"act", @"searchWeiba" )
    .PARAM( @"keywords", key )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:@"1" method:@"searchWeiba"] )
    .USER_INFO( @"searchGroups" )
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
        
        if ( [request.userInfo is:@"getMyGroups"] || [request.userInfo is:@"getAllGroups"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for (NSDictionary *datainfo in datas)
            {
                BHGroupModel *group = [[BHGroupModel alloc] init];
                group.gpid = [[datainfo objectForKey:@"weiba_id"] integerValue];
                group.gpname = [[datainfo objectForKey:@"weiba_name"] asNSString];
                group.cover = [[datainfo objectForKey:@"logopath"] asNSString];
                group.attnum = [[datainfo objectForKey:@"fnum"] integerValue];
                group.postnum = [[datainfo objectForKey:@"wnum"] integerValue];
                [self.nodes addObject:group];
                [group release];
            }
        }
        else if ( [request.userInfo is:@"addFavToGroup"] || [request.userInfo is:@"delFavToGroup"] )
        {
            // TODO:
        }
        else if ( [request.userInfo is:@"getGroupDesc"] )
        {
            NSDictionary *datainfo = [result objectForKey:@"data"];
            BHGroupModel *group = [[BHGroupModel alloc] init];
            group.gpid = [[datainfo objectForKey:@"weiba_id"] integerValue];
            group.gpname = [[datainfo objectForKey:@"weiba_name"] asNSString];
            group.cover = [[datainfo objectForKey:@"logoPath"] asNSString];
            group.attnum = [[datainfo objectForKey:@"follower_count"] integerValue];
            group.postnum = [[datainfo objectForKey:@"thread_count"] integerValue];
            group.intro = [[datainfo objectForKey:@"intro"] asNSString];
            group.notify = [[datainfo objectForKey:@"notify"] asNSString];
            group.focused = [[datainfo objectForKey:@"follow"] boolValue];
            [self.nodes addObject:group];
            [group release];
        }
        else if ( [request.userInfo is:@"getTrends"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for (NSDictionary *datainfo in datas)
            {
                BHTrendsModel *posts = [[BHTrendsModel alloc] init];
                posts.feedid = [[datainfo objectForKey:@"feed_id"] integerValue];
                posts.ctime = [datainfo objectForKey:@"ctime"];
                posts.title = [[datainfo objectForKey:@"title"] asNSString];
                posts.content = [[datainfo objectForKey:@"content"] asNSString];
                posts.address = [[datainfo objectForKey:@"location"] asNSString];
                posts.weiba = [[datainfo objectForKey:@"weiba"] asNSString];
                posts.cnum = [[[datainfo objectForKey:@"comm_num"] asNSString] integerValue];
                posts.dnum = [[[datainfo objectForKey:@"diggnum"] asNSString] integerValue];
                posts.digg = [[[datainfo objectForKey:@"is_digg"] asNSString] integerValue];
                posts.user.uid = [[[datainfo objectForKey:@"uid"] asNSString] integerValue];
                posts.user.uname = [[datainfo objectForKey:@"uname"] asNSString];
                posts.user.avator = [[datainfo objectForKey:@"avatar"] asNSString];
                posts.user.ugender = [[[datainfo objectForKey:@"gender"] asNSString] integerValue];
                posts.fromSelf = (posts.user.uid == [BHUserModel sharedInstance].uid);
                
                NSArray *conimgs = [[datainfo objectForKey:@"conimg"] asNSArray];
                for (NSString *conimg in conimgs) {
                    [posts addImage:conimg];
                }
                
                [self.nodes addObject:posts];
                [posts release];
            }
        }
        else if ( [request.userInfo is:@"getFollows"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for (NSDictionary *datainfo in datas)
            {
                BHUserModel *userModel = [[BHUserModel alloc] init];
                userModel.uid = [[[datainfo objectForKey:@"uid"] asNSString] integerValue];
                userModel.uname = [[datainfo objectForKey:@"uname"] asNSString];
                userModel.ugender = [[[datainfo objectForKey:@"gender"] asNSString] integerValue];
                userModel.avator = [[datainfo objectForKey:@"avatar"] asNSString];
                [self.nodes addObject:userModel];
                [userModel release];
            }
        }
        else if ( [request.userInfo is:@"searchGroups"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for (NSDictionary *datainfo in datas)
            {
                BHGroupModel *group = [[BHGroupModel alloc] init];
                group.gpid = [[datainfo objectForKey:@"weiba_id"] integerValue];
                group.gpname = [[datainfo objectForKey:@"weiba_name"] asNSString];
                group.cover = [[datainfo objectForKey:@"logopath"] asNSString];
                group.attnum = [[datainfo objectForKey:@"fnum"] integerValue];
                group.postnum = [[datainfo objectForKey:@"wnum"] integerValue];
                [self.nodes addObject:group];
                [group release];
            }
        }
	}
}

@end
