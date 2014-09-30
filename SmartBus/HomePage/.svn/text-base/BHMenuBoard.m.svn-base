//
//  BHMenuBoard.m
//  SmartBus
//
//  Created by launching on 13-9-26.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "UIButton+WebCache.h"
#import "BHMenuBoard.h"
#import "BHBoardDefines.h"
#import "BHAnnouceHelper.h"
#import "BHMsgHelper.h"
#import "BHMenuCell.h"
#import "UILabelExt.h"
#import "BHBadgeView.h"
#import "BHDefines.h"

@interface BHMenuBoard ()<UITableViewDataSource, UITableViewDelegate>
{
    BeeUITableView *_tableView;
    UIImageView *_profileImageBar;
    BHBadgeView *_badgeView;
    UIView *_annouceView;
    
    NSMutableArray *_dataSources;
    BHAnnouceHelper *_noticeHelper;
    BHMsgHelper *_msgHelper;
}
- (void)loadDataSource;
- (void)addProfileImageBarInto:(BeeUITableView *)tableView;
- (void)reloadUserData:(BHUserModel *)user;
- (void)addAnnouceView;
- (void)reloadAnnouce:(NSString *)anno;
@end

#define kMenuHeaderHeight    95.f
#define kMenuBulletHeight    50.f

@implementation BHMenuBoard

- (void)load
{
    _noticeHelper = [[BHAnnouceHelper alloc] init];
    [_noticeHelper addObserver:self];
    _msgHelper = [[BHMsgHelper alloc] init];
    [_msgHelper addObserver:self];
    _dataSources = [[NSMutableArray alloc] initWithCapacity:0];
    [self observeNotification:BHSettingBoard.LOGOUT];
    [super load];
}

- (void)unload
{
    [self unobserveAllNotifications];
    [_noticeHelper removeObserver:self];
    [_msgHelper removeObserver:self];
    SAFE_RELEASE(_noticeHelper);
    SAFE_RELEASE(_msgHelper);
    SAFE_RELEASE(_dataSources);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.view.backgroundColor = [UIColor flatBlackColor];
		[self hideNavigationBarAnimated:NO];
        
        _tableView = [BeeUITableView new];
        _tableView.backgroundColor = [UIColor clearColor];
		_tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
		[self.view addSubview:_tableView];
        
        // 加入个人信息
        [self addProfileImageBarInto:_tableView];
        
        // 加入公告栏
        [self addAnnouceView];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW(_tableView);
        SAFE_RELEASE_SUBVIEW(_badgeView);
        SAFE_RELEASE_SUBVIEW(_profileImageBar);
        SAFE_RELEASE_SUBVIEW(_annouceView);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        CGRect rc = self.viewBound;
        rc.size.height = self.viewBound.size.height - kMenuBulletHeight;
		_tableView.frame = rc;
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [self loadDataSource];
        
        // 最新公告接口
        [_noticeHelper getNewNotice];
	}
	else if ( [signal is:BeeUIBoard.FREE_DATAS] )
	{
		SAFE_RELEASE(_dataSources);
	}
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
		if ( [BHUserModel sharedInstance].uid > 0 )
        {
            // 获取新消息个数
            [_msgHelper performSelector:@selector(getNewMessage) withObject:nil afterDelay:0.5];
            [self reloadUserData:[BHUserModel sharedInstance]];
        }
	}
}

ON_NOTIFICATION2( BHSettingBoard, notification )
{
    if ( [notification is:BHSettingBoard.LOGOUT] )
    {
        [self reloadUserData:nil];
        _badgeView.hidden = YES;
        
        BeeUIBoard *board = [BHAPP boardAtIndex:0];
        if (board)
        {
            BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
            [[BHAPP reveal] setFrontViewController:stack];
            [[BHAPP reveal] showViewController:[BHAPP reveal].frontViewController];
        }
    }
}


