//
//  BHProductDescBoard.m
//  SmartBus
//
//  Created by launching on 13-12-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHProductDescBoard.h"
#import "BHScrollerView.h"
#import "BHProductHelper.h"
#import "UIImageView+WebCache.h"

@interface BHProductDescBoard ()<BHScrollerDataSource, BHScrollerDelegate>
{
    UIView *_headerBar;
    UIView *_tipsBar;
    UIView *_footerBar;
    UIScrollView *_scroller;
    
    BHProductHelper *_productHelper;
    BHProductModel *_product;
}
- (void)buildProductHeader;
- (void)buildProductScroller;
- (void)buildProductExchange;
- (void)buildTipsBar;
- (void)reloadProductDesc:(BHProductModel *)product;
@end


#define kValueBaseTag  12379

@implementation BHProductDescBoard

DEF_SIGNAL( EXCHANGE );

- (void)load
{
    _productHelper = [[BHProductHelper alloc] init];
    [_productHelper addObserver:self];
    [super load];
}

- (void)unload
{
    [_productHelper removeObserver:self];
    SAFE_RELEASE(_productHelper);
    SAFE_RELEASE(_product);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_mall.png"] title:@"商城"];
        
        [self buildProductHeader];
        [self buildProductScroller];
        [self buildTipsBar];
        [self buildProductExchange];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_headerBar);
        SAFE_RELEASE_SUBVIEW(_tipsBar);
        SAFE_RELEASE_SUBVIEW(_footerBar);
        SAFE_RELEASE_SUBVIEW(_scroller);
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [_productHelper getProductDescById:self.prodid];
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.EXCHANGE] )
    {
        if ( [BHUserModel sharedInstance].uid == 0 )
        {
            BHLoginBoard *board = [BHLoginBoard board];
            BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
            [self presentViewController:stack animated:YES completion:nil];
            return;
        }
        
        if ( [[BHUserModel sharedInstance].score intValue] < _product.coin )
        {
            [self presentMessageTips:@"您当前所剩余的银币不足"];
            return;
        }
        
        [_productHelper exchangeProduct:self.prodid];
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
        
        if ( [request.userInfo is:@"getProdDesc"] )
        {
            if ( _productHelper.succeed )
            {
                SAFE_RELEASE(_product);
                _product = [[_productHelper.nodes objectAtIndex:0] retain];
                [self reloadProductDesc:_product];
            }
        }
        else if ( [request.userInfo is:@"exchange"] )
        {
            if ( _productHelper.succeed )
            {
                [self presentMessageTips:@"兑换成功"];
            }
        }
	}
	else if ( request.failed )
	{
		[self dismissTips];
	}
}


#pragma mark -
#pragma mark private methods

- (void)buildProductHeader
{
    _headerBar = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 216.f)];
    _headerBar.backgroundColor = [UIColor whiteColor];
    _headerBar.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _headerBar.layer.shadowOffset = CGSizeMake(0, 1);
    _headerBar.layer.shadowOpacity = 0.8;
    _headerBar.layer.shadowRadius = 4;
    
    BHScrollerView *scroller = [[BHScrollerView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 180.f)];
    scroller.delegate = self;
    scroller.dataSource = self;
    scroller.autoScrolled = YES;
    [_headerBar addSubview:scroller];
    [scroller release];
    
    UILabel *pnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 188.f, 300.f, 20.f)];
    pnameLabel.backgroundColor = [UIColor clearColor];
    pnameLabel.font = FONT_SIZE(15);
    [_headerBar addSubview:pnameLabel];
    
    [self.beeView addSubview:_headerBar];
    [self.beeView sendSubviewToBack:_headerBar];
}

- (void)buildProductScroller
{
    _scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 216.f, 320.f, self.beeView.bounds.size.height-264.f)];
    _scroller.backgroundColor = [UIColor clearColor];
    _scroller.showsVerticalScrollIndicator = NO;
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)]];
    bubbleImageView.frame = CGRectMake(10.f, 10.f, 300.f, 44.f*3);
    
    NSArray *items = [NSArray arrayWithObjects:@"剩余数量", @"市场参考价", @"物品描述", nil];
    for (int i = 0; i < items.count; i++)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, i*40.f, 90.f, 40.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONT_SIZE(14);
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.text = [items objectAtIndex:i];
        [bubbleImageView addSubview:titleLabel];
        [titleLabel release];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.f, i*40.f, 190.f, 40.f)];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.tag = kValueBaseTag + i;
        valueLabel.font = FONT_SIZE(14);
        valueLabel.textColor = i == 1 ? [UIColor flatRedColor] : [UIColor flatBlackColor];
        valueLabel.numberOfLines = 0;
        [bubbleImageView addSubview:valueLabel];
        [valueLabel release];
        
        if ( i < items.count - 1 )
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10.f, (i+1)*39.f, 280.f, 1.f)];
            line.backgroundColor = [UIColor flatWhiteColor];
            [bubbleImageView addSubview:line];
            [line release];
        }
    }
    
    [_scroller addSubview:bubbleImageView];
    [bubbleImageView release];
    
    [self.beeView addSubview:_scroller];
}

