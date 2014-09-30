//
//  BHMobileTVBoard.m
//  SmartBus
//
//  Created by launching on 13-9-30.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHMobileTVBoard.h"
#import "BHChannelsPopoup.h"
#import "BHChannelGridCell.h"
#import "BHChannelListCell.h"
#import "BHTriangleButton.h"
#import "BHEPGBoard.h"
#import "NSDateFunctions.h"

@interface BHMobileTVBoard ()<UITableViewDataSource, UITableViewDelegate,BHChannelsPopoupDelegate>
{
    BeeUITableView *_tableView;
    BHTriangleButton *_triangleButton;
    NSMutableArray *m_dataSource;
    NSMutableArray *m_categorys;
    NSInteger _selectedIndex;
}
@end

#define kMenuBtnTag     911

@implementation BHMobileTVBoard

DEF_SIGNAL( MORE );
DEF_SIGNAL( MODE );
DEF_SIGNAL( REFRESH );

- (void)load
{
    m_dataSource = [[NSMutableArray alloc]initWithCapacity:5];
    m_categorys = [[NSMutableArray alloc]initWithCapacity:5];
    [super load];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:YES image:[UIImage imageNamed:@"nav_tv.png"] title:nil];
        
        _tableView = [BeeUITableView new];
        _tableView.backgroundColor = [UIColor clearColor];
		_tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.beeView addSubview:_tableView];
        
        _triangleButton = [[BHTriangleButton alloc] initWithFrame:CGRectMake(50.f, 2.f, 100.f, 40.f)];
        _triangleButton.backgroundColor = [UIColor clearColor];
        [_triangleButton addSignal:self.MORE forControlEvents:UIControlEventTouchUpInside];
        [_triangleButton setTitle:@"推荐频道"];
        [self.navigationBar addSubview:_triangleButton];
        
        BeeUIButton *displayButton = [BeeUIButton new];
        displayButton.frame = CGRectMake(320.f-88.f, 0.f, 44.f, 44.f);
        displayButton.backgroundColor = [UIColor clearColor];
        displayButton.tag = kMenuBtnTag;
        displayButton.stateNormal.image = [UIImage imageNamed:@"icon_listmodel.png"];
        displayButton.stateSelected.image = [UIImage imageNamed:@"icon_gridmodel.png"];
        [displayButton addSignal:BHMobileTVBoard.MODE forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:displayButton];
        
        BeeUIButton *refreshButton = [BeeUIButton new];
        refreshButton.frame = CGRectMake(320.f-44.f, 0.f, 44.f, 44.f);
        refreshButton.backgroundColor = [UIColor clearColor];
        refreshButton.image = [UIImage imageNamed:@"icon_refresh.png"];
        [refreshButton addSignal:BHMobileTVBoard.REFRESH forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:refreshButton];
        
        [BHChannelsPopoup sharedInstance].delegate = self;
        [self getCateglorys];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW(_tableView);
        SAFE_RELEASE_SUBVIEW(_triangleButton);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_tableView.frame = self.beeView.bounds;
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

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:BHMobileTVBoard.MODE] )
    {
        BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kMenuBtnTag];
        button.selected = !button.selected;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3f ;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        [_tableView reloadData];
        [self.view.layer addAnimation:animation forKey:@"animation"];
    }
    else if ([signal is:@"cellClick"])
    {
        NSLog(@"%d",signal.sourceView.tag);
        [self pushEPGBoard:[m_dataSource objectAtIndex:signal.sourceView.tag-1000]];
    }
    else if ([signal is:self.REFRESH])
    {
        [self getLiveChannels:m_categorys[_selectedIndex][@"id"]];
    }
}

ON_SIGNAL2( BHTriangleButton, signal )
{
    if ( [signal is:self.MORE] )
    {
        NSMutableArray *_channels = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *category in m_categorys) {
            [_channels addObject:category[@"name"]];
        }
        [[BHChannelsPopoup sharedInstance] setChannels:_channels];
        [[BHChannelsPopoup sharedInstance] showInView:self.beeView atPosition:CGPointMake(30.f, 2.f)];
    }
}


