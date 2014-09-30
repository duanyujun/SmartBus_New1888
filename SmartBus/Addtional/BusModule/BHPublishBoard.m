//
//  BHPublishBoard.m
//  SmartBus
//
//  Created by launching on 13-10-31.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPublishBoard.h"
#import "BHPhotoPickerPreviewer.h"
#import "BHImageContainer.h"
#import "BHTrendsHelper.h"
#import "BHWeiboHelper.h"
#import "MALocationHelper.h"

@interface BHPublishBoard ()<UIAlertViewDelegate, MALocationDelegate, BHPhotoPickerDelegate, ImageContainerDelegate, BHWeiboHelperDelegate>
{
    UIImageView *bubbleImageView;
    BeeUITextView *_textView;
    UIView *_footerToolBar;
    BHImageContainer *_imageContainer;
    UIImageView *_locateView;
    BHPhotoPickerPreviewer *_photoPicker;
    
    BHTrendsHelper *_postsHelper;
    BHWeiboHelper *_weiboHelper;
    MALocationHelper *_locationHelper;
    NSInteger _imageIndex;
    
}
- (void)dismiss;
- (void)addBackgroundView;
- (void)addTextView;
- (void)addPhotosBar;
- (void)addLocateControl;
- (void)addShareControl;
@end

#define kAddImageBtnTag   120121
#define kPublicBtnTag     120122
#define kToggleLabelTag   120123
#define kLocateLabelTag   120124
#define kSinaBtnTag       120125
#define kTencentBtnTag    120126

@implementation BHPublishBoard

DEF_SIGNAL( PUBLISH );
DEF_SIGNAL( TOGGLE_PUBLIC );

- (void)load
{
    _postsHelper = [[BHTrendsHelper alloc] init];
    [_postsHelper addObserver:self];
    
    _weiboHelper = [[BHWeiboHelper alloc] initWithTarget:self];
    
    _locationHelper = [[MALocationHelper alloc] initWithDelegate:self];
    _locationHelper.usingReGeocode = YES;
    
    [super load];
}

- (void)unload
{
    [_postsHelper removeObserver:self];
    SAFE_RELEASE(_postsHelper);
    SAFE_RELEASE(_weiboHelper);
    [super unload];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_station.png"] title:@"发布动态"];
        
        BeeUIButton *certainButton = [BeeUIButton new];
        certainButton.frame = CGRectMake(280.f, 2.f, 40.f, 40.f);
        certainButton.image = [UIImage imageNamed:@"icon_certain.png"];
        [certainButton addSignal:BHPublishBoard.PUBLISH forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:certainButton];
        
        [self addBackgroundView];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(bubbleImageView);
        SAFE_RELEASE_SUBVIEW(_textView);
        SAFE_RELEASE_SUBVIEW(_footerToolBar);
        SAFE_RELEASE_SUBVIEW(_imageContainer);
        SAFE_RELEASE_SUBVIEW(_locateView);
        SAFE_RELEASE(_photoPicker);
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:BHPublishBoard.PUBLISH] )
    {
        if ( (!_textView.text || _textView.text.length == 0) && _imageContainer.images.count == 0 ) {
            return;
        }
        
        [_textView resignFirstResponder];
        
        if ( [BHUserModel sharedInstance].uid <= 0 )
        {
            BHLoginBoard *board = [BHLoginBoard board];
            BeeUIStack *stack = [BeeUIStack stackWithFirstBoard:board];
            [self presentViewController:stack animated:YES completion:nil];
            return;
        }
        
        BeeUILabel *label = (BeeUILabel *)[_locateView viewWithTag:kLocateLabelTag];
        BHTrendsModel *posts = [[BHTrendsModel alloc] init];
        posts.weibaId = self.weibaId;
        posts.user.uid = [BHUserModel sharedInstance].uid;
        posts.content = _textView.text;
        posts.hide = _locateView.hidden;
        posts.coor = [BHUserModel sharedInstance].coordinate;
        posts.address = label.text;
        [_postsHelper publishPosts:posts];
        [posts release];
        
        UIImage *image = _imageContainer.images.count > 0 ? _imageContainer.images[0] : nil;
        if ( [_weiboHelper sinaWeiboIsLoggedIn] )
        {
            [_weiboHelper shareSinaWeibo:_textView.text andImage:image];
        }
        
        if ( [_weiboHelper tcWeiboIsLoggedIn] )
        {
            [_weiboHelper shareTCWeibo:_textView.text andImage:image];
        }
    }
    else if ( [signal is:BHPublishBoard.TOGGLE_PUBLIC] )
    {
        [_textView resignFirstResponder];
        
        BeeUIButton *publicButton = (BeeUIButton *)[_footerToolBar viewWithTag:kPublicBtnTag];
        publicButton.selected = !publicButton.selected;
        BeeUILabel *label = (BeeUILabel *)[publicButton viewWithTag:kToggleLabelTag];
        if ( !publicButton.selected )
        {
            label.text = @"隐藏";
            _locateView.hidden = NO;
        }
        else
        {
            label.text = @"公开";
            _locateView.hidden = YES;
        }
    }
}

