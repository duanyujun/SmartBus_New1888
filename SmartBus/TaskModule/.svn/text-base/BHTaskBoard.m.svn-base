//
//  BHTaskBoard.m
//  SmartBus
//
//  Created by launching on 13-9-30.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTaskBoard.h"

@interface BHTaskBoard ()

@end

@implementation BHTaskBoard

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:YES image:[UIImage imageNamed:@"nav_trends.png"] title:@"任务"];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
		// 数据加载
	}
	else if ( [signal is:BeeUIBoard.FREE_DATAS] )
	{
		// 数据释放
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
	}
	else if ( [signal is:BeeUIBoard.DID_APPEAR] )
	{
		// 已经显示
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
		// 将要隐藏
	}
	else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
	{
		// 已经隐藏
	}
}

@end
