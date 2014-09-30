//
//  BHLoginBoard.m
//  SmartBus
//
//  Created by jstv on 13-10-18.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHLoginBoard.h"

@interface BHLoginBoard ()
{
    BeeUIImageView *homeImageView;
    float frameDY;
}

- (void)drawImageView:(float)dy imageName:(NSString *)imageName;

@end

@implementation BHLoginBoard

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"icon_profile.png"] title:@"登陆"];
        
        [self drawImageView:frameDY imageName:@"avator.png"];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(homeImageView);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        frameDY = 10.f;
	}
	else if ( [signal is:BeeUIBoard.FREE_DATAS] )
	{
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
	}
}

- (void)drawImageView:(float)dy imageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    homeImageView = [[BeeUIImageView alloc] initWithFrame:CGRectMake((320.f - image.size.width / 2) / 2, dy, image.size.width / 2, image.size.height / 2)];
    [self.view addSubview:homeImageView];
    
    frameDY += homeImageView.frame.size.height;
}

- (void)drawLoginView:(float)dy
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10.f, dy, 300.f, 90.f)];
    view.backgroundImage = [[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
//    BeeUILabel *telPLabel = [[BeeUILabel alloc] initWithFrame:CGRectMake(5.f, dy + , <#CGFloat width#>, <#CGFloat height#>)];
    
    [self.view addSubview:view];
    
    [view release];
}

@end