- (void)buildProductExchange
{
    _footerBar = [[UIView alloc] initWithFrame:CGRectMake(0.f, self.beeView.bounds.size.height-48.f, 320.f, 48.f)];
    _footerBar.backgroundColor = [UIColor whiteColor];
    _footerBar.layer.shadowColor = [UIColor blackColor].CGColor;
    _footerBar.layer.shadowOffset = CGSizeMake(0, 1);
    _footerBar.layer.shadowOpacity = 0.8;
    _footerBar.layer.shadowRadius = 4;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 9.f, 80.f, 30.f)];
    tipsLabel.backgroundColor = [UIColor clearColor];
    tipsLabel.font = FONT_SIZE(15);
    tipsLabel.textColor = [UIColor darkGrayColor];
    tipsLabel.text = @"兑换标准 : ";
    [_footerBar addSubview:tipsLabel];
    
    UILabel *exchangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.f, 9.f, 130.f, 30.f)];
    exchangeLabel.backgroundColor = [UIColor clearColor];
    exchangeLabel.font = FONT_SIZE(15);
    exchangeLabel.textColor = [UIColor flatRedColor];
    [_footerBar addSubview:exchangeLabel];
    [exchangeLabel release];
    
    BeeUIButton *exchangeButton = [BeeUIButton new];
    exchangeButton.frame = CGRectMake(230.f, 6.f, 80.f, 36.f);
    exchangeButton.backgroundColor = [UIColor flatRedColor];
    exchangeButton.title = @"立即兑换";
    exchangeButton.titleColor = [UIColor whiteColor];
    [exchangeButton addSignal:self.EXCHANGE forControlEvents:UIControlEventTouchUpInside];
    [_footerBar addSubview:exchangeButton];
    
    [self.beeView addSubview:_footerBar];
    [self.beeView bringSubviewToFront:_footerBar];
}

- (void)buildTipsBar
{
    _tipsBar = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 34.f)];
    _tipsBar.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:_tipsBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 0.4;
    [_tipsBar addSubview:bgView];
    [bgView release];
    
    NSString *tips = @"您当前所剩余的银币";
    CGSize size = [tips sizeWithFont:FONT_SIZE(14) byWidth:300.f];
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 7.f, size.width, 20.f)];
    tipsLabel.backgroundColor = [UIColor clearColor];
    tipsLabel.font = FONT_SIZE(14);
    tipsLabel.textColor = [UIColor darkGrayColor];
    tipsLabel.text = tips;
    [_tipsBar addSubview:tipsLabel];
    [tipsLabel release];
    
    UILabel *coinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f+size.width, 7.f, 150.f, 20.f)];
    coinsLabel.backgroundColor = [UIColor clearColor];
    coinsLabel.font = FONT_SIZE(14);
    coinsLabel.textColor = [UIColor flatRedColor];
    [_tipsBar addSubview:coinsLabel];
    [coinsLabel release];
    
    [self.beeView addSubview:_tipsBar];
    [self.beeView bringSubviewToFront:_tipsBar];
}

- (void)reloadProductDesc:(BHProductModel *)product
{
    // 剩余银币
    NSString *score = [BHUserModel sharedInstance].score;
    UILabel *coinsLabel = (UILabel *)[_tipsBar.subviews objectAtIndex:2];
    [coinsLabel setText:(score && score.length > 0) ? score : @"0"];
    
    // 基本信息
    BHScrollerView *scroller = (BHScrollerView *)[_headerBar.subviews objectAtIndex:0];
    [scroller reloadData];
    
    UILabel *pnameLabel = (UILabel *)[_headerBar.subviews objectAtIndex:1];
    [pnameLabel setText:product.pname];
    
    // 商品详情
    UIImageView *bubbleImageView = (UIImageView *)[_scroller.subviews objectAtIndex:0];
    
    CGFloat y = 0.f;
    NSArray *values = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", product.total],
                       [NSString stringWithFormat:@"%0.1f元", product.price], product.pdesc, nil];
    for (int i = 0; i < 3; i++)
    {
        CGSize size = CGSizeMake(0.f, 40.f);
        if ( i == 2 ) {
            size = [product.pdesc sizeWithFont:FONT_SIZE(14) byWidth:190.f];
            size.height += 24.f;
        }
        
        UILabel *valueLabel = (UILabel *)[bubbleImageView viewWithTag:kValueBaseTag + i];
        [valueLabel setFrame:CGRectMake(100.f, y, 190.f, size.height)];
        [valueLabel setText:[values objectAtIndex:i]];
        
        y += size.height;
    }
    
    [bubbleImageView setFrame:CGRectMake(10.f, 10.f, 300.f, y)];
    [_scroller setContentSize:CGSizeMake(320.f, bubbleImageView.frame.size.height + 20.f)];
    
    // 兑换
    UILabel *exchangeLabel = (UILabel *)[_footerBar.subviews objectAtIndex:1];
    [exchangeLabel setText:[NSString stringWithFormat:@"%d银币", product.coin]];
}


#pragma mark -
#pragma mark BHScrollerDataSource

- (NSInteger)numberOfImages
{
    if ( _productHelper.nodes.count == 0 )
    {
        return 0;
    }
    
    return _product.photos.count;
}

- (UIView *)imageViewAtIndex:(NSInteger)index
{
    if ( _productHelper.nodes.count == 0 )
    {
        return nil;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 180.f)];
    imageView.backgroundColor = [UIColor clearColor];
    [imageView setImageWithURL:[NSURL URLWithString:_product.photos[index]]
              placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    return [imageView autorelease];
}

@end
