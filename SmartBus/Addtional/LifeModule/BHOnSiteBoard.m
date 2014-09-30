//
//  BHOnSiteBoard.m
//  SmartBus
//
//  Created by launching on 13-11-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHOnSiteBoard.h"
#import "BHArticleModel.h"
#import "BHNewsHelper.h"

@interface BHOnSiteBoard ()
{
    NSInteger fileId;
    BHNewsHelper *_newsHelper;
}
@end

@implementation BHOnSiteBoard

- (id)initWithFileId:(NSInteger)fid
{
    if (self = [super init]) {
        fileId = fid;
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
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [_newsHelper getOnSiteDetail:fileId];
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
        
        if ( [request.userInfo is:@"getOnSiteDetail"] )
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
