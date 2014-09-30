//
//  BHTipsBoard.m
//  SmartBus
//
//  Created by launching on 14-1-10.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHTipsBoard.h"
#import "BHSetupHelper.h"

@interface BHTipsBoard ()
{
    BHSetupHelper *_setupHelper;
    UITextView *_textView;
}
@end

@implementation BHTipsBoard

@synthesize tipsMode = _tipsMode;

- (void)load
{
    _setupHelper = [[BHSetupHelper alloc] init];
    [_setupHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_setupHelper removeObserver:self];
    SAFE_RELEASE(_setupHelper);
    [super unload];
}

- (void)handleMenu
{
    [_setupHelper removeObserver:self];
    SAFE_RELEASE(_setupHelper);
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        NSString *title = self.tipsMode == TIPS_MODE_HELP ? @"用户帮助" : @"兑换说明";
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_setting.png"] title:title];
        
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)]];
        bubbleImageView.frame = CGRectMake(10.f, 10.f, 300.f, self.beeView.frame.size.height-30.f);
        [self.beeView addSubview:bubbleImageView];
        [bubbleImageView release];
        
        _textView = [[BeeUITextView alloc] initWithFrame:CGRectMake(10.f, 10.f, 300.f, self.beeView.frame.size.height-30.f)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.font = FONT_SIZE(15);
        _textView.editable = NO;
        _textView.textColor = [UIColor darkGrayColor];
        [self.beeView addSubview:_textView];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        SAFE_RELEASE_SUBVIEW(_textView);
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        // 用户帮助的TYPE为2,兑换说明的TYPE为3
        NSInteger type = self.tipsMode == TIPS_MODE_HELP ? 2 : 3;
        [_setupHelper getInfosByType:type];
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        [self presentLoadingTips:@"正在获取..."];
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        
		if ( [request.userInfo is:@"getInfos"] )
        {
            _textView.text = _setupHelper.tips;
        }
	}
    else if ( request.failed )
    {
        [self dismissTips];
    }
}

@end
