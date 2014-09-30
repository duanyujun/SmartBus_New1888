//
//  BHTrendsHelper.m
//  SmartBus
//
//  Created by launching on 13-10-8.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTrendsHelper.h"
#import "BHCommentModel.h"

@interface BHTrendsHelper ()


@end
@implementation BHTrendsHelper

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

- (void)getUserPosts:(NSInteger)uid atPage:(NSInteger)page
{
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"WeiboStatuses" )
    .PARAM( @"act", @"user_timeline" )
    .PARAM( @"user_id", [NSNumber numberWithInt:uid] )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", uid] method:@"user_timeline"] )
    .USER_INFO( @"getUserPosts" )
    .TIMEOUT( 10 );
}

- (void)getFriendPosts:(NSInteger)mid atPage:(NSInteger)page
{
    self
    .HTTP_GET ( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"WeiboStatuses" )
    .PARAM( @"act", @"friends_timeline" )
    .PARAM( @"mid", [NSNumber numberWithInt:mid] )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", mid] method:@"friends_timeline"] )
    .USER_INFO( @"getFriendPosts" )
    .TIMEOUT( 10 );
}

- (void)getHotContentsAtPage:(NSInteger)page
{
    self
    .HTTP_GET ( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Home" )
    .PARAM( @"act", @"HotContentList" )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:@"1" method:@"HotContentList"] )
    .USER_INFO( @"getHotTrends" )
    .TIMEOUT( 10 );
}

- (void)getNewContentsAtPage:(NSInteger)page
{
    self
    .HTTP_GET ( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"WeiboStatuses" )
    .PARAM( @"act", @"newweibaList" )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:@"1" method:@"newweibaList"] )
    .USER_INFO( @"getNewTrends" )
    .TIMEOUT( 10 );
}

- (void)getWeibaList:(NSInteger)wid
{
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"Info" )
    .PARAM( @"act", @"WeibaBBSList" )
    .PARAM( @"id", [NSNumber numberWithInt:wid] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", wid] method:@"WeibaBBSList"] )
    .USER_INFO( @"bbslist" )
    .TIMEOUT( 10 );
}

