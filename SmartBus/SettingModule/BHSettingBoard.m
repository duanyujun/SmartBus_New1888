//
//  BHSettingBoard.m
//  SmartBus
//
//  Created by launching on 13-9-30.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSettingBoard.h"
#import "BHPrivacyBoard.h"
#import "BHFavoriteBoard.h"
#import "BHSocialBindBoard.h"
#import "BHModifyPwdBoard.h"
#import "BHTipsBoard.h"
#import "BHFeedbackBoard.h"
#import "BHAboutBoard.h"
#import "BHOfflineBoard.h"
#import "BHLaunchModel.h"

@interface BHSettingBoard () <UITableViewDataSource, UITableViewDelegate>
{
    BeeUITableView *_tableView;
    NSArray *_dataArray;
    NSArray *_imageArray;
}
@end

#define kLoginBtnTag   991

@implementation BHSettingBoard

DEF_NOTIFICATION( LOGOUT );

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        
        [self indicateIsFirstBoard:YES image:[UIImage imageNamed:@"nav_setting.png"] title:@"设置"];
        
        _tableView = [BeeUITableView new];
        _tableView.backgroundColor = [UIColor clearColor];
		_tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.beeView addSubview:_tableView];
        
//        BeeUIButton *clearButton = [BeeUIButton new];
//        clearButton.frame = CGRectMake(250.f, 7.f, 60.f, 30.f);
//        clearButton.layer.masksToBounds = YES;
//        clearButton.layer.cornerRadius = 3.f;
//        clearButton.backgroundColor = [UIColor flatDarkRedColor];
//        clearButton.title = @"清除缓存";
//        clearButton.titleFont = [UIFont systemFontOfSize:12];
//        [clearButton addSignal:@"clear" forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationBar addSubview:clearButton];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_tableView);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_tableView.frame = self.beeView.bounds;
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [self loadDataSource];
	}
	else if ( [signal is:BeeUIBoard.FREE_DATAS] )
	{
        SAFE_RELEASE(_imageArray);
        SAFE_RELEASE(_dataArray);
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
        [_tableView reloadData];
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:@"logout"] )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"确定退出当前账户？"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:@"取消", nil];
        [alertView show];
    }
    else if ( [signal is:@"clear"] )
    {
        [BHUtil clearDBCache];
        [self performSelector:@selector(clearImageCache) withObject:nil afterDelay:0.2];
        //[[ZipArchiveHandler sharedInstance] handleWithURLString:[BHLaunchModel sharedInstance].zip];
        [self presentMessageTips:@"清除成功"];
    }
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [BHUtil saveUserID:0];
        [BHUserModel sharedInstance].uid = 0;
        [self postNotification:self.LOGOUT];
    }
}


#pragma mark - 
#pragma mark private methods

- (void)loadDataSource
{
    NSArray *dataArray1 = [[NSArray alloc] initWithObjects:@"我的收藏", nil];
    NSArray *dataArray2 = [[NSArray alloc] initWithObjects:@"离线地图", nil];
    NSArray *dataArray3 = [[NSArray alloc] initWithObjects:@"隐私设置", nil];
    NSArray *dataArray4 = [[NSArray alloc] initWithObjects:@"社交绑定", nil];
    NSArray *dataArray5 = [[NSArray alloc] initWithObjects:@"修改密码", nil];
    NSArray *dataArray6 = [[NSArray alloc] initWithObjects:@"兑换说明", @"用户帮助", @"意见反馈", @"关于", nil];
    NSArray *dataArray7 = [[NSArray alloc] initWithObjects:@"登出", nil];
    
    _dataArray = [[NSArray alloc] initWithObjects:dataArray1, dataArray2, dataArray3, dataArray4, dataArray5, dataArray6, dataArray7, nil];
    
    SAFE_RELEASE(dataArray1);
    SAFE_RELEASE(dataArray2);
    SAFE_RELEASE(dataArray3);
    SAFE_RELEASE(dataArray4);
    SAFE_RELEASE(dataArray5);
    SAFE_RELEASE(dataArray6);
    SAFE_RELEASE(dataArray7);
    
    NSArray *imageArray1 = [[NSArray alloc] initWithObjects:@"icon_my_collection.png", nil];
    NSArray *imageArray2 = [[NSArray alloc] initWithObjects:@"icon_map.png", nil];
    NSArray *imageArray3 = [[NSArray alloc] initWithObjects:@"icon_privacy_settings.png", nil];
    NSArray *imageArray4 = [[NSArray alloc] initWithObjects:@"icon_social_bound.png", nil];
    NSArray *imageArray5 = [[NSArray alloc] initWithObjects:@"icon_modifypsw.png", nil];
    NSArray *imageArray6 = [[NSArray alloc] initWithObjects:@"icon_exchange_instruction.png", @"icon_user_help.png", @"icon_feedback.png", @"icon_about.png", nil];
    NSArray *imageArray7 = [[NSArray alloc] initWithObjects:@"", nil];
    
    _imageArray = [[NSArray alloc] initWithObjects:imageArray1, imageArray2, imageArray3, imageArray4, imageArray5, imageArray6, imageArray7, nil];
    
    SAFE_RELEASE(imageArray1);
    SAFE_RELEASE(imageArray2);
    SAFE_RELEASE(imageArray3);
    SAFE_RELEASE(imageArray4);
    SAFE_RELEASE(imageArray5);
    SAFE_RELEASE(imageArray6);
    SAFE_RELEASE(imageArray7);
}

