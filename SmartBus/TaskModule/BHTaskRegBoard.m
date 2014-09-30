//
//  BHTaskRegBoard.m
//  SmartBus
//
//  Created by launching on 13-12-13.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTaskRegBoard.h"
#import "BHPostMoodBoard.h"
#import "BHRegHeaderView.h"
#import "BHTaskHelper.h"
#import "BHMoodVIew.h"

@interface BHTaskRegBoard ()
{
    BOOL hasRegist;
    BOOL firstPub;
    BOOL showRegTips;
    BHRegHeaderView *headerView;
    BHTaskHelper *_taskHelper;
}
@end

@implementation BHTaskRegBoard

- (void)load
{
    _taskHelper = [[BHTaskHelper alloc] init];
    [_taskHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_taskHelper removeObserver:self];
    SAFE_RELEASE(_taskHelper);
    [super unload];
}

- (void)handleMenu
{
    [_taskHelper removeObserver:self];
    SAFE_RELEASE(_taskHelper);
    [super handleMenu];
}


ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_home.png"] title:@"打卡"];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(headerView);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        self.egoTableView.frame = self.beeView.bounds;
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [_taskHelper getCheckList];
	}
}


ON_SIGNAL2(BeeUIButton, signal)
{
    if ([signal is:@"regist"])
    {
        [_taskHelper sigInTask];
    }
}

ON_SIGNAL2(BHMoodVIew, signal)
{
    if ([signal is:@"addMood"])
    {
        BHPostMoodBoard *board = [BHPostMoodBoard board];
        [self.stack pushBoard:board animated:YES];
    }
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    
}

#pragma mark -
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.contentView removeAllSubviews];
    
    if (indexPath.row == 0) {
        if (!headerView) {
            headerView = [[BHRegHeaderView alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, showRegTips?100.f:80.f)];
        }

        [headerView setRegist:hasRegist];
        if (showRegTips) {
            [headerView showTips:_taskHelper.coin];
        }
        [headerView setConNum:_taskHelper.con_num];
        [cell.contentView addSubview:headerView];
    }
    if (indexPath.row == 1)
    {
        if (hasRegist)
        {
            /*心情*/
            BHMoodVIew *view = [[BHMoodVIew alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, firstPub?60.f: 40.f)];
            [view setSignal:@"addMood"];
            [view setFistPub:firstPub];
            [cell.contentView addSubview:view];
            [view release];
            return cell;
        }
    }
    else if (indexPath.row == 2)
    {
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5, 5)]];
        bubbleImageView.frame = CGRectMake(9, 2, 302, 302);
        [cell.contentView addSubview:bubbleImageView];
        [bubbleImageView release];
        
        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
        calendar.frame = CGRectMake(10, 3, 300, 300);
        calendar.delegate = self;
        calendar.regDateArray = _taskHelper.taskReg.dates;
        [cell.contentView addSubview:calendar];
        [calendar release];
    }
    else if (indexPath.row == 3)
    {
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 60)];
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.font = FONT_SIZE(12);
        tipsLabel.textColor = [UIColor darkGrayColor];
        tipsLabel.text = @"规则 :\n连续打卡5天=可获得额外50银币\n连续打卡10天=可获得额外150银币\n打卡并分享当天心情=可额外获得15银币";
        tipsLabel.numberOfLines = 0;
        [cell.contentView addSubview:tipsLabel];
        [tipsLabel release];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (showRegTips) {
            return 100.f;
        }
        return 80.f;
    }
    else if (indexPath.row == 1)
    {
        if (!hasRegist) {
            return 0;
        }
        else
        {
            if (!firstPub) {
                /*心情*/
                return 43.f;
            } else {
                return 63.f;
            }
        }
    }
    else if (indexPath.row == 2)
    {
        return 310.f;
    }
    else if (indexPath.row == 3)
    {
        return 70.f;
    }
    
    return 300.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        NSString *tips = [request.userInfo is:@"postMessage"] ? @"正在发送..." : @"加载中...";
        [self presentLoadingTips:tips];
    }
	else if ( request.succeed )
	{
        if ([request.userInfo is:@"getCheckList"]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"d";
            NSString *date = [dateFormatter stringFromDate:[NSDate date]];
            for (NSString *dateString in _taskHelper.taskReg.dates) {
                if ([date integerValue]== [dateString integerValue]) {
                    hasRegist = YES;
                    break;
                }
            }
            firstPub = !_taskHelper.taskReg.publish;
        }
        else if ([request.userInfo is:@"taskReg"])
        {
            //NSLog(@"balabala -> %@",request.responseString);
            if (_taskHelper.succeed) {
//                [headerView setRegist:YES];
                showRegTips = YES;
                [_taskHelper getCheckList];
            }
        }
        [self reloadDataSucceed:YES];
        [self dismissTips];
        
	}
	else if ( request.failed )
	{
        [self dismissTips];
	}
}
@end
