//
//  BHAnnDescBoard.m
//  SmartBus
//
//  Created by launching on 13-12-10.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAnnDescBoard.h"
#import "BHAnnouceModel.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Helper.h"

@interface BHAnnDescBoard ()
{
    BeeUIWebView *_webView;
    BHAnnouceModel *_annouce;
}
@end

@implementation BHAnnDescBoard

- (void)unload
{
    SAFE_RELEASE(_annouce);
    [super unload];
}

- (id)initWithAnnouce:(BHAnnouceModel *)annouce
{
    if ( self = [super init] )
    {
        _annouce = [annouce retain];
    }
    return self;
}

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_notice.png"] title:@"公告"];
        
        _webView = [[BeeUIWebView alloc] initWithFrame:CGRectZero];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        [self.beeView addSubview:_webView];
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        _webView.frame = self.beeView.bounds;
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        _webView.url = _annouce.conurl;
    }
}

ON_SIGNAL2( BeeUIWebView, signal )
{
    if ( [signal is:BeeUIWebView.DID_LOAD_FINISH] )
    {
        //TODO:
    }
}

@end