- (void)pushEPGBoard:(NSMutableDictionary *)dic
{
    BHEPGBoard *vc = [BHEPGBoard board];
    vc.m_dic = dic;
    [self.stack pushBoard:vc animated:YES];
}

- (void)getCateglorys
{
    self
    .HTTP_GET(@"http://tvenjoywebservice.jstv.com/GetChannelClassList.aspx")
    .TIMEOUT(10)
    .USER_INFO(@"getCateglorys");
}

- (void)getLiveChannels:(NSString *)parentId
{   
    self
    .HTTP_GET([NSString stringWithFormat:@"http://tvenjoywebservice.jstv.com/GetEpgNew.aspx?classid=%@",parentId])
    .TIMEOUT(10)
    .USER_INFO(@"getLiveChannels");
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
        
        if ([request.userInfo is:@"getCateglorys"]) {
            NSArray *array = [request.responseString objectFromJSONString];
            for (NSDictionary *dic in array) {
                [m_categorys addObject:[NSDictionary dictionaryWithDictionary:dic]];
            }
            if (array.count) {
                [self BHChannelsPopoup:[BHChannelsPopoup sharedInstance] selectIndex:0];
            }
        }else if ([request.userInfo is:@"getLiveChannels"]){
            NSArray *array = [request.responseString objectFromJSONString];
            NSLog(@"array -> %@",array);
            [m_dataSource removeAllObjects];
            for (NSDictionary *dic in array) {
                NSMutableDictionary *mudic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                NSString *url = [NSString stringWithFormat:@"%@%@",[dic valueForKey:@"img_url"],[NSDateFunctions getEpgScreenShotTimeForTimeInt]];
                [mudic setObject:url forKey:@"img_screenUrl"];
                [m_dataSource addObject:[NSDictionary dictionaryWithDictionary:mudic]];
            }
            [_tableView reloadData];
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
    static NSString *listidentifier = @"identifierList";
    BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kMenuBtnTag];
    UITableViewCell *cell= nil;
    if (button.selected) {
        /*列表*/
        cell = (BHChannelListCell *)[tableView dequeueReusableCellWithIdentifier:listidentifier];
        if ( !cell )
        {
            cell = [[[BHChannelListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listidentifier] autorelease];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [(BHChannelListCell*)cell setCellData:[m_dataSource objectAtIndex:indexPath.row]];
        
    }else{
        /*九宫*/
        cell = (BHChannelGridCell *)[tableView dequeueReusableCellWithIdentifier:grididentifier];
        if ( !cell )
        {
            cell = [[[BHChannelGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:grididentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        
        int startIndex = indexPath.row*2;
        int endIndex = startIndex+2 > m_dataSource.count?m_dataSource.count:startIndex+2;
        for (int i = startIndex; i < endIndex; i++) {
            [(BHChannelGridCell *)cell setCellData:[m_dataSource objectAtIndex:i] withIndex:i];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushEPGBoard:[m_dataSource objectAtIndex:indexPath.row]];
}

#pragma mark - table view delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kMenuBtnTag];
    if (button.selected) {
        
        return [m_dataSource count];
    }
    else
    {
        return ceil((double)m_dataSource.count/2);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BeeUIButton *button = (BeeUIButton *)[self.navigationBar viewWithTag:kMenuBtnTag];
    if (button.selected) {
        return 100.f;
    }
    else
    {
        return 145.f;
    }
}


#pragma mark - - (void)BHChannelsPopoup:(BHChannelsPopoup *)view selectIndex:(int)index;

- (void)BHChannelsPopoup:(BHChannelsPopoup *)view selectIndex:(int)index
{
    _selectedIndex = index;
    [_triangleButton setTitle:m_categorys[index][@"name"]];
    [self getLiveChannels:m_categorys[index][@"id"]];
}
@end
