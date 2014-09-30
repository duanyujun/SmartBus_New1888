//
//  BHChannelsPopoup.m
//  SmartBus
//
//  Created by launching on 13-10-22.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHChannelsPopoup.h"

@interface BHChannelsPopoup ()<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *backgroundImageView;
    BeeUITableView *_tableView;
    NSArray *_channels;
}
@end

@implementation BHChannelsPopoup

DEF_SINGLETON( BHChannelsPopoup );

- (void)dealloc
{
    SAFE_RELEASE(_channels);
    SAFE_RELEASE_SUBVIEW(backgroundImageView);
    SAFE_RELEASE_SUBVIEW(_tableView);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame] )
    {
        backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:2.f]];
        backgroundImageView.frame = self.bounds;
        [self addSubview:backgroundImageView];
        
        _tableView = [[BeeUITableView alloc] initWithFrame:self.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
		_tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:_tableView];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0.f, 0.f, 100.f, 0.f)];
}

- (void)setChannels:(NSArray *)channels
{
    SAFE_RELEASE(_channels);
    _channels = [channels retain];
    
    CGRect rc = self.frame;
    rc.size.height = _channels.count * 36.f;
    self.frame = rc;
    backgroundImageView.frame = self.bounds;
    _tableView.frame = self.bounds;
}

- (void)showInView:(UIView *)view atPosition:(CGPoint)point
{
    if ( self.superview == nil )
    {
        CGRect rc = self.frame;
        rc.origin.x = point.x;
        rc.origin.y = point.y;
        self.frame = rc;
        
        CATransition * transition = [CATransition animation];
        [transition setDuration:0.3f];
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [transition setType:kCATransitionFade];
        [transition setSubtype:kCATransitionFromTop];
        [self.layer addAnimation:transition forKey:nil];
        
        [view addSubview:self];
        [view bringSubviewToFront:self];
        [_tableView reloadData];
    }
    else
    {
        [self dismissPopoup];
    }
}

- (void)dismissPopoup
{
    CATransition * transition = [CATransition animation];
    [transition setDuration:0.3f];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear]];
    [transition setType:kCATransitionFade];
    [transition setSubtype:kCATransitionFromBottom];
    [self.layer addAnimation:transition forKey:nil];

    [self removeFromSuperview];
}


#pragma mark -
#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    BeeUITableViewCell *cell = (BeeUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell )
    {
        cell = [[[BeeUITableViewCell alloc] initWithReuseIdentifier:identifier] autorelease];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = FONT_SIZE(15);
        
        if ( indexPath.row < _channels.count - 1 )
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(1.f, 35.f, 98.f, 1.f)];
            line.backgroundColor = [UIColor flatGrayColor];
            [cell.contentView addSubview:line];
            [line release];
        }
    }
    
    cell.textLabel.text = _channels[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissPopoup];
    if ([self.delegate respondsToSelector:@selector(BHChannelsPopoup:selectIndex:)]) {
        [self.delegate BHChannelsPopoup:self selectIndex:indexPath.row];
    }
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36.f;
}


@end
