//
//  BHNewsDescBoard.m
//  SmartBus
//
//  Created by launching on 13-11-29.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHNewsDescBoard.h"
#import "BHNewsModel.h"
#import "BHNewsHelper.h"

@interface BHNewsDescBoard ()
{
    BHNewsModel *_news;
    BHNewsHelper *_newsHelper;
}
@end

@implementation BHNewsDescBoard

- (id)initWithNews:(id)news
{
    if ( self = [super init] )
    {
        _news = [(BHNewsModel *)news retain];
    }
    return self;
}

- (void)load
{
    _newsHelper = [[BHNewsHelper alloc] init];
    [_newsHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_newsHelper removeObserver:self];
    SAFE_RELEASE(_newsHelper);
    SAFE_RELEASE(_news);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_life.png"] title:@"南京生活"];
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [_newsHelper getNewsDetail:_news.nid];
	}
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        [self presentLoadingTips:@"加载中..."];
    }
    else if ( request.succeed )
	{
        [self dismissTips];
        
        if ( [request.userInfo is:@"getNewsDetail"] )
        {
            [self reloadDataSource:_newsHelper.article];
        }
	}
    else if ( request.failed )
    {
        [self dismissTips];
    }
}

@end