- (void)clearImageCache
{
    // 清除图片缓存
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:diskCachePath error:nil];
    for (NSString *dirContent in contents) {
        NSString *subpath = [diskCachePath stringByAppendingPathComponent:dirContent];
        [fileManager removeItemAtPath:subpath error:nil];
    }
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *datas = [_dataArray objectAtIndex:section];
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    BeeUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell )
    {
        cell = [[[BeeUITableViewCell alloc] initWithReuseIdentifier:identifier] autorelease];
        
        NSArray *images = [_imageArray objectAtIndex:indexPath.section];
        UIImage *image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
        
        NSArray *titles = [_dataArray objectAtIndex:indexPath.section];
        NSString *title = [titles objectAtIndex:indexPath.row];
        
        if ( indexPath.section == _dataArray.count - 1 )
        {
            BeeUIButton *nextButton = [BeeUIButton new];
            nextButton.frame = CGRectMake(6.f, 4.f, 308.f, 40.f);
            nextButton.layer.cornerRadius = 4.f;
            nextButton.layer.masksToBounds = YES;
            nextButton.title = @"登    出";
            nextButton.backgroundColor = [UIColor flatDarkRedColor];
            [nextButton addSignal:@"logout" forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:nextButton];
        }
        else
        {
            if ( titles.count == 1 )
            {
                UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)]];
                backgroundImageView.frame = CGRectMake(5.f, 0.f, 310.f, 44.f);
                [cell.contentView addSubview:backgroundImageView];
                [backgroundImageView release];
            }
            else if ( titles.count == 2 )
            {
                UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, 0.f, 310.f, 44.f)];
                backgroundImageView.image = [[UIImage imageNamed:(indexPath.row == 0 ? @"bubble_top.png" : @"bubble_bottom.png")] stretchableImageWithLeftCapWidth:5.f topCapHeight:2.f];
                [cell.contentView addSubview:backgroundImageView];
                [backgroundImageView release];
                
                if ( indexPath.row == 0 ) {
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, 43.f, 290.f, 1.f)];
                    line.backgroundColor = [UIColor flatGrayColor];
                    [cell.contentView addSubview:line];
                    [line release];
                }
            }
            else
            {
                NSString *imageName = nil;
                if ( indexPath.row == 0 ) {
                    imageName = @"bubble_top.png";
                } else if ( indexPath.row == titles.count - 1 ) {
                    imageName = @"bubble_bottom.png";
                } else {
                    imageName = @"bubble_middle.png";
                }
                
                UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, 0.f, 310.f, 44.f)];
                backgroundImageView.image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:5.f topCapHeight:2.f];
                [cell.contentView addSubview:backgroundImageView];
                [backgroundImageView release];
                
                if ( indexPath.row < titles.count - 1 )
                {
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, 43.f, 290.f, 1.f)];
                    line.backgroundColor = [UIColor flatGrayColor];
                    [cell.contentView addSubview:line];
                    [line release];
                }
            }
            
            UIImageView *iconImageView = [[UIImageView alloc] initWithImage:image];
            iconImageView.frame = CGRectMake(15.f, 12.f, 20.f, 20.f);
            [cell.contentView addSubview:iconImageView];
            [iconImageView release];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.f, 8.f, 100.f, 30.f)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = [UIColor flatBlackColor];
            titleLabel.font = FONT_SIZE(15);
            titleLabel.text = title;
            [cell.contentView addSubview:titleLabel];
            [titleLabel release];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 5.f : 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 5.f)];
    view.backgroundColor = [UIColor clearColor];
    return [view autorelease];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 300.f, 5.f)];
    view.backgroundColor = [UIColor clearColor];
    return [view autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    BeeUIBoard *board = nil;
    if ( indexPath.section == 0 )
    {
        board = [BHFavoriteBoard board];
    }
    else if ( indexPath.section == 1 )
    {
        // TODO:
        board = [BHOfflineBoard board];
    }
    else if ( indexPath.section == 2 )
    {
        board = [BHPrivacyBoard board];
    }
    else if ( indexPath.section == 3 )
    {
        board = [BHSocialBindBoard board];
    }
    else if ( indexPath.section == 4 )
    {
        board = [BHModifyPwdBoard board];
        [(BHModifyPwdBoard *)board setUphone:[BHUserModel sharedInstance].uphone];
    }
    else if ( indexPath.section == 5 )
    {
        switch ( indexPath.row ) {
            case 0:
                board = [BHTipsBoard board];
                [(BHTipsBoard *)board setTipsMode:TIPS_MODE_EXPLAIN];
                break;
            case 1:
                board = [BHTipsBoard board];
                [(BHTipsBoard *)board setTipsMode:TIPS_MODE_HELP];
                break;
            case 2:
                board = [BHFeedbackBoard board];
                break;
            case 3:
                board = [BHAboutBoard board];
                break;
            default:
                break;
        }
    }
    [self.stack pushBoard:board animated:YES];
}

@end
