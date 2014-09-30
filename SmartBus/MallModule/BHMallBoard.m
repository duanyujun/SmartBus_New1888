//
//  BHMallBoard.m
//  SmartBus
//
//  Created by launching on 13-9-30.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHMallBoard.h"
#import "BHProductDescBoard.h"
#import "BHProdItemView.h"
#import "BHProductHelper.h"

@interface BHMallBoard ()
{
    BHProductHelper *_productHelper;
    NSMutableArray *_products;
    NSInteger _page;
}
@end

#define kItemBaseTag  87254

@implementation BHMallBoard

- (void)load
{
    _productHelper = [[BHProductHelper alloc] init];
    [_productHelper addObserver:self];
    _products = [[NSMutableArray alloc] initWithCapacity:0];
    [super load];
}

- (void)unload
{
    [_productHelper removeObserver:self];
    SAFE_RELEASE(_productHelper);
    SAFE_RELEASE(_products);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:YES image:[UIImage imageNamed:@"nav_mall.png"] title:@"商城"];
        
        [self setEnableRefreshHeader:YES];
        [self setEnableLoadMoreFooter:YES];
        self.beeView.backgroundColor = [UIColor whiteColor];
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        [self.egoTableView setFrame:self.beeView.bounds];
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [self egoAllRequest];
	}
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    [super handleRequest:request];
    
    if ( request.sending )
    {
        [self presentLoadingTips:@"加载中..."];
    }
	else if ( request.succeed )
	{
        [self dismissTips];
        
        if ( [request.userInfo is:@"getProducts"] )
        {
            if ( _page == 1 ) {
                [_products removeAllObjects];
            }
            [_products addObjectsFromArray:_productHelper.nodes];
            
            if ( _productHelper.nodes.count < kPageSize ) {
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
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.count / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifer";
    BeeUITableViewCell *cell = (BeeUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell )
    {
        cell = [[[BeeUITableViewCell alloc] initWithReuseIdentifier:identifier] autorelease];
        
        for (int i = 0; i < 2; i++)
        {
            CGFloat x = 10.f + i * (145.f + 10.f);
            BHProdItemView *itemView = [[BHProdItemView alloc] initWithFrame:CGRectMake(x, 5.f, kItemWidth, kItemHeight)];
            itemView.tag = indexPath.row * 2 + i + kItemBaseTag;
            [itemView addTarget:self action:@selector(itemDidSelect:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:itemView];
            [itemView release];
        }
    }
    
    for (int i = 0; i < 2; i++)
    {
        NSInteger idx = indexPath.row * 2 + i;
        BHProdItemView *itemView = (BHProdItemView *)[cell.contentView viewWithTag:idx+kItemBaseTag];
        [itemView setProduct:[_products objectAtIndex:idx]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 186.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark button events

- (void)itemDidSelect:(UIControl *)sender
{
    NSInteger idx = sender.tag - kItemBaseTag;
    
    BHProductModel *product = [_products objectAtIndex:idx];
    BHProductDescBoard *board = [BHProductDescBoard board];
    board.prodid = product.prodid;
    [self.stack pushBoard:board animated:YES];
}


#pragma mark -
#pragma mark refresh / reload data source

- (void)refreshTableViewDataSource
{
    _page = 1;
    [_productHelper getProductsAtPage:_page];
}

- (void)loadTableViewDataSource
{
    _page ++;
    [_productHelper getProductsAtPage:_page];
}

@end
