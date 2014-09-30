//
//  BHRouteHeader.m
//  SmartBus
//
//  Created by launching on 13-10-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHRouteHeader.h"
#import "BHScrollerView.h"
#import "LKBus.h"
#import "BHBannerModel.h"

@interface BHRouteHeader ()<BHScrollerDataSource, BHScrollerDelegate>
{
    BHScrollerView *_scroller;
    UILabel *nearestBusLabel;
    UILabel *nextBusLabel;
    NSArray *_banners;
    id<BHRouteHeaderDelegate> _delegate;
}
@end

#define kStatusLabelTag  57414

@implementation BHRouteHeader

- (id)initWithFrame:(CGRect)frame delegate:(id<BHRouteHeaderDelegate>)delegate
{
    if ( self = [super initWithFrame:frame] )
    {
        _delegate = delegate;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.8f;
        self.layer.shadowRadius = 4.f;
        
        _scroller = [[BHScrollerView alloc] initWithFrame:CGRectMake(5.f, 5.f, 310.f, 100.f)];
        _scroller.layer.masksToBounds = YES;
        _scroller.layer.cornerRadius = 5.f;
        _scroller.dataSource = self;
        _scroller.delegate = self;
        _scroller.autoScrolled = YES;
        [self addSubview:_scroller];
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 105.f, 60.f, 30.f)];
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.font = FONT_SIZE(14);
        tipsLabel.textColor = [UIColor darkGrayColor];
        tipsLabel.text = @"最近一班";
        [self addSubview:tipsLabel];
        [tipsLabel release];
        
        nearestBusLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.f, 105.f, 85.f, 30.f)];
        nearestBusLabel.backgroundColor = [UIColor clearColor];
        nearestBusLabel.font = BOLD_FONT_SIZE(14);
        [self addSubview:nearestBusLabel];
        
        tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(165.f, 105.f, 55.f, 30.f)];
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.font = FONT_SIZE(14);
        tipsLabel.textColor = [UIColor darkGrayColor];
        tipsLabel.text = @"下一班";
        [self addSubview:tipsLabel];
        [tipsLabel release];
        
        nextBusLabel = [[UILabel alloc] initWithFrame:CGRectMake(220.f, 105.f, 85.f, 30.f)];
        nextBusLabel.backgroundColor = [UIColor clearColor];
        nextBusLabel.font = BOLD_FONT_SIZE(14);
        [self addSubview:nextBusLabel];
    }
    return self;
}

- (void)setBanners:(NSArray *)banners
{
    SAFE_RELEASE(_banners);
    _banners = [banners retain];
    [_scroller reloadData];
}

- (void)setStatus:(NSInteger)status text:(NSString *)text
{
    UILabel *tipsLabel1 = (UILabel *)self.subviews[1];
    tipsLabel1.hidden = status;
    
    UILabel *tipsLabel2 = (UILabel *)self.subviews[3];
    tipsLabel2.hidden = status;
    
    nearestBusLabel.hidden = status;
    nextBusLabel.hidden = status;
    
    if ( status == 1 )
    {
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 105.f, 310.f, 30.f)];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.tag = kStatusLabelTag;
        statusLabel.font = FONT_SIZE(14);
        statusLabel.textColor = [UIColor darkGrayColor];
        statusLabel.text = text;
        [self addSubview:statusLabel];
        [statusLabel release];
    }
    else
    {
        UILabel *statusLabel = (UILabel *)[self viewWithTag:kStatusLabelTag];
        if ( statusLabel && statusLabel.superview )
        {
            [statusLabel removeFromSuperview];
        }
    }
}


#pragma mark -
#pragma mark private methods

- (void)refreshData:(NSArray *)datas andCurrentLevel:(NSInteger)level
{
    if ( datas.count == 0 ) {
        return;
    }
    
    // 最近一班车
    LKBus *nearestBus = [datas objectAtIndex:0];
    
    // 下一班车
    LKBus *nextBus = datas.count > 1 ? [datas objectAtIndex:1] : nil;
    
    // 由于未到达的车辆按距离倒序排列，所以当最近一班车的level和下一班车的level相同时,对调
    if ( ( nextBus && nearestBus ) && nearestBus.st_level == nextBus.st_level )
    {
        nearestBusLabel.text = [self stringFromBus:nextBus andCurrentLevel:level];
        nextBusLabel.text = [self stringFromBus:nearestBus andCurrentLevel:level];
    }
    else
    {
        nearestBusLabel.text = [self stringFromBus:nearestBus andCurrentLevel:level];
        nextBusLabel.text = [self stringFromBus:nextBus andCurrentLevel:level];
    }
}

- (NSString *)stringFromBus:(LKBus *)bus andCurrentLevel:(NSInteger)level
{
    NSString *returnStr = nil;
    
    NSInteger diff = level - bus.st_level;
    if ( diff > 0 ) {
        returnStr = [NSString stringWithFormat:@"%d站", diff];
    } else {
        returnStr = [NSString stringWithFormat:@"约%d米", bus.st_dis];
    }
    return returnStr;
}


#pragma mark -
#pragma mark BHScrollerDataSource

- (UIImage *)backgroundImage
{
    return [UIImage imageNamed:@"bubble.png"];
}

- (NSInteger)numberOfImages
{
    return _banners.count;
}

- (UIView *)imageViewAtIndex:(NSInteger)index
{
    BHBannerModel *banner = _banners[index];
    BeeUIImageView *imageView = [[BeeUIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 310.f, 100.f)];
    imageView.backgroundColor = [UIColor flatBlueColor];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [imageView GET:banner.cover useCache:YES];
    return [imageView autorelease];
}


#pragma mark -
#pragma mark BHScrollerDelegate

- (void)photoView:(BHScrollerView *)photoView didSelectAtIndex:(NSInteger)index
{
    BHBannerModel *banner = _banners[index];
    if ( [_delegate respondsToSelector:@selector(routeHeader:didSelectWithAdv:)] )
    {
        [_delegate routeHeader:self didSelectWithAdv:banner];
    }
}

@end