#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.succeed )
	{
        if ( [request.userInfo is:@"newNotice"] )
        {
            BHAnnouceModel *annouce = [_noticeHelper.nodes objectAtIndex:0];
            [self reloadAnnouce:annouce.title];
            [_noticeHelper performSelector:@selector(getNewNotice) withObject:nil afterDelay:600];
        }
        else if ( [request.userInfo is:@"getNewMessage"] )
        {
            if ( _msgHelper.newnum > 0 )
            {
                _badgeView.hidden = NO;
                [_badgeView setBadgeNumber:_msgHelper.newnum];
            }
            else
            {
                _badgeView.hidden = YES;
            }
        }
	}
}


#pragma mark - private methods

- (void)loadDataSource
{
    NSArray *datas = @[@"首页", @"实时公交", @"圈子&动态", @"手机电视", @"南京城事", @"系统设置"];
    NSArray *images = @[@"home", @"search", @"trends", @"tv", @"life", @"setting"];
    for (int i = 0; i < datas.count; i++)
    {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:datas[i] forKey:images[i]];
        [_dataSources addObject:dictionary];
    }
}

- (void)addProfileImageBarInto:(BeeUITableView *)tableView
{
    _profileImageBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_bg.png"]];
    _profileImageBar.frame = CGRectMake(0.f, -kMenuHeaderHeight, 320.f, kMenuHeaderHeight);
    _profileImageBar.userInteractionEnabled = YES;
    
    UIButton *avatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    avatorButton.frame = CGRectMake(15.f, 36.f, 50.f, 50.f);
    avatorButton.layer.masksToBounds = YES;
    avatorButton.layer.cornerRadius = 8.f;
    [avatorButton setImage:[UIImage imageNamed:@"default_man.png"] forState:UIControlStateNormal];
    [avatorButton addTarget:self action:@selector(avatorAction:) forControlEvents:UIControlEventTouchUpInside];
    [_profileImageBar addSubview:avatorButton];
    
    UILabelExt *unameLabel = [[UILabelExt alloc] initWithFrame:CGRectMake(74.f, 66.f, 100.f, 20.f)];
    unameLabel.backgroundColor = [UIColor clearColor];
    unameLabel.font = BOLD_FONT_SIZE(15);
    unameLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    unameLabel.textColor = [UIColor whiteColor];
    [_profileImageBar addSubview:unameLabel];
    [unameLabel release];
    
    UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(174.f, 72.f, 14.f, 14.f)];
    [_profileImageBar addSubview:sexImageView];
    [sexImageView release];
    
    _badgeView = [[BHBadgeView alloc] initWithFrame:CGRectMake(55.f, 28.f, 18.f, 18.f)];
    _badgeView.badgeColor = [UIColor redColor];
    _badgeView.fontSize = 11;
    _badgeView.hidden = YES;
    [_profileImageBar addSubview:_badgeView];
    
    [tableView setEdgeInsets:UIEdgeInsetsMake(kMenuHeaderHeight-y_offset, 0., 0., 0.)];
    [tableView addSubview:_profileImageBar];
}

- (void)reloadUserData:(BHUserModel *)user
{
    UIButton *avatorButton = (UIButton *)[_profileImageBar.subviews objectAtIndex:0];
    if ( user && user.avator )
    {
        [avatorButton setImageWithURL:[NSURL URLWithString:user.avator]
                     placeholderImage:[UIImage imageNamed:@"default_man.png"]];
    }
    else
    {
        [avatorButton setImage:[UIImage imageNamed:@"default_man.png"] forState:UIControlStateNormal];
    }
    
    //NSString *uname = user ? user.uname : @"点击头像登录";
    CGSize size = [user.uname sizeWithFont:BOLD_FONT_SIZE(15) byWidth:100.f];
    UILabel *unameLabel = (UILabel *)[_profileImageBar.subviews objectAtIndex:1];
    unameLabel.text = user.uname;
    [unameLabel setFrame:CGRectMake(74.f, 66.f, size.width, 20.f)];
    
    UIImageView *sexImageView = (UIImageView *)[_profileImageBar.subviews objectAtIndex:2];
    [sexImageView setFrame:CGRectMake(80.f+size.width, 68.f, 16.f, 16.f)];
    if ( !user || user.ugender == 0 )
    {
        sexImageView.image = nil;
    }
    else
    {
        sexImageView.image = [UIImage imageNamed: user.ugender == 1 ? @"icon_male.png" : @"icon_female.png"];
    }
}

