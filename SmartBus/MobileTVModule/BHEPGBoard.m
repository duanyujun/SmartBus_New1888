//
//  BHEPGBoard.m
//  SmartBus
//
//  Created by 王 正星 on 13-10-24.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHEPGBoard.h"
#import "BHEPGDatePicker.h"
#import "NSDate+Helper.h"
#import "BHEPGListCell.h"
#import "JSTVPlayerViewController.h"
#import "NSDateFunctions.h"

@interface BHEPGBoard ()<UITableViewDataSource, UITableViewDelegate,BHEPGDatePickerDelegate>
{
    BeeUITableView *_tableView;
    BHEPGDatePicker *datePicker;
    NSMutableDictionary *m_dataSource;
    NSString *_tmpEGPDate;
    DateType m_dateType;
    int now_index;
}
@end

@implementation BHEPGBoard

- (void)load
{
    [super load];
//    m_dataSource = [[NSMutableArray alloc]initWithCapacity:5];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_tv.png"] title:[self.m_dic objectForKey:@"channel_name"]];
        
        datePicker = [[BHEPGDatePicker alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f) withDelegate:self];
        [self.beeView addSubview:datePicker];
        
        _tableView = [BeeUITableView new];
        _tableView.backgroundColor = [UIColor clearColor];
		_tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.beeView addSubview:_tableView];
        
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW(_tableView);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_tableView.frame = CGRectMake(0.f, 44.f, 320.f, self.beeView.height -44.f);;
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
		// 数据加载
	}
	else if ( [signal is:BeeUIBoard.FREE_DATAS] )
	{
		// 数据释放
        [self.m_dic release];
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
		// 将要显示
        [_tableView reloadData];
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

- (void)getEGPListByDate:(NSString *)egpDate
{
    self.HTTP_GET([NSString stringWithFormat:@"http://tvenjoywebservice.jstv.com/GetEPGDetailNew.aspx?channelid=%@&epg_date=%@",[_m_dic objectForKey:@"channel_id"],egpDate])
    .TIMEOUT(10);
}


#pragma mark -HTTP
- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        [self presentLoadingTips:@"加载中..."];
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        [m_dataSource release];
        m_dataSource = [[NSMutableDictionary alloc]initWithDictionary:[[request.responseString objectFromJSONString] lastObject]];
//        NSArray *array = [reqponesDic objectForKey:@"epg"];
//        NSLog(@"epg Array -> %@",array);
//        [m_dataSource removeAllObjects];
//        for (NSDictionary *dic in array) {
//            [m_dataSource addObject:[NSMutableDictionary dictionaryWithDictionary:dic]];
//        }
        if (m_dateType == DateTypeNow) {
            now_index = [NSDateFunctions GetNowTimeIndex:[m_dataSource objectForKey:@"epg"]];
        }
        [_tableView reloadData];
        if (m_dateType == DateTypeNow) {
            if ([m_dataSource count] > 0) {
                if (now_index + 4 < [[m_dataSource objectForKey:@"epg"] count]) {
                    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:now_index+4 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    
                }
                else {
                    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[m_dataSource objectForKey:@"epg"] count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
        }
        
	}
	else if ( request.failed )
	{
        [self dismissTips];
		NSLog(@"error :%@", request.error);
	}
}
#pragma mark -
#pragma mark table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *grididentifier = @"identifierGrid";
    
    BHEPGListCell *cell = (BHEPGListCell *)[tableView dequeueReusableCellWithIdentifier:grididentifier];
    if ( !cell )
    {
        cell = [[[BHEPGListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:grididentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setCellData:[[m_dataSource objectForKey:@"epg"] objectAtIndex:indexPath.row] withDateType:m_dateType isNowIndex:now_index == indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > now_index) {
        return;
    }
    NSDictionary *dic = [[m_dataSource objectForKey:@"epg"] objectAtIndex:[indexPath row]];
    
    JSTVPlayerViewController *viewController = [[JSTVPlayerViewController alloc] init];
    viewController.isFullScreen = YES;
    viewController.title = [m_dataSource objectForKey:@"channel_name"];
    viewController.playType = BACKTYPE;
    NSMutableArray * urls = [m_dataSource objectForKey:@"flow_urls"];
    viewController.playUrls = urls;
    viewController.delayTime = [[NSDate dateFromString:_tmpEGPDate withFormat:@"yyyy-MM-dd"] timeIntervalSince1970]+[NSDateFunctions getSecFormMinAndSec:[dic objectForKey:@"epg_time"]];
    viewController.imageUrl = [m_dataSource objectForKey:@"screenshot"];
    viewController.epgId = [m_dataSource objectForKey:@"channel_id"];
//    //    if (![m_dataSource objectForKey:@"epg"])
//    {
//        [m_dataSource setObject:m_programListArray forKey:@"epg"];
//    }
    viewController.epgData = m_dataSource;
    
    UINavigationController *NaviController = [[UINavigationController alloc]
                                              initWithRootViewController:viewController];
    NaviController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:NaviController animated:YES completion:nil];
    [viewController release];
    [NaviController release];
}
#pragma mark - table view delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[m_dataSource objectForKey:@"epg"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50.f;
}


#pragma mark - DayOfWeekViewDelegate

- (void)dayOfWeekView:(BHEPGDatePicker*)view didSelIndex:(NSInteger)_index withDateString:(NSString *)epgdate
{
    NSLog(@"selectIndex-> %d %@",_index ,epgdate);
    [_tmpEGPDate release];
    _tmpEGPDate = [epgdate retain];
    [self checkDate];
    [self getEGPListByDate:_tmpEGPDate];
}

- (void)checkDate
{
    NSDate *date = [NSDate dateFromString:_tmpEGPDate];
    if ([_tmpEGPDate isEqualToString:[NSDateFunctions getCurrentYearMonthDay]]) {
        m_dateType = DateTypeNow;
    }else if ([date earlierDate:[NSDate dateFromString:[NSDateFunctions getCurrentYearMonthDay]]] == date) {
        m_dateType = DateTypeBefore;
    }else{
        m_dateType = DateTypeAfter;
    }
}
@end
