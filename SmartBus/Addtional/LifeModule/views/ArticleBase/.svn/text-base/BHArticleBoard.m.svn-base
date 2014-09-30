//
//  BHArticleBoard.m
//  SmartBus
//
//  Created by launching on 13-11-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "BHArticleBoard.h"
#import "ArticleHeaderView.h"
#import "JNPhotoTextCell.h"
#import "XHImageViewer.h"
#import "BHArticleModel.h"

@interface BHArticleBoard ()<UITableViewDataSource, UITableViewDelegate, JNPhotoTextCellDelegate>
{
    BeeUITableView *_tableView;
    BHArticleModel *article;
    NSMutableArray *arrayImages;
}
@end

@implementation BHArticleBoard

- (void)load
{
    arrayImages = [[NSMutableArray alloc] initWithCapacity:0];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(article);
    SAFE_RELEASE(arrayImages);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_life.png"] title:@"南京生活"];
        
        _tableView = [[BeeUITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.beeView addSubview:_tableView];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_tableView);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        [_tableView setFrame:self.beeView.bounds];
	}
}


#pragma mark -
#pragma mark public methods

- (void)reloadDataSource:(id)dataSource
{
    SAFE_RELEASE(article);
    article = [(BHArticleModel *)dataSource retain];
    
    for (BHAttachModel *attach in article.attachs)
    {
        if ( [attach.category is:@"img"] || [attach.category is:@"image"] ) {
            [arrayImages addObject:attach.link];
        }
    }
    
    [_tableView reloadData];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
            numberOfRows = 1;
            break;
        case 1:
            numberOfRows = [article countOfAttachs];
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *identifier = @"section0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            
            ArticleHeaderView *header = [[ArticleHeaderView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 100.f)];
            [cell.contentView addSubview:header];
            [header release];
        }
        
        ArticleHeaderView *header = (ArticleHeaderView *)[cell.contentView.subviews objectAtIndex:0];
        [header setArticleBase:article.base];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString *identifier = @"section1";
        JNPhotoTextCell *cell = (JNPhotoTextCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[JNPhotoTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.delegate = self;
        }
        [cell setAttach:[article attachAtIndex:indexPath.row]];
        return cell;
    }
    
    return nil;
}


#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        return [article heightOfSubject];
    } else {
        return [(BHAttachModel *)[article attachAtIndex:indexPath.row] size].height + 20;
    }
}


#pragma mark - JNPhotoTextCellDelegate

- (void)photoTextCell:(UITableViewCell *)cell didPlayVideoURL:(NSString *)videoURL
{
    NSURL *movieURL = [NSURL URLWithString:videoURL];
    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    [moviePlayer.moviePlayer setMovieSourceType:MPMovieSourceTypeUnknown];
    [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    [moviePlayer.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    [moviePlayer.moviePlayer setFullscreen:YES animated:YES];
    [self.navigationController presentMoviePlayerViewControllerAnimated:moviePlayer];
    [moviePlayer release];
}

- (void)photoTextCell:(UITableViewCell *)cell didSelectImageView:(UIImageView *)view
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    [imageViewer showWithImageViews:[NSArray arrayWithObject:view] selectedView:view];
    [imageViewer release];
}

@end
