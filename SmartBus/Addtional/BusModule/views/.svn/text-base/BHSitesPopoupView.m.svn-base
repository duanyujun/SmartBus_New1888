//
//  BHSitesPopoupView.m
//  SmartBus
//
//  Created by launching on 13-10-24.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSitesPopoupView.h"
#import "LKStation.h"

@interface BHSitesPopoupView ()<UITableViewDataSource, UITableViewDelegate>
{
    BeeUITableView *_tableView;
    UIView *_container;
    
    NSArray *_sites;
    SiteSelectedBlock _block;
}
- (void)fadeIn;
- (void)fadeOut:(BOOL)callback;
@end


#define kInset 40.
#define kHeaderHeight 36.
#define radius 5.

@implementation BHSitesPopoupView

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(_tableView);
    SAFE_RELEASE(_block);
    [super dealloc];
}

- (id)initWithSites:(NSArray *)sites
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    if ( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIControl *layer = [[UIControl alloc] initWithFrame:self.bounds];
        layer.backgroundColor = [UIColor blackColor];
        layer.alpha = 0.3f;
        [layer addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:layer];
        [layer release];
        
        CGRect rc = CGRectMake(kInset, kInset, frame.size.width-2*kInset, frame.size.height-2*kInset);
        _container = [[UIView alloc] initWithFrame:rc];
        _container.backgroundColor = [UIColor whiteColor];
        _container.layer.masksToBounds = YES;
        _container.layer.cornerRadius = 5.f;
        [self addSubview:_container];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 6.f, 200.f, kHeaderHeight-6.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = BOLD_FONT_SIZE(16);
        titleLabel.textColor = RGB(223., 55., 74.);
        titleLabel.text = @"我当前的站台...";
        [_container addSubview:titleLabel];
        [titleLabel release];
        
        UIView *hline = [[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, rc.size.width, 2.f)];
        hline.backgroundColor = RGB(223., 55., 74.);
        [_container addSubview:hline];
        [hline release];
        
        rc = _container.bounds;
        rc.origin.y = kHeaderHeight + 2.f;
        rc.size.height -= kHeaderHeight + 2.f + radius;
        _tableView = [[BeeUITableView alloc] initWithFrame:rc];
        _tableView.separatorColor = [UIColor colorWithWhite:0 alpha:.2];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_container addSubview:_tableView];
        
        _sites = [sites retain];
    }
    return self;
}


#pragma mark -
#pragma mark public methods

- (void)showInView:(UIView *)view completion:(SiteSelectedBlock)completion
{
    [_block release];
    _block = [completion copy];
    
    // 动画显示
    [view addSubview:self];
    [self fadeIn];
}


#pragma mark -
#pragma mark private methods

- (void)tapped:(id)sender
{
    if (_block)
    {
        _block( nil );
    }
    
    [self fadeOut:YES];
}

- (void)fadeIn
{
    _container.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1;
        _container.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)fadeOut:(BOOL)callback
{
    [UIView animateWithDuration:0.35 animations:^{
        _container.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished && callback) {
            [self removeFromSuperview];
        }
    }];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    BeeUITableViewCell *cell = (BeeUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell )
    {
        cell = [[[BeeUITableViewCell alloc] initWithReuseIdentifier:identifier] autorelease];
        cell.textLabel.font = FONT_SIZE(14);
    }
    
    LKStation *station = _sites[indexPath.row];
    cell.textLabel.text = station.st_name;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_block)
    {
        LKStation *station = _sites[indexPath.row];
        _block( station );
    }
    
    [self fadeOut:YES];
}

@end
