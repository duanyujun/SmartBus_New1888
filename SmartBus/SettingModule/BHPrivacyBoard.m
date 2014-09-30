//
//  BHPrivacyBoard.m
//  SmartBus
//
//  Created by launching on 13-12-13.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPrivacyBoard.h"
#import "BHSetupHelper.h"

@interface BHPrivacyBoard ()
{
    BHSetupHelper *_setupHelper;
}
- (NSArray *)privacies;
- (void)addPrivacyItem:(NSDictionary *)itemInfo atIndex:(NSInteger)idx;
- (void)reloadPrivacyStatus:(NSArray *)status;
@end

#define kItemHeight  55.f
#define kButtonBaseTag   67241

@implementation BHPrivacyBoard

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
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_setting.png"] title:@"隐私设置"];
        
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)]];
        bubbleImageView.frame = CGRectMake(10.f, 10.f, 300.f, 220.f);
        [self.beeView addSubview:bubbleImageView];
        [bubbleImageView release];
        
        NSArray *itemInfos = [self privacies];
        for (int i = 0; i < [itemInfos count]; i++) {
            [self addPrivacyItem:[itemInfos objectAtIndex:i] atIndex:i];
        }
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [_setupHelper getPrivacy];
    }
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.succeed )
	{
        if ( [request.userInfo is:@"getPrivacy"] )
        {
            [self reloadPrivacyStatus:_setupHelper.status];
        }
	}
}


#pragma mark -
#pragma mark private methods

- (NSArray *)privacies
{
    NSDictionary *info = nil;
    NSMutableArray *privacies = [NSMutableArray arrayWithCapacity:0];
    
    info = [NSDictionary dictionaryWithObject:@"其他人可以在动态列表中看到你" forKey:@"个人动态"];
    [privacies addObject:info];
    info = [NSDictionary dictionaryWithObject:@"其他人可以看到你的资料" forKey:@"个人资料"];
    [privacies addObject:info];
    info = [NSDictionary dictionaryWithObject:@"其他人可以看到你的签到信息" forKey:@"签到地图"];
    [privacies addObject:info];
    info = [NSDictionary dictionaryWithObject:@"其他人可以看到并进入你绑定的社交软件" forKey:@"社交绑定"];
    [privacies addObject:info];
    
    return privacies;
}

- (void)addPrivacyItem:(NSDictionary *)itemInfo atIndex:(NSInteger)idx
{
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(20.f, 10.f + idx * kItemHeight, 280.f, kItemHeight)];
    itemView.backgroundColor = [UIColor clearColor];
    itemView.tag = idx + kButtonBaseTag;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 8.f, 250.f, 24.f)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = FONT_SIZE(15);
    titleLabel.text = [[itemInfo allKeys] objectAtIndex:0];
    [itemView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 32.f, 250.f, 15.f)];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.font = FONT_SIZE(12);
    subtitleLabel.textColor = [UIColor lightGrayColor];
    subtitleLabel.text = [[itemInfo allValues] objectAtIndex:0];
    [itemView addSubview:subtitleLabel];
    [subtitleLabel release];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(255.f, 17.5, 20.f, 20.f);
    [button setBackgroundImage:[UIImage imageNamed:@"icon_grey.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"icon_red.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:button];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5.f, kItemHeight-1.f, 272.f, 1.f)];
    line.backgroundColor = [UIColor flatWhiteColor];
    [itemView addSubview:line];
    [line release];
    
    [self.beeView addSubview:itemView];
    [itemView release];
}

- (void)reloadPrivacyStatus:(NSArray *)status
{
    for (int i = 0; i < 4; i++)
    {
        UIView *itemView = [self.beeView viewWithTag:kButtonBaseTag + i];
        UIButton *button = (UIButton *)[itemView.subviews objectAtIndex:2];
        button.selected = [(NSString *)[status objectAtIndex:i] intValue];
    }
}


#pragma mark -
#pragma mark button events

- (void)buttonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    UIView *itemView = sender.superview;
    [_setupHelper setPrivacy:(itemView.tag - kButtonBaseTag + 1) value:sender.selected];
}

@end
