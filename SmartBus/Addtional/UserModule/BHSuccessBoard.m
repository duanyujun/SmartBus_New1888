//
//  BHSuccessBoard.m
//  SmartBus
//
//  Created by jstv on 13-10-24.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSuccessBoard.h"
#import "BHModifyUserBoard.h"

@interface BHSuccessBoard ()

- (void)drawSuccessFrame;

@end

@implementation BHSuccessBoard

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_profile.png"] title:@"注册"];
        [self drawSuccessFrame];
	}
}

ON_SIGNAL2( BeeUIButton , signal )
{
    if ( [signal is:@"updateInfos"] )
    {
        BHModifyUserBoard *board = [BHModifyUserBoard board];
        board.registed = YES;
        [self.stack pushBoard:board animated:YES];
    }
    else
    {
        [self handleMenu];
    }
}

- (void)handleMenu
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)drawSuccessFrame
{
    BeeUILabel *textLabel = [[BeeUILabel alloc] initWithFrame:CGRectMake(10.f, 20.f, 300.f, 30.f)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = BOLD_FONT_SIZE(18);
    textLabel.textColor = [UIColor flatBlackColor];
    textLabel.text = @"恭喜！您已注册成功";
    [self.beeView addSubview:textLabel];
    [textLabel release];
    
    BeeUIButton *updateButton = [[BeeUIButton alloc] initWithFrame:CGRectMake(10.f, 70.f, 300.f, 44.f)];
    updateButton.title = @"完善资料";
    updateButton.layer.cornerRadius = 4.f;
    updateButton.layer.masksToBounds = YES;
    updateButton.backgroundColor = [UIColor flatDarkRedColor];
    [updateButton addSignal:@"updateInfos" forControlEvents:UIControlEventTouchUpInside];
    [self.beeView addSubview:updateButton];
    
    BeeUIButton *noButton = [[BeeUIButton alloc] initWithFrame:CGRectMake(10.f, 130.f, 300.f, 44.f)];
    noButton.title = @"暂不完善资料";
    noButton.layer.cornerRadius = 4.f;
    noButton.layer.masksToBounds = YES;
    noButton.backgroundColor = [UIColor flatDarkGrayColor];
    [noButton addSignal:@"noUpdate" forControlEvents:UIControlEventTouchUpInside];
    [self.beeView addSubview:noButton];
}

@end
