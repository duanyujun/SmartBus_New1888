//
//  BHSearchPopoups.m
//  SmartBus
//
//  Created by launching on 13-11-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSearchPopoups.h"
#import "CacheDBHelper.h"
#import "BUSDBHelper.h"

@interface BHSearchPopoups ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    BeeUITableView *_tableView;
    UISearchBar *_searchBar;
    NSMutableArray *_associates;
    id<BHSearchPopoupsDelegate> _delegate;
}
- (void)reloadHistories;
@end

@implementation BHSearchPopoups

- (void)dealloc
{
    SAFE_RELEASE(_associates);
    SAFE_RELEASE_SUBVIEW(_tableView);
    SAFE_RELEASE_SUBVIEW(_searchBar);
    _delegate = nil;
    [super dealloc];
}

- (id)initWithPlaceholder:(NSString *)placeholder delegate:(id<BHSearchPopoupsDelegate>)delegate
{
    if ( self = [super initWithFrame:CGRectZero] )
    {
        self.backgroundColor = [UIColor flatWhiteColor];
        
        _delegate = delegate;
        
        _tableView = [[BeeUITableView alloc] initWithFrame:CGRectMake(0, 44.f, self.width, self.height-44.f)];
        _tableView.backgroundColor = [UIColor clearColor];
		_tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:_tableView];
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
        _searchBar.tintColor = [UIColor flatGrayColor];
        _searchBar.placeholder = placeholder;
        _searchBar.delegate = self;
        [self addSubview:_searchBar];
        
        _associates = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (id)initWithPlaceholder:(NSString *)placeholder
{
    return [self initWithPlaceholder:placeholder delegate:nil];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    [self performSelector:@selector(reloadHistories) withObject:nil afterDelay:0.2];
    
    self.frame = view.bounds;
    [_tableView setFrame:CGRectMake(0, 44.f, self.width, self.height-44.f)];
    
    if ( animated )
	{
		CATransition *transition = [CATransition animation];
		[transition setDuration:0.3f];
		[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
		[transition setType:kCATransitionFade];
		[transition setSubtype:kCATransitionFromTop];
		[self.layer addAnimation:transition forKey:nil];
	}
    
	[view addSubview:self];
    [_searchBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.2];
}

- (void)dismissWithAnimated:(BOOL)animated
{
    if ( animated )
	{
		CATransition * transition = [CATransition animation];
		[transition setDuration:0.3f];
		[transition setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear]];
        [transition setType:kCATransitionFade];
		[transition setSubtype:kCATransitionFromBottom];
		[self.layer addAnimation:transition forKey:nil];
	}
	
	[self removeFromSuperview];
}


#pragma mark -
#pragma mark private methods

- (void)reloadHistories
{
    [_associates removeAllObjects];
    [_associates addObjectsFromArray:[[CacheDBHelper sharedInstance] queryHistoriesAt:self.his_mode]];
    [_tableView reloadData];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _associates.count;
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
    
    NSString *text = nil;
    if ( self.his_mode == HISTORY_MODE_STATION ) {
        LKStation *station = _associates[indexPath.row];
        text = station.st_name;
    } else if ( self.his_mode == HISTORY_MODE_ROUTE ) {
        LKRoute *route = _associates[indexPath.row];
        text = [NSString stringWithFormat:@"%@(%@-%@)", route.line_name, route.st_start, route.st_end];
    }
    
    cell.textLabel.text = text;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
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
    
    if ( self.his_mode == HISTORY_MODE_STATION ) {
        LKStation *station = _associates[indexPath.row];
        [[CacheDBHelper sharedInstance] insertIntoHistories:station.st_id at:HISTORY_MODE_STATION];
    } else if ( self.his_mode == HISTORY_MODE_ROUTE ) {
        LKRoute *route = _associates[indexPath.row];
        [[CacheDBHelper sharedInstance] insertIntoHistories:route.line_id at:HISTORY_MODE_ROUTE addtion:route.ud_type];
    }
    
    if ( [_delegate respondsToSelector:@selector(searchPopoups:didSelectWithData:)] ) {
        [_delegate searchPopoups:self didSelectWithData:_associates[indexPath.row]];
    }
    [self dismissWithAnimated:YES];
}


#pragma mark -
#pragma mark scroll view deleagte

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}


#pragma mark -
#pragma mark search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self dismissWithAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_associates removeAllObjects];
    
    if ( self.his_mode == HISTORY_MODE_STATION ) {
        [_associates addObjectsFromArray:[[BUSDBHelper sharedInstance] blurredQueryStations:searchText]];
    } else if ( self.his_mode == HISTORY_MODE_ROUTE ) {
        [_associates addObjectsFromArray:[[BUSDBHelper sharedInstance] blurredQueryRoutes:searchText]];
    }
    
    [_tableView reloadData];
}

@end
