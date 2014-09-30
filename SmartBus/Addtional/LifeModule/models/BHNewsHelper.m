//
//  BHNewsHelper.m
//  SmartBus
//
//  Created by launching on 13-11-20.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHNewsHelper.h"
#import "SETextHelper.h"
#import "BHNewsModel.h"

@implementation BHNewsHelper

@synthesize menus = _menus;
@synthesize tops = _tops;
@synthesize nodes = _nodes;
@synthesize article = _article;

- (void)load
{
    self.menus = [NSMutableArray arrayWithCapacity:0];
    self.tops = [NSMutableArray arrayWithCapacity:0];
    self.nodes = [NSMutableArray arrayWithCapacity:0];
    _article = [[BHArticleModel alloc] init];
    self.succeed = YES;
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(_menus);
    SAFE_RELEASE(_tops);
    SAFE_RELEASE(_nodes);
    SAFE_RELEASE(_article);
    [super unload];
}

- (void)getNewsCategory
{
    self.
    HTTP_GET( [NSString stringWithFormat:@"%@News", SMNJDoamin] )
    .USER_INFO( @"getCategory" )
    .TIMEOUT( 10 );
}

- (void)getNewsTops:(NSInteger)wid
{
    self
    .HTTP_GET( [NSString stringWithFormat:@"%@News", SMNJDoamin] )
    .PARAM( @"ColumnID", [NSString stringWithFormat:@"%d", wid] )
    .USER_INFO( @"getNewsTops" )
    .TIMEOUT( 10 );
}

- (void)getNews:(NSInteger)wid atPage:(NSInteger)page
{
    self
    .HTTP_GET( [NSString stringWithFormat:@"%@News", SMNJDoamin] )
    .PARAM( @"NewsType", [NSString stringWithFormat:@"%d", wid] )
    .PARAM( @"PageIndex", [NSNumber numberWithInt:page] )
    .PARAM( @"PageSize", [NSNumber numberWithInt:kPageSize] )
    .USER_INFO( @"getNews" )
    .TIMEOUT( 10 );
}

- (void)getOnSitesAtPage:(NSInteger)page
{
    NSString *urlString = [NSString stringWithFormat:@"%@Commends", JNDISCLOSE_HOST];
    
    self
    .HTTP_POST( urlString )
    .PARAM( @"pageIndex", [NSNumber numberWithInt:page] )
    .PARAM( @"pageSize", [NSNumber numberWithInt:kPageSize] )
    .USER_INFO( @"getOnSites" )
    .TIMEOUT( 20 );
}

- (void)getNewsDetail:(NSInteger)nid
{
    self
    .HTTP_GET( [NSString stringWithFormat:@"%@News", SMNJDoamin] )
    .PARAM( @"id", [NSString stringWithFormat:@"%d", nid] )
    .USER_INFO( @"getNewsDetail" )
    .TIMEOUT( 10 );
}