- (void)addPraise:(NSInteger)fid operatorId:(NSInteger)oid
{
    self
    .HTTP_POST( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"WeiboStatuses" )
    .PARAM( @"act", @"add_digg" )
    .PARAM( @"feed_id", [NSNumber numberWithInt:fid] )
    .PARAM( @"mid", [NSNumber numberWithInt:oid] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", oid] method:@"add_digg"] )
    .USER_INFO( @"addDigg" )
    .TIMEOUT( 10 );
}

- (void)getPostInfo:(NSInteger)pid shower:(NSInteger)mid
{
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"WeiboStatuses" )
    .PARAM( @"act", @"getdetail" )
    .PARAM( @"id", [NSString stringWithFormat:@"%d", pid] )
    .PARAM( @"mid", [NSString stringWithFormat:@"%d", mid] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", pid] method:@"getdetail"] )
    .USER_INFO( @"getPostInfo" )
    .TIMEOUT( 10 );
}

- (void)publishPosts:(BHTrendsModel *)posts
{
    if ( !posts.hide )
    {
        self
        .HTTP_POST( BHDomain )
        .PARAM( @"app", @"api" )
        .PARAM( @"mod", @"WeiboStatuses" )
        .PARAM( @"act", @"doPost" )
        .PARAM( @"weiba_id", [NSNumber numberWithInt:posts.weibaId] )
        .PARAM( @"content", posts.content )
        .PARAM( @"mid", [NSNumber numberWithInt:posts.user.uid] )
        .PARAM( @"lat", [NSNumber numberWithDouble:posts.coor.latitude] )
        .PARAM( @"long", [NSNumber numberWithDouble:posts.coor.longitude] )
        .PARAM( @"location", posts.address )
        .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", posts.user.uid] method:@"doPost"] )
        .USER_INFO( @"doPost" )
        .TIMEOUT( 10 );
    }
    else
    {
        self
        .HTTP_POST( BHDomain )
        .PARAM( @"app", @"api" )
        .PARAM( @"mod", @"WeiboStatuses" )
        .PARAM( @"act", @"doPost" )
        .PARAM( @"weiba_id", [NSNumber numberWithInt:posts.weibaId] )
        .PARAM( @"content", posts.content )
        .PARAM( @"mid", [NSNumber numberWithInt:posts.user.uid] )
        .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", posts.user.uid] method:@"doPost"] )
        .USER_INFO( @"doPost" )
        .TIMEOUT( 10 );
    }
}

- (void)uploadImages:(NSArray *)images withGroupId:(NSInteger)gid
{
    for ( UIImage *image in images )

    
//    for (int i = 0 ; i < images.count; i++)
    {
//<<<<<<< .mine
//        UIImage *image = [images objectAtIndex:i];
////        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 50.f*i, 50.f, 50.f)];
////        [imgView setImage:image];
////        [[UIApplication sharedApplication].keyWindow addSubview:imgView];
////        [imgView release];        
////        self
////        .HTTP_POST ( BHDomain )
////        .PARAM( @"app", @"api" )
////        .PARAM( @"mod", @"WeiboStatuses" )
////        .PARAM( @"act", @"upload" )
////        .PARAM( @"wid", [NSNumber numberWithInt:gid] )
////        .PARAM( @"mid", [NSNumber numberWithInt:[BHUserModel sharedInstance].uid] )
////        .FILE( @"file", UIImageJPEGRepresentation(image, 0.5) )
////        .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid] method:@"upload"] )
////        .USER_INFO( @"uploadImage" )
////        .TIMEOUT( 40 );
//        
//        ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:BHDomain]];
//        [request setUploadProgressDelegate:self];
//        [request setDelegate:self];
//        [request setTimeOutSeconds:40];
//        [request setRequestMethod:@"POST"];
//        [request setShowAccurateProgress:YES];
//        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
//        [request setPostValue:@"api" forKey:@"app"];
//        [request setPostValue:@"WeiboStatuses" forKey:@"mod"];
//        [request setPostValue:@"upload" forKey:@"act"];
//        [request setPostValue:[NSNumber numberWithInt:gid] forKey:@"wid"];
//        [request setPostValue:[NSNumber numberWithInt:[BHUserModel sharedInstance].uid] forKey:@"mid"];
//        [request setFile:UIImageJPEGRepresentation(image, 0.5) withFileName:@"photo.png" andContentType:@"video/mpeg4" forKey:@"file"];
//        [request setShouldContinueWhenAppEntersBackground:YES];
//        [request setDidFinishSelector:@selector(uploadFinished:)];
//        [request startAsynchronous];
//=======
        NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
        
        self
        .HTTP_POST ( BHDomain )
        .PARAM( @"app", @"api" )
        .PARAM( @"mod", @"WeiboStatuses" )
        .PARAM( @"act", @"upload" )
        .PARAM( @"wid", [NSNumber numberWithInt:gid] )
        .PARAM( @"mid", [NSNumber numberWithInt:[BHUserModel sharedInstance].uid] )
        .FILE( [NSString stringWithFormat:@"image%f.PNG", [[NSDate date] timeIntervalSince1970]], imgData )
        .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid] method:@"upload"] )
        .USER_INFO( @"uploadImage" )
        .TIMEOUT( 40 );
//>>>>>>> .r439
    }
}

