//
//  BHResultPopView.m
//  SmartBus
//
//  Created by launching on 13-10-21.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHResultPopView.h"

@interface BHResultPopView ()<AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIView *_container;
    
    PopoupSelectedBlock _selectedBlock;
    PopoupCompleteBlock _completeBlock;
    AMapSearchAPI *_search;
    
    NSMutableArray *_pois;
    NSString *_title;
    NSInteger _pageIndex;
}
- (void)fadeIn;
- (void)fadeOut:(BOOL)callback;
- (void)searchWithKey:(NSString *)key;
@end

#define kInset 40.
#define kHeaderHeight 36.
#define radius 5.

@implementation BHResultPopView

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(_tableView);
    SAFE_RELEASE_SUBVIEW(_activity);
    SAFE_RELEASE(_search);
    SAFE_RELEASE(_pois);
    SAFE_RELEASE(_selectedBlock);
    SAFE_RELEASE(_title);
    _search.delegate = nil;
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title key:(NSString *)key
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    if ( self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor clearColor];
        
        _title = [title retain];
        self.searchKey = key;
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.3f;
        [self addSubview:backgroundView];
        [backgroundView release];
        
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
        titleLabel.text = title;
        [_container addSubview:titleLabel];
        [titleLabel release];
        
        _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_container.frame.size.width-30.f, 8.f, 20.f, 20.f)];
        _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_container addSubview:_activity];
        
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
        
        _pois = [[NSMutableArray alloc] initWithCapacity:0];
        _search = [[AMapSearchAPI alloc] initWithSearchKey:MASearchKey Delegate:self];
    }
    return self;
}

- (id)init
{
    return [self initWithTitle:nil key:nil];
}


#pragma mark -
#pragma mark public methods

- (void)setTitle:(NSString *)title key:(NSString *)key
{
    [_title release];
    _title = [title retain];
    self.searchKey = key;
    _pageIndex = 0;
    [self setNeedsDisplay];
}

- (void)showInView:(UIView *)view selected:(PopoupSelectedBlock)selected completion:(PopoupCompleteBlock)completion
{
    [_selectedBlock release];
    _selectedBlock = [selected copy];
    
    [_completeBlock release];
    _completeBlock = [completion copy];
    
    // 动画显示
    [view addSubview:self];
    [self fadeIn];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(searchWithKey:) withObject:self.searchKey afterDelay:0];
}

- (void)searchWithKey:(NSString *)key
{
    [_activity startAnimating];
    
    AMapPlaceSearchRequest *option = [[AMapPlaceSearchRequest alloc] init];
    option.keywords = key;
    option.city = @[@"nanjing"];
    option.page = ++_pageIndex;
    [_search AMapPlaceSearch:option];
    [option release];
}


#pragma mark -
#pragma mark private methods

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
            if (_completeBlock) {
                _completeBlock( finished );
            }
        }
    }];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _pois.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    BeeUITableViewCell *cell = (BeeUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell )
    {
        cell = [[[BeeUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
        cell.textLabel.font = FONT_SIZE(14);
    }
    
    AMapPOI *poi = _pois[indexPath.row];
    cell.detailTextLabel.font = FONT_SIZE(12);
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_selectedBlock) {
        _selectedBlock( _pois[indexPath.row] );
    }
    
    [self fadeOut:YES];
}


#pragma mark - AMapSearchDelegate

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)result
{
    [_activity stopAnimating];
    
    for (AMapPOI *poi in result.pois)
    {
        [_pois addObject:poi];
    }
    
    [_tableView reloadData];
}

- (void)search:(id)searchOption Error:(NSString*)errCode
{
    NSLog(@"errCode :%@", errCode);
}


#pragma mark - other events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self fadeOut:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ( decelerate )
    {
        if ( scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height - 60.f) && scrollView.contentSize.height > scrollView.frame.size.height ) {
            [self searchWithKey:self.searchKey];
        }
    }
}

@end



@implementation BHStartResPopView

- (id)initWithTitle:(NSString *)title key:(NSString *)key
{
    return [super initWithTitle:title key:key];
}

@end


@implementation BHEndResPopView

- (id)initWithTitle:(NSString *)title key:(NSString *)key
{
    return [super initWithTitle:title key:key];
}

@end