- (void)getOnSiteDetail:(NSInteger)sid
{
    NSString *urlString = [NSString stringWithFormat:@"%@FileInfo", JNDISCLOSE_HOST];
    
    self
    .HTTP_POST( urlString )
    .PARAM( @"fid", [NSNumber numberWithInt:sid] )
    .USER_INFO( @"getOnSiteDetail" )
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
        
        if ( ![request.userInfo is:@"getOnSites"] || ![request.userInfo is:@"getOnSiteDetail"] )
        {
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
        }
        else
        {
            self.succeed = YES;
        }
        
        if ( [request.userInfo is:@"getCategory"] )
        {
            [self.menus removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"Data"];
            for (NSDictionary *data in datas)
            {
                BHMenuModel *menu = [[BHMenuModel alloc] init];
                menu.mid = [[data objectForKey:@"ColumnID"] intValue];
                menu.name = [data objectForKey:@"ColumnName"];
                [self.menus addObject:menu];
                [menu release];
            }
        }
        else if ( [request.userInfo is:@"getNewsTops"] )
        {
            [self.tops removeAllObjects];
            
            NSArray *datas = [[result objectForKey:@"Data"] asNSArray];
            for (NSDictionary *data in datas)
            {
                BHNewsModel *news = [[BHNewsModel alloc] init];
                news.nid = [[data objectForKey:@"NewsID"] integerValue];
                news.title = [[data objectForKey:@"Title"] asNSString];
                news.cover = [[data objectForKey:@"BigThumb"] asNSString];
                [self.tops addObject:news];
                [news release];
            }
        }
        else if ( [request.userInfo is:@"getNews"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [[result objectForKey:@"Data"] asNSArray];
            for (NSDictionary *data in datas)
            {
                BHNewsModel *news = [[BHNewsModel alloc] init];
                news.nid = [[data objectForKey:@"NewsID"] integerValue];
                news.title = [[data objectForKey:@"Title"] asNSString];
                news.summary = [[data objectForKey:@"SmallTitle"] asNSString];
                news.ctime = [[data objectForKey:@"CreateTime"] asNSString];
                news.cover = [[data objectForKey:@"SmallThumb"] asNSString];
                [self.nodes addObject:news];
                [news release];
            }
        }
        else if ( [request.userInfo is:@"getOnSites"] )
        {
            [self.nodes removeAllObjects];
            
            BHOnSiteModel *lastSite = [self.nodes lastObject];
            
            NSDictionary *paramz = [result objectForKey:@"paramz"];
            NSArray *files = [paramz objectForKey:@"files"];
            for (NSDictionary *file in files)
            {
                // 把数据最后一条记录的ID与当页所有记录的ID对比，如果一样去重
                NSInteger disId = [[file objectForKey:@"id"] integerValue];
                if ( lastSite.disId != disId )
                {
                    BHOnSiteModel *site = [[BHOnSiteModel alloc] init];
                    site.disId = disId;
                    site.author = [file objectForKey:@"author"];
                    site.title = [file objectForKey:@"title"];
                    site.remark = [file objectForKey:@"summary"];
                    site.date = [file objectForKey:@"date"];
                    site.level = [[file objectForKey:@"level"] integerValue];
                    site.ugroup = [file objectForKey:@"ugroup"];
                    site.ucity = [file objectForKey:@"ucity"];
                    
                    NSArray *attachs = [file objectForKey:@"attachs"];
                    for (NSDictionary *att in attachs)
                    {
                        BHAttachModel *attach = [[BHAttachModel alloc] init];
                        attach.category = [att objectForKey:@"category"];
                        attach.link = [NSString stringWithFormat:@"%@%@", JNDISCLOSE_IMAGE, [att objectForKey:@"logo"]];
                        [site addAttach:attach];
                        [attach release];
                    }
                    
                    [self.nodes addObject:site];
                    [site release];
                }
            }
        }
        else if ( [request.userInfo is:@"getNewsDetail"] )
        {
            NSDictionary *data = [result objectForKey:@"Data"];
            
            _article.base.created = [data objectForKey:@"CreateTime"];
            _article.base.subject = [data objectForKey:@"Title"];
            
            NSArray *contents = [data objectForKey:@"Description"];
            for (NSDictionary *content in contents)
            {
                NSString *type = [content objectForKey:@"category"];
                if ( [type is:@"txt"] )
                {
                    BHAttachModel *attach = [[BHAttachModel alloc] init];
                    attach.category = @"txt";
                    attach.text = [NSString stringWithFormat:@"      %@", [content objectForKey:@"text"]];
                    NSAttributedString *attributedString = [[SETextHelper sharedInstance] attributedStringWithText:attach.text];
                    CGRect rect = [SETextView frameRectWithAttributtedString:attributedString
                                                              constraintSize:CGSizeMake(300., CGFLOAT_MAX)
                                                                 lineSpacing:8.0
                                                                        font:[UIFont systemFontOfSize:15]];
                    attach.size = rect.size;
                    [_article addAttach:attach];
                    [attach release];
                }
                else
                {
                    BHAttachModel *attach = [[BHAttachModel alloc] init];
                    attach.category = @"img";
                    attach.link = [content objectForKey:@"info"];
                    attach.play = [content objectForKey:@"info"];
                    attach.size = CGSizeMake(300.f, 225.f);
                    [_article addAttach:attach];
                    [attach release];
                }
            }
        }
        else if ( [request.userInfo is:@"getOnSiteDetail"] )
        {
            NSDictionary *paramz = [result objectForKey:@"paramz"];
            
            NSDictionary *file = [paramz objectForKey:@"file"];
            
            _article.base.aid = [[file objectForKey:@"id"] integerValue];
            _article.base.subject = [file objectForKey:@"title"];
            _article.base.origin = [file objectForKey:@"author"];
            _article.base.created = [file objectForKey:@"date"];
            
            NSArray *attachs = [paramz objectForKey:@"attachs"];
            for (NSDictionary *attach in attachs)
            {
                BHAttachModel *attachModel = [[BHAttachModel alloc] init];
                NSString *category = [attach objectForKey:@"category"];
                attachModel.category = [category isEqualToString:@"img"] ? @"image" : category;
                attachModel.link = [NSString stringWithFormat:@"%@%@", JNDISCLOSE_IMAGE, [attach objectForKey:@"logo"]];
                attachModel.play = [NSString stringWithFormat:@"%@%@", JNDISCLOSE_IMAGE, [attach objectForKey:@"play"]];
                attachModel.size = CGSizeMake(300.f, 225.f);
                [_article addAttach:attachModel];
                [attachModel release];
            }
            
            BHAttachModel *attachModel = [[BHAttachModel alloc] init];
            attachModel.category = @"txt";
            attachModel.text = [NSString stringWithFormat:@"      %@", [[file objectForKey:@"remark"] trim]];
            NSAttributedString *attributedString = [[SETextHelper sharedInstance] attributedStringWithText:attachModel.text];
            CGRect rect = [SETextView frameRectWithAttributtedString:attributedString
                                                      constraintSize:CGSizeMake(300., CGFLOAT_MAX)
                                                         lineSpacing:8.0
                                                                font:[UIFont systemFontOfSize:15]];
            attachModel.size = rect.size;
            [_article addAttach:attachModel];
            [attachModel release];
        }
	}
	else if ( request.failed )
	{
		//
	}
}

@end
