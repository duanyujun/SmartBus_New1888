//
//  BHNewsBoard.m
//  SmartBus
//
//  Created by launching on 13-11-20.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHNewsBoard.h"
#import "BHOnSiteBoard.h"
#import "BHNewsDescBoard.h"
#import "BHSegmentedMenu.h"
#import "BHScrollerView.h"
#import "BHNewsCell.h"
#import "BHOnSiteCell.h"
#import "BHNewsHelper.h"

typedef enum {
    BHNewsCellStyleNews = 0,
    BHNewsCellStyleOnSite
} BHNewsCellStyle;

@interface BHNewsBoard ()<BHScrollerDataSource, BHScrollerDelegate>
{
    BHSegmentedMenu *segmentedMenu;
    BHScrollerView *_scroller;
    BHNewsHelper *_newsHelper;
    NSMutableArray *_newsArray;
    
    NSInteger _page;
    BHNewsCellStyle _style;
}
@end

@implementation BHNewsBoard

- (void)load
{
    _newsHelper = [[BHNewsHelper alloc] init];
    [_newsHelper addObserver:self];
    _newsArray = [[NSMutableArray alloc] initWithCapacity:0];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE_SUBVIEW(segmentedMenu);
    SAFE_RELEASE_SUBVIEW(_scroller);
    [_newsHelper removeObserver:self];
    SAFE_RELEASE(_newsHelper);
    SAFE_RELEASE(_newsArray);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:!self.leaf image:[UIImage imageNamed:@"nav_life.png"] title:@"南京生活"];
        
        segmentedMenu = [[BHSegmentedMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
        segmentedMenu.backgroundColor = [UIColor flatGrayColor];
        segmentedMenu.font = BOLD_FONT_SIZE(16);
        segmentedMenu.textColor = [UIColor flatBlackColor];
        segmentedMenu.selectionIndicatorColor = [UIColor flatDarkRedColor];
        segmentedMenu.selectionIndicatorMode = HMSelectionIndicatorFillsSegment;
        [segmentedMenu addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [self.beeView addSubview:segmentedMenu];
        
        [self setEnableRefreshHeader:YES];
        [self setEnableLoadMoreFooter:YES];
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        CGRect rc = self.beeView.bounds;
        rc.origin.y = 44.f;
        rc.size.height -= 44.f;
        [self.egoTableView setFrame:rc];
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [_newsHelper getNewsCategory];
	}
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        if ( [request.userInfo is:@"getNews"] || [request.userInfo is:@"getOnSites"] )
        {
            [self presentLoadingTips:@"加载中..."];
        }
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        
        if ( [request.userInfo is:@"getCategory"] )
        {
            NSMutableArray *titles = [NSMutableArray arrayWithCapacity:0];
            for (BHMenuModel *menu in _newsHelper.menus) {
                [titles addObject:menu.name];
            }
            segmentedMenu.sectionTitles = titles;
            
            // 加载新闻
            [self performSelector:@selector(egoAllRequest) withObject:nil afterDelay:0.5];
        }
        else if ( [request.userInfo is:@"getNewsTops"] )
        {
            [_scroller reloadData];
        }
        else if ( [request.userInfo is:@"getNews"] || [request.userInfo is:@"getOnSites"] )
        {
            if ( !_newsHelper.succeed )
            {
                [self reloadDataSucceed:NO];
                return;
            }
            
            if ( _page == 1 ) {
                [_newsArray removeAllObjects];
            }
            [_newsArray addObjectsFromArray:_newsHelper.nodes];
            
            if ( _newsHelper.nodes.count < kPageSize ) {
                self.isLoadingOver = YES;
            } else {
                self.isLoadingOver = NO;
            }
            [self reloadDataSucceed:YES];
        }
	}
    else if ( request.failed )
    {
        [self dismissTips];
    }
}


#pragma mark -
#pragma mark BHScrollerDataSource

- (UIImage *)backgroundImage
{
    return [UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)];
}

- (NSInteger)numberOfImages
{
    return _newsHelper.tops.count;
}

- (UIView *)imageViewAtIndex:(NSInteger)index
{
    BHNewsModel *news = [_newsHelper.tops objectAtIndex:index];
    BeeUIImageView *imageView = [[BeeUIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 300.f, 150.f)];
    imageView.backgroundColor = [UIColor clearColor];
    [imageView GET:news.cover useCache:YES];
    return [imageView autorelease];
}


#pragma mark -
#pragma mark BHScrollerDelegate

- (NSString *)titleAtIndex:(NSInteger)index
{
    BHNewsModel *news = [_newsHelper.tops objectAtIndex:index];
    return news.title;
}

- (void)photoView:(BHScrollerView *)photoView didSelectAtIndex:(NSInteger)index
{
    BHNewsModel *news = [_newsHelper.tops objectAtIndex:index];
    BHNewsDescBoard *board = [[BHNewsDescBoard alloc] initWithNews:news];
    [self.stack pushBoard:board animated:YES];
    [board release];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? 1 : _newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        static NSString *identifier = @"top_identifier";
        BeeUITableViewCell *cell = (BeeUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if ( !cell )
        {
            cell = [[[BeeUITableViewCell alloc] initWithReuseIdentifier:identifier] autorelease];
            _scroller = [[BHScrollerView alloc] initWithFrame:CGRectMake(10.f, 8.f, 300.f, 150.f)];
            _scroller.layer.masksToBounds = YES;
            _scroller.layer.cornerRadius = 5.f;
            _scroller.delegate = self;
            _scroller.dataSource = self;
            _scroller.autoScrolled = YES;
            [cell.contentView addSubview:_scroller];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *identifier = @"news_identifier";
        BHNewsCell *cell = (BHNewsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if ( !cell ) {
            cell = [[[BHNewsCell alloc] initWithReuseIdentifier:identifier] autorelease];
        }
        cell.news = [_newsArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    return nil;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 158.f : kNewsTableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BHNewsModel *news = [_newsArray objectAtIndex:indexPath.row];
    BHNewsDescBoard *board = [[BHNewsDescBoard alloc] initWithNews:news];
    [self.stack pushBoard:board animated:YES];
    [board release];
}


#pragma mark -
#pragma mark BHSegmentedMenu change value

- (void)segmentedControlChangedValue:(id)sender
{
    [self egoAllRequest];
}


#pragma mark -
#pragma mark refresh / reload data source

- (void)refreshTableViewDataSource
{
    _page = 1;
    
    BHMenuModel *menu = [_newsHelper.menus objectAtIndex:segmentedMenu.selectedIndex];
    [_newsHelper getNewsTops:menu.mid];
    [_newsHelper getNews:menu.mid atPage:_page];
}

- (void)loadTableViewDataSource
{
    ++_page;
    
    BHMenuModel *menu = [_newsHelper.menus objectAtIndex:segmentedMenu.selectedIndex];
    [_newsHelper getNews:menu.mid atPage:_page];
}

@end
