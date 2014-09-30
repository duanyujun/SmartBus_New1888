//
//  BHRouteDetail.m
//  SmartBus
//
//  Created by launching on 13-11-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHRouteDetail.h"
#import "BHBusHelper.h"

@interface BHRouteDetail ()
{
    LKRoute *_route;
    BHBusHelper *_busHelper;
    
    UILabel *routeNameLabel;
    UILabel *addtionalLabel;
    UILabel *directionLabel;
    UILabel *activeTimeLabel;
    UILabel *remarkLabel;
}
@end

@implementation BHRouteDetail

- (id)initWithRoute:(LKRoute *)route
{
    if ( self = [super init] ) {
        _route = [route retain];
    }
    return self;
}

- (void)load
{
    _busHelper = [[BHBusHelper alloc] init];
    [_busHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_busHelper removeObserver:self];
    [_busHelper release];
    SAFE_RELEASE(_route);
    [super unload];
}

- (void)handleMenu
{
    [_busHelper removeObserver:self];
    [_busHelper release];
    [super handleMenu];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_bus.png"] title:@"公交详情"];
        
        // 线路名
        routeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 12.f, 290.f, 30.f)];
        routeNameLabel.backgroundColor = [UIColor clearColor];
        routeNameLabel.font = BOLD_FONT_SIZE(16);
        [self.beeView addSubview:routeNameLabel];
        
        // 附加信息
        addtionalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 42.f, 290.f, 20.f)];
        addtionalLabel.backgroundColor = [UIColor clearColor];
        addtionalLabel.font = FONT_SIZE(13);
        addtionalLabel.textColor = [UIColor darkGrayColor];
        [self.beeView addSubview:addtionalLabel];
        
        // 起点终点
        directionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 62.f, 290.f, 20.f)];
        directionLabel.backgroundColor = [UIColor clearColor];
        directionLabel.font = FONT_SIZE(13);
        directionLabel.textColor = [UIColor darkGrayColor];
        [self.beeView addSubview:directionLabel];
        
        // 发车时间
        activeTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 82.f, 290.f, 20.f)];
        activeTimeLabel.backgroundColor = [UIColor clearColor];
        activeTimeLabel.font = FONT_SIZE(13);
        activeTimeLabel.textColor = [UIColor darkGrayColor];
        [self.beeView addSubview:activeTimeLabel];
        
        // 备注
        remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 102.f, 290.f, 20.f)];
        remarkLabel.backgroundColor = [UIColor clearColor];
        remarkLabel.font = FONT_SIZE(13);
        remarkLabel.textColor = [UIColor darkGrayColor];
        [self.beeView addSubview:remarkLabel];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        SAFE_RELEASE_SUBVIEW(routeNameLabel);
        SAFE_RELEASE_SUBVIEW(addtionalLabel);
        SAFE_RELEASE_SUBVIEW(directionLabel);
        SAFE_RELEASE_SUBVIEW(activeTimeLabel);
        SAFE_RELEASE_SUBVIEW(remarkLabel);
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [_busHelper getLineDetail:_route.line_id updown:_route.ud_type station:_route.st_appoint.st_id];
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.succeed )
	{
        if ( [request.userInfo is:@"getLineDetail"] )
        {
            if ( _busHelper.succeed )
            {
                NSDictionary *result = [request.responseString objectFromJSONString];
                NSDictionary *line = result[@"line"];
                
                routeNameLabel.text = line[@"line_name"];
                addtionalLabel.text = line[@"line_ticket"];
                directionLabel.text = [NSString stringWithFormat:@"%@ - %@", _route.st_start, _route.st_end];
                activeTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", _route.start_time, _route.end_time];
                remarkLabel.text = line[@"line_organ"];
            }
        }
	}
	else if ( request.failed )
	{
		//TODO:
	}
}

@end