ON_SIGNAL2( BeeUITextView, signal )
{
    if ( [signal is:BeeUITextView.RETURN] )
    {
        [_textView resignFirstResponder];
    }
}

- (void)handleWeiboAction:(id)sender
{
    [_textView resignFirstResponder];
    
    if ( [sender tag] == kSinaBtnTag )
    {
        [_weiboHelper logInSinaWeibo];
    }
    else if ( [sender tag] == kTencentBtnTag )
    {
        [_weiboHelper logInTCWeibo];
    }
}

- (void)handleMenu
{
    if ( _imageContainer.images.count > 0 || _textView.text.length > 0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您确定放弃本次编辑吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        [self.stack popBoardAnimated:YES];
    }
}

- (void)uploadImages:(NSArray *)images withGroupId:(NSInteger)gid
{
    _imageIndex = 0;
    
    for (int i = 0 ; i < images.count; i++)
    {
        UIImage *image = [images objectAtIndex:i];
        
        ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:BHDomain]];
        [request setUploadProgressDelegate:self];
        [request setDelegate:self];
        [request setTimeOutSeconds:40];
        [request setRequestMethod:@"POST"];
        [request setShowAccurateProgress:YES];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request setPostValue:@"api" forKey:@"app"];
        [request setPostValue:@"WeiboStatuses" forKey:@"mod"];
        [request setPostValue:@"upload" forKey:@"act"];
        [request setPostValue:[NSNumber numberWithInt:gid] forKey:@"wid"];
        [request setPostValue:[NSNumber numberWithInt:[BHUserModel sharedInstance].uid] forKey:@"mid"];
        [request setPostValue:[BHUtil encrypt:[NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid] method:@"upload"] forKey:@"key"];
        [request setFile:UIImageJPEGRepresentation(image, 0.5) withFileName:@"photo.png" andContentType:@"video/mpeg4" forKey:@"file"];
        [request setShouldContinueWhenAppEntersBackground:YES];
        [request setDidFinishSelector:@selector(uploadFinished:)];
        [request startAsynchronous];
    }
}