- (void)addAnnouceView
{
    _annouceView = [[UIView alloc] initWithFrame:CGRectMake(0.f, self.viewBound.size.height-kMenuBulletHeight+y_offset, 320.f, kMenuBulletHeight)];
    _annouceView.backgroundColor = [UIColor fromHexValue:0x262626];
    
    UIImageView *iImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_annouce.png"]];
    iImageView.frame = CGRectMake(15.f, 0.f, 30.f, 41.f);
    [_annouceView addSubview:iImageView];
    [iImageView release];
    
    UILabel *annouceLabel = [[UILabel alloc] initWithFrame:CGRectMake(53.f, 6.f, 155.f, kMenuBulletHeight-12.f)];
    annouceLabel.backgroundColor = [UIColor clearColor];
    annouceLabel.font = FONT_SIZE(13);
    annouceLabel.textColor = [UIColor whiteColor];
    annouceLabel.numberOfLines = 0;
    [_annouceView addSubview:annouceLabel];
    [annouceLabel release];
    
    [self.view addSubview:_annouceView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(annouceAction:)];
    [_annouceView addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)reloadAnnouce:(NSString *)anno
{
    UILabel *annouceLabel = (UILabel *)[_annouceView.subviews objectAtIndex:1];
    [annouceLabel setText:anno];
}


#pragma mark -
#pragma mark button events

- (void)annouceAction:(UITapGestureRecognizer *)recognizer
{
    BHAnnouceBoard *board = [BHAnnouceBoard board];
    BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
    [[BHAPP reveal] setFrontViewController:stack];
    [[BHAPP reveal] showViewController:[BHAPP reveal].frontViewController];
}

- (void)avatorAction:(id)sender
{
    if ( [BHUserModel sharedInstance].uid > 0 )
    {
        BHUserBoard *userBoard = [BHUserBoard board];
        userBoard.targetUserId = [BHUserModel sharedInstance].uid;
        BeeUIStack *userStack = [BeeUIStack stackWithFirstBoard:userBoard];
        [[BHAPP reveal] setFrontViewController:userStack];
        [[BHAPP reveal] showViewController:[BHAPP reveal].frontViewController];
    }
    else
    {
        BHLoginBoard *board = [BHLoginBoard board];
        BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
        [self presentViewController:stack animated:YES completion:nil];
    }
}


#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    BHMenuCell *cell = (BHMenuCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[BHMenuCell alloc] initWithReuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    
    NSDictionary *dictionary = _dataSources[indexPath.row];
    NSString *title = [dictionary allValues][0];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%@.png", [dictionary allKeys][0]]];
    [cell setMenuCellTitle:title andImage:image];
    
    return cell;
}


#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMenuCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击设置时,如果用户没有登录先登录
    if ( (indexPath.row == _dataSources.count - 1) && [BHUserModel sharedInstance].uid <= 0 )
    {
        BHLoginBoard *board = [BHLoginBoard board];
        BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
        [self presentViewController:stack animated:YES completion:nil];
    }
    
    BeeUIBoard *board = [BHAPP boardAtIndex:indexPath.row];
    
    if (board)
    {
        BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
        [[BHAPP reveal] setFrontViewController:stack];
        [[BHAPP reveal] showViewController:[BHAPP reveal].frontViewController];
    }
}

@end