- (void)pushComment:(NSString *)comment inRowId:(NSInteger)rid atUser:(NSInteger)uid meid:(NSInteger)mid
{
    self
    .HTTP_POST ( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"WeiboStatuses" )
    .PARAM( @"act", @"comment" )
    .PARAM( @"app_name", @"weiba" )
    .PARAM( @"row_id", [NSNumber numberWithInt:rid] )
    .PARAM( @"content", comment )
    .PARAM( @"uid", [NSNumber numberWithInt:uid] )
    .PARAM( @"mid", [NSNumber numberWithInt:mid] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", rid] method:@"comment"] )
    .USER_INFO( @"pushComment" )
    .TIMEOUT( 20 );
}

- (void)relayComment:(NSString *)comment withTargetComment:(BHTrendsModel *)posts
{
    if ( !posts.hide )
    {
        self
        .HTTP_GET( BHDomain )
        .PARAM( @"app", @"api" )
        .PARAM( @"mod", @"WeiboStatuses" )
        .PARAM( @"act", @"WeibaRelay" )
        .PARAM( @"feed_id", [NSNumber numberWithInt:posts.feedid])
        .PARAM( @"append", comment )
        .PARAM( @"wid",[NSNumber numberWithInt:posts.weibaId])
        .PARAM( @"uname",posts.weiba)
        .PARAM( @"mid", [NSNumber numberWithInt:posts.user.uid] )
        .PARAM( @"lat", [NSNumber numberWithDouble:posts.coor.latitude] )
        .PARAM( @"long", [NSNumber numberWithDouble:posts.coor.longitude] )
        .PARAM( @"location", posts.address )
        .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", posts.user.uid] method:@"WeibaRelay"] )
        .USER_INFO( @"relayComment" )
        .TIMEOUT( 10 );
    }
    else
    {
        self
        .HTTP_GET( BHDomain )
        .PARAM( @"app", @"api" )
        .PARAM( @"mod", @"WeiboStatuses" )
        .PARAM( @"act", @"WeibaRelay" )
        .PARAM( @"feed_id", [NSNumber numberWithInt:posts.feedid])
        .PARAM( @"append", comment )
        .PARAM( @"wid",[NSNumber numberWithInt:posts.weibaId])
        .PARAM( @"uname",posts.weiba)           
        .PARAM( @"mid", [NSNumber numberWithInt:posts.user.uid] )
        .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", posts.user.uid] method:@"WeibaRelay"] )
        .USER_INFO( @"relayComment" )
        .TIMEOUT( 10 );
    }
}
- (void)getUserComments:(NSInteger)uid atPage:(NSInteger)page
{
    //
}

- (void)getWeiboComments:(NSInteger)wid atPage:(NSInteger)page
{
    self
    .HTTP_GET ( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"WeiboStatuses" )
    .PARAM( @"act", @"comments" )
    .PARAM( @"id", [NSNumber numberWithInt:wid] )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", wid] method:@"comments"] )
    .USER_INFO( @"weiboComments" )
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
            [self presentMessageTips:result[@"message"][@"text"]];
            //NSLog(@"[EROOR]%@_%@", request.userInfo, result[@"message"][@"text"]);
            self.succeed = NO;
            return;
        }
        else
        {
            self.succeed = YES;
        }
        
        if ( [request.userInfo is:@"getUserPosts"] ||
                 [request.userInfo is:@"getFriendPosts"] ||
                 [request.userInfo is:@"getHotTrends"] ||
                 [request.userInfo is:@"getNewTrends"] ||
                 [request.userInfo is:@"bbslist"])
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for (NSDictionary *data in datas)
            {
                BHTrendsModel *posts = [[BHTrendsModel alloc] init];
                posts.feedid = [[data objectForKey:@"feed_id"] integerValue];
                posts.ctime = [[data objectForKey:@"ctime"] asNSString];
                posts.title = [[data objectForKey:@"title"] asNSString];
                posts.content = [[data objectForKey:@"content"] asNSString];
                posts.address = [[data objectForKey:@"location"] asNSString];
                posts.weiba = [[data objectForKey:@"weiba"] asNSString];
                posts.cnum = [[[data objectForKey:@"comm_num"] asNSString] integerValue];
                posts.dnum = [[[data objectForKey:@"diggnum"] asNSString] integerValue];
                posts.digg = [[[data objectForKey:@"is_digg"] asNSString] integerValue];
                posts.user.uid = [[[data objectForKey:@"uid"] asNSString] integerValue];
                posts.user.uname = [[data objectForKey:@"uname"] asNSString];
                posts.user.avator = [[data objectForKey:@"avatar"] asNSString];
                posts.user.ugender = [[[data objectForKey:@"gender"] asNSString] integerValue];
                posts.fromSelf = (posts.user.uid == [BHUserModel sharedInstance].uid);
                
                NSArray *conimgs = [[data objectForKey:@"conimg"] asNSArray];
                for (NSString *conimg in conimgs) {
                    [posts addImage:conimg];
                }
                
                [self.nodes addObject:posts];
                [posts release];
            }
        }
        else if ( [request.userInfo is:@"getPostInfo"] )
        {
            NSDictionary *data = [result objectForKey:@"data"];
            BHTrendsModel *posts = [[BHTrendsModel alloc] init];
            posts.feedid = [[data objectForKey:@"feed_id"] integerValue];
            posts.ctime = [[data objectForKey:@"ctime"] asNSString];
            posts.title = [[data objectForKey:@"title"] asNSString];
            posts.content = [[data objectForKey:@"content"] asNSString];
            posts.address = [[data objectForKey:@"location"] asNSString];
            posts.weibaId = [[[data objectForKey:@"wid"] asNSString] integerValue];
            posts.weiba = [[data objectForKey:@"wname"] asNSString];
            posts.cnum = [[[data objectForKey:@"comm_num"] asNSString] integerValue];
            posts.dnum = [[[data objectForKey:@"diggnum"] asNSString] integerValue];
            posts.digg = [[[data objectForKey:@"is_digg"] asNSString] integerValue];
            posts.user.uid = [[[data objectForKey:@"uid"] asNSString] integerValue];
            posts.user.uname = [[data objectForKey:@"uname"] asNSString];
            posts.user.avator = [[data objectForKey:@"avatar"] asNSString];
            posts.user.ugender = [[[data objectForKey:@"gender"] asNSString] integerValue];
            posts.user.birth = [[data objectForKey:@"birth"] asNSString];
            posts.fromSelf = (posts.user.uid == [BHUserModel sharedInstance].uid);
            
            NSArray *conimgs = [[data objectForKey:@"conimg"] asNSArray];
            for (NSString *conimg in conimgs) {
                [posts addImage:conimg];
            }
            
            [self.nodes addObject:posts];
            [posts release];
        }
        else if ( [request.userInfo is:@"weiboComments"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [[result objectForKey:@"data"] asNSArray];
            for (NSDictionary *data in datas)
            {
                BHCommentModel *comment = [[BHCommentModel alloc] init];
                comment.cid = [[data objectForKey:@"cid"] integerValue];
                comment.content = [[data objectForKey:@"content"] asNSString];
                comment.ctime = [[data objectForKey:@"ctime"] asNSString];
                comment.user.uname = [[data objectForKey:@"uname"] asNSString];
                comment.user.ugender = [[[data objectForKey:@"gender"] asNSString] integerValue];
                comment.user.avator = [[data objectForKey:@"avatar"] asNSString];
                [self.nodes addObject:comment];
                [comment release];
            }
        }
        else if ( [request.userInfo is:@"pushComment"] )
        {
            // TODO:
        }
        else if ( [request.userInfo is:@"addDigg"] )
        {
            // TODO:
        }
		else if ( [request.userInfo is:@"doPost"] )
        {
            self.postid = [result[@"data"] integerValue];
        }
        else if ( [request.userInfo is:@"uploadImage"] )
        {
            // TODO:
        }
        else if ( [request.userInfo is:@"relayComment"] )
        {
    
        }
	}
}




@end