- (void)uploadFinished:(ASIHTTPRequest *)theRequest
{
    NSDictionary *result = [theRequest.responseString objectFromJSONString];
    if ( [result[@"message"][@"code"] integerValue] > 0 )
    {
        [self presentMessageTips:result[@"message"][@"text"]];
        //NSLog(@"[EROOR]%@_%@", request.userInfo, result[@"message"][@"text"]);
        return;
    }
    else
    {
        if ( _postsHelper.succeed )
        {
            ++ _imageIndex;
            
            if ( _imageIndex >= _imageContainer.images.count )
            {
                [self dismissTips];
                [self presentMessageTips:@"提交成功"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
            }
        }
        else
        {
            [self dismissTips];
            [self presentMessageTips:@"图片上传失败"];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
        }
    }
}

#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    if ( request.sending )
    {
        if ( [request.userInfo is:@"doPost"] ) {
            [self presentLoadingTips:@"正在提交..."];
        }
    }
    else if ( request.succeed )
	{
        if ( [request.userInfo is:@"doPost"] )
        {
            if ( _postsHelper.succeed )
            {
                if ( _imageContainer.images.count > 0 ) {
                    [self uploadImages:_imageContainer.images withGroupId:_postsHelper.postid];
                } else {
                    [self dismissTips];
                    [self presentMessageTips:@"提交成功"];
                    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
                }
            }
        }
		else if ( [request.userInfo is:@"uploadImage"] )
        {
            if ( _postsHelper.succeed )
            {
                ++ _imageIndex;
                
                if ( _imageIndex >= _imageContainer.images.count )
                {
                    [self dismissTips];
                    [self presentMessageTips:@"提交成功"];
                    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
                }
            }
            else
            {
                [self dismissTips];
                [self presentMessageTips:@"图片上传失败"];
                [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
            }
        }
    }
}


#pragma mark - 
#pragma mark private methods

- (void)dismiss
{
    [self.stack popBoardAnimated:YES];
}

- (void)addBackgroundView
{
    bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:6.f topCapHeight:6.f]];
    bubbleImageView.layer.masksToBounds = YES;
    bubbleImageView.layer.cornerRadius = 4.f;
    bubbleImageView.frame = CGRectMake(10.f, 10.f, 300.f, 260.f);
    bubbleImageView.userInteractionEnabled = YES;
    [self.beeView addSubview:bubbleImageView];
    
    _footerToolBar = [[UIView alloc] initWithFrame:CGRectMake(2.f, 260.f-90.f, 296.f, 88.f)];
    _footerToolBar.backgroundColor = RGB(238.f, 238.f, 238.f);
    [bubbleImageView addSubview:_footerToolBar];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10.f, 43.f, 280.f, 1.f)];
    line.backgroundColor = [UIColor flatGrayColor];
    [_footerToolBar addSubview:line];
    [line release];
    
    [self addTextView];
    [self addPhotosBar];
    [self addLocateControl];
    [self addShareControl];
}

- (void)addTextView
{
    _textView = [[BeeUITextView alloc] initWithFrame:CGRectMake(1.f, 0.f, 298.f, 100.f)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.placeholder = @"说点什么吧...";
    _textView.returnKeyType = UIReturnKeyDone;
    [bubbleImageView addSubview:_textView];
}

- (void)addPhotosBar
{
    _imageContainer = [[BHImageContainer alloc] initWithDelegate:self];
    _imageContainer.frame = CGRectMake(0.f, 100.f, 300.f, 70.f);
    _imageContainer.backgroundColor = [UIColor clearColor];
    [bubbleImageView addSubview:_imageContainer];
}

- (void)addLocateControl
{
    // 定位视图
    _locateView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 8.f, 35.f, 28.f)];
    _locateView.backgroundImage = [[UIImage imageNamed:@"bg_comment.png"] stretchableImageWithLeftCapWidth:14.f topCapHeight:14.f];
    [_footerToolBar addSubview:_locateView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pub_loc.png"]];
    iconImageView.frame = CGRectMake(10.f, 6.5f, 15.f, 15.f);
    [_locateView addSubview:iconImageView];
    [iconImageView release];
    
    BeeUILabel *label = [[BeeUILabel alloc] initWithFrame:CGRectMake(25.f, 6.f, 0.f, 16.f)];
    label.backgroundColor = [UIColor clearColor];
    label.tag = kLocateLabelTag;
    label.font = FONT_SIZE(12);
    label.textColor = [UIColor darkGrayColor];
    [_locateView addSubview:label];
    [label release];
    
    // 公开/隐藏切换按钮
    BeeUIButton *publicButton = [BeeUIButton new];
    publicButton.frame = CGRectMake(230.f, 8.f, 60.f, 28.f);
    publicButton.tag = kPublicBtnTag;
    publicButton.backgroundImage = [[UIImage imageNamed:@"bg_comment.png"] stretchableImageWithLeftCapWidth:14.f topCapHeight:14.f];
    [publicButton addSignal:BHPublishBoard.TOGGLE_PUBLIC forControlEvents:UIControlEventTouchUpInside];
    [_footerToolBar addSubview:publicButton];
    
    iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_public.png"]];
    iconImageView.frame = CGRectMake(10.f, 6.5f, 15.f, 15.f);
    [publicButton addSubview:iconImageView];
    [iconImageView release];
    
    label = [[BeeUILabel alloc] initWithFrame:CGRectMake(25.f, 6.f, 30.f, 16.f)];
    label.backgroundColor = [UIColor clearColor];
    label.tag = kToggleLabelTag;
    label.font = FONT_SIZE(12);
    label.textColor = [UIColor darkGrayColor];
    label.text = @"隐藏";
    [publicButton addSubview:label];
    [label release];
    
    [_locationHelper startLocating];
}

