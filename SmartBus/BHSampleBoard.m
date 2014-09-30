//
//  BHSampleBoard.m
//  SmartBus
//
//  Created by launching on 13-9-26.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSampleBoard.h"

@interface BHSampleBoard ()
{
    BOOL isFirst;
}
- (void)setDefaults;
@end

#define kMenuImageTag   120120
#define kIconImageTag   120121
#define kTitleLabelTag  120122

@implementation BHSampleBoard

@synthesize navigationBar, beeView;

- (void)load
{
    [super load];
}

- (void)unload
{
    SAFE_RELEASE_SUBVIEW(navigationBar);
    SAFE_RELEASE_SUBVIEW(beeView);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        // 隐藏NavigationBar
		[self hideNavigationBarAnimated:NO];
        [self setDefaults];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		// 界面删除
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		// 界面重新布局
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
		// 将要显示
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


- (void)setDefaults
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // navigation bar
    navigationBar = [[BeeUIView alloc] initWithFrame:CGRectMake(0.f, y_offset, 320.f, 44.f)];
    navigationBar.backgroundColor = [UIColor whiteColor];
    navigationBar.layer.shadowColor = [UIColor flatDarkGrayColor].CGColor;
    navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    navigationBar.layer.shadowOpacity = 0.8;
    navigationBar.layer.shadowRadius = 1.5;
    [self.view addSubview:navigationBar];
    [self.view bringSubviewToFront:navigationBar];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0.f, 0.f, 48.f, 44.f);
    menuButton.backgroundColor = [UIColor clearColor];
    [menuButton addTarget:self action:@selector(handleMenu) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:menuButton];
    
    UIImageView *menuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 12.f, 20.f, 20.f)];
    menuImageView.tag = kMenuImageTag;
    [menuButton addSubview:menuImageView];
    [menuImageView release];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, 11.f, 22.f, 22.f)];
    iconImageView.tag = kIconImageTag;
    [menuButton addSubview:iconImageView];
    [iconImageView release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.f, 10.f, 200.f, 24.f)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.tag = kTitleLabelTag;
    titleLabel.font = BOLD_FONT_SIZE(16);
    [navigationBar addSubview:titleLabel];
    [titleLabel release];
    
    // content view
    beeView = [[BeeUIView alloc] initWithFrame:CGRectMake(0.f, 44.f+y_offset, 320.f, self.viewBound.size.height-44.f)];
    beeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:beeView];
    [self.view sendSubviewToBack:beeView];
}


#pragma mark - 
#pragma mark public methods

- (void)indicateIsFirstBoard:(BOOL)first image:(UIImage *)image title:(NSString *)title
{
    isFirst = first;
    
    BeeUIButton *menuButton = (BeeUIButton *)navigationBar.subviews[0];
    
    UIImage *menu = isFirst ? [UIImage imageNamed:@"nav_list.png"] : [UIImage imageNamed:@"nav_back.png"];
    CGRect rc = isFirst ? CGRectMake(0.f, 15.5f, 10.f, 13.f) : CGRectMake(0.f, 12.f, 20.f, 20.f);
    UIImageView *menuImageView = (UIImageView *)[menuButton viewWithTag:kMenuImageTag];
    menuImageView.frame = rc;
    [menuImageView setImage:menu];
    
    UIImageView *iconImageView = (UIImageView *)[menuButton viewWithTag:kIconImageTag];
    [iconImageView setImage:image];
    
    UILabel *titleLabel = (UILabel *)[navigationBar viewWithTag:kTitleLabelTag];
    titleLabel.text = title;
}

- (void)handleMenu
{
    if (isFirst) {
        [BHAPP toggleSlideMenu];
    } else {
        [self.stack popBoardAnimated:YES];
    }
}

- (void)toggleChrome:(BOOL)toggle
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rc = self.navigationBar.frame;
        rc.origin.y = toggle ? -(44.f+y_offset) : y_offset;
        self.navigationBar.frame = rc;
        
        rc = self.beeView.frame;
        rc.origin.y = toggle ? y_offset : (44.f+y_offset);
        rc.size.height = self.viewBound.size.height - (toggle ? y_offset : 44.f+y_offset);
        self.beeView.frame = rc;
        
    }];
}

@end