- (void)addShareControl
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 56.f, 60.f, 20.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_SIZE(15);
    label.textColor = [UIColor darkGrayColor];
    label.text = @"同步到";
    [_footerToolBar addSubview:label];
    [label release];
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"bg_comment.png"] stretchableImageWithLeftCapWidth:14.f topCapHeight:14.f];
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaButton.frame = CGRectMake(70.f, 52.f, 35.f, 28.f);
    sinaButton.tag = kSinaBtnTag;
    [sinaButton setImage:[UIImage imageNamed:@"icon_sina_gray.png"] forState:UIControlStateNormal];
    [sinaButton setImage:[UIImage imageNamed:@"icon_sina_active.png"] forState:UIControlStateSelected];
    [sinaButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [sinaButton addTarget:self action:@selector(handleWeiboAction:) forControlEvents:UIControlEventTouchUpInside];
    [_footerToolBar addSubview:sinaButton];
    sinaButton.selected = [_weiboHelper sinaWeiboIsLoggedIn];
    
    UIButton *tencentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tencentButton.frame = CGRectMake(115.f, 52.f, 35.f, 28.f);
    tencentButton.tag = kTencentBtnTag;
    [tencentButton setImage:[UIImage imageNamed:@"icon_tencent_gray.png"] forState:UIControlStateNormal];
    [tencentButton setImage:[UIImage imageNamed:@"icon_tencent_active.png"] forState:UIControlStateSelected];
    [tencentButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [tencentButton addTarget:self action:@selector(handleWeiboAction:) forControlEvents:UIControlEventTouchUpInside];
    [_footerToolBar addSubview:tencentButton];
    tencentButton.selected = [_weiboHelper tcWeiboIsLoggedIn];
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        [self.stack popBoardAnimated:YES];
    }
}


#pragma mark -
#pragma mark MALocationDelegate

- (void)locationHelper:(MALocationHelper *)helper didFinishedReGeocode:(NSString *)address
{
    CGSize size = [address sizeWithFont:FONT_SIZE(12) byWidth:200.f];
    size.width = size.width > 200.f ? 200.f : size.width;
    
    BeeUILabel *label = (BeeUILabel *)[_locateView viewWithTag:kLocateLabelTag];
    label.text = address;
    
    [UIView animateWithDuration:0.35f animations:^{
        label.frame = CGRectMake(25.f, 6.f, size.width+8.f, 16.f);
        _locateView.frame = CGRectMake(10.f, 8.f, size.width+38.f, 28.f);
    }];
}


#pragma mark -
#pragma mark ImageContainerDelegate

- (void)imageContainerDidChangeHeight:(CGFloat)height
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rc = bubbleImageView.frame;
        rc.size.height = 190.f + height;
        bubbleImageView.frame = rc;
        
        rc = _footerToolBar.frame;
        rc.origin.y = 100.f + height;
        _footerToolBar.frame = rc;
    }];
}

- (void)imageContainerDidInsertImage:(UIView *)container
{
    [_textView resignFirstResponder];
    
    if ( !_photoPicker ) {
        _photoPicker = [[BHPhotoPickerPreviewer alloc] initWithDelegate:self];
    }
    [_photoPicker show];
}


#pragma mark -
#pragma mark BHPhotoPickerDelegate

- (void)photoPickerPreviewer:(id)previewer didFinishPickingWithImage:(UIImage *)image
{
    [_imageContainer insertImage:image];
}


#pragma mark -
#pragma mark BHWeiboHelperDelegate

- (void)weiboHelperSinaWeiboLoggedIn:(id)helper
{
    BeeUIButton *sinaButton = (BeeUIButton *)[_footerToolBar viewWithTag:kSinaBtnTag];
    sinaButton.selected = YES;
}

- (void)weiboHelperTCWeiboLoggedIn:(id)helper
{
    BeeUIButton *tencentButton = (BeeUIButton *)[_footerToolBar viewWithTag:kTencentBtnTag];
    tencentButton.selected = YES;
}


@end
