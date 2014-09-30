//
//  BHIDErrorBoard.m
//  SmartBus
//
//  Created by launching on 14-8-1.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHIDErrorBoard.h"
#import "BHTextStyleCell.h"
#import "BHBtnStyleCell.h"
#import "BHPhotoPickerPreviewer.h"
#import "UIImage+Helper.h"
#import "NSDate+Helper.h"

@interface BHIDErrorBoard ()<BHPhotoPickerDelegate, UITextFieldDelegate>
{
    BHPhotoPickerPreviewer *_photoPicker;
    UIImage *_selectedImage;
}
@property (nonatomic, assign) BHPointError error;
@property (nonatomic, assign) BHPointMode mode;
@end

@implementation BHIDErrorBoard

DEF_SIGNAL( SUBMIT );

@synthesize error = __error;

- (id)initWithError:(BHPointError)error mode:(BHPointMode)mode
{
    if ( self = [super init] )
    {
        self.error = error;
        self.mode = mode;
    }
    return self;
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:TTIMAGE(@"icon_warnning") title:@"报错"];
        
        self.beeView.backgroundColor = RGB(237, 237, 242);
        [self.egoTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        BeeUIButton *submitButton = [BeeUIButton new];
        submitButton.frame = CGRectMake(260, 0.f, 60, 44.f);
        submitButton.backgroundColor = [UIColor clearColor];
        submitButton.title = @"提交";
        submitButton.titleColor = [UIColor redColor];
        [submitButton addSignal:self.SUBMIT forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:submitButton];
	}
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:self.SUBMIT] )
    {
        // 获取车牌号码或者车辆ID
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        BHTextStyleCell *cell = (BHTextStyleCell *)[self.egoTableView cellForRowAtIndexPath:indexPath];
        NSString *strNum = [[cell.textField text] asNSString];
        
        if ( strNum.length == 0 )
        {
            NSString *tip = nil;
            if ( self.mode == BHPointModeStation ) {
                tip = @"请填写站台名";
            } else {
                tip = self.error == BHPointErrorStreet ? @"请填写车辆ID" : @"请填写车牌号码";
            }
            [self presentMessageTips:tip];
            return;
        }
        
        // 获取姓名和手机号
        int section = (self.error == BHPointErrorStreet) ? 1 : 2;
        
        indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        cell = (BHTextStyleCell *)[self.egoTableView cellForRowAtIndexPath:indexPath];
        NSString *uname = [cell.textField text] ? [cell.textField text] : @"";
        
        indexPath = [NSIndexPath indexPathForRow:1 inSection:section];
        cell = (BHTextStyleCell *)[self.egoTableView cellForRowAtIndexPath:indexPath];
        NSString *uphone = [cell.textField text] ? [cell.textField text] : @"";
        
        // 开始提交
        [self presentLoadingTips:@"提交中..."];
        
        ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://smartnj.jstv.com/Error/Add"]];
        [request setUploadProgressDelegate:self];
        [request setDelegate:self];
        [request setTimeOutSeconds:40];
        [request setRequestMethod:@"POST"];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        
        NSLog(@"ErrorType :%d", self.error + self.mode);
        [request setPostValue:[NSNumber numberWithInt:self.error+self.mode] forKey:@"ErrorType"];
        [request setPostValue:uname forKey:@"UserName"];
        [request setPostValue:uphone forKey:@"LinkPhone"];
        [request setPostValue:strNum forKey:self.error == BHPointErrorStreet ? @"BusID" : @"BusNo"];
        [request setPostValue:[NSNumber numberWithFloat:[BHUserModel sharedInstance].coordinate.latitude] forKey:@"Lat"];
        [request setPostValue:[NSNumber numberWithFloat:[BHUserModel sharedInstance].coordinate.longitude] forKey:@"Lon"];
        
        if ( _selectedImage )
        {
            [request setFile:UIImageJPEGRepresentation(_selectedImage, 0.5)
                withFileName:[NSString stringWithFormat:@"image%@.png", [NSDate stringFromDate:[NSDate date] withFormat:@"yyyyMMddHHmmss"]]
              andContentType:@"multipart/form-data"
                      forKey:@"file"];
        }
        
        [request setShouldContinueWhenAppEntersBackground:YES];
        [request setDidFinishSelector:@selector(uploadFinished:)];
        [request setDidFailSelector:@selector(uploadFaild:)];
        [request startAsynchronous];
    }
}

- (void)uploadFinished:(ASIHTTPRequest *)theRequest
{
    NSDictionary *result = [theRequest.responseString objectFromJSONString];
    
    [self dismissTips];
    [self presentMessageTips:result[@"Message"]];
    
    BOOL ret = [result[@"Success"] boolValue];
    if ( ret ) {
        [self performSelector:@selector(handleMenu) withObject:nil afterDelay:2];
    }
}

- (void)uploadFaild:(ASIHTTPRequest *)theRequest
{
    [self dismissTips];
    [self presentMessageTips:@"提交失败"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.error == BHPointErrorStreet ? 2 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.error == BHPointErrorStreet ) {
        return section == 0 ? 1 : 2;
    } else {
        return section == 2 ? 2 : 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        NSString *identify0 = @"identify0";
        BHTextStyleCell *cell = (BHTextStyleCell *)[tableView dequeueReusableCellWithIdentifier:identify0];
        if ( !cell ) {
            cell = [[[BHTextStyleCell alloc] initWithReuseIdentifier:identify0] autorelease];
            cell.textField.delegate = self;
        }
        
        if ( self.error == BHPointErrorStreet )
        {
            if ( self.mode == BHPointModeStation ) {
                [cell fillTitle:@"站台名" placeholder:@"请输入站台名"];
            } else {
                [cell fillTitle:@"车辆ID" placeholder:@"请输入ID"];
            }
        }
        else
        {
            if ( self.mode == BHPointModeStation ) {
                [cell fillTitle:@"站台名" placeholder:@"请输入站台名"];
            } else {
                [cell fillTitle:@"车牌号码    苏A-" placeholder:@"请输入数字"];
            }
        }
        
        return cell;
    }
    else if ( indexPath.section == 1 )
    {
        static NSString *identify1 = @"identify1";
        
        BeeUITableViewCell *cell = nil;
        if ( self.error == BHPointErrorStreet )
        {
            cell = [tableView dequeueReusableCellWithIdentifier:identify1];
            if ( !cell ) {
                cell = [[[BHTextStyleCell alloc] initWithReuseIdentifier:identify1] autorelease];
                [[(BHTextStyleCell *)cell textField] setDelegate:self];
            }
            if ( indexPath.row == 0 ) {
                [(BHTextStyleCell *)cell fillTitle:@"用户姓名:" placeholder:nil];
            } else {
                [(BHTextStyleCell *)cell fillTitle:@"联络电话:" placeholder:nil];
            }
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:identify1];
            if ( !cell ) {
                cell = [[[BHBtnStyleCell alloc] initWithReuseIdentifier:identify1] autorelease];
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            [(BHBtnStyleCell *)cell fillImage:_selectedImage];
        }
        
        return cell;
    }
    else if ( indexPath.section == 2 )
    {
        static NSString *identify2 = @"identify2";
        BHTextStyleCell *cell = (BHTextStyleCell *)[tableView dequeueReusableCellWithIdentifier:identify2];
        if ( !cell ) {
            cell = [[[BHTextStyleCell alloc] initWithReuseIdentifier:identify2] autorelease];
            cell.textField.delegate = self;
        }
        if ( indexPath.row == 0 ) {
            [cell fillTitle:@"用户姓名:" placeholder:nil];
        } else {
            [cell fillTitle:@"联络电话:" placeholder:nil];
        }
        return cell;
    }
    
    return nil;
}


#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *footerTitle = nil;
    if ( section == 0 ) {
        footerTitle = (self.error == BHPointErrorStreet) ? @"联系方式" : @"拍照上传";
    } else if ( section == 1 ) {
        footerTitle = (self.error == BHPointErrorStreet) ? @"感谢您为我们提供公交线路的纠错信息, 该信息一旦被我们核实并采纳, 将会为您送上价值30元的公交卡一张, 感谢您对南京公交事业的支持。" : @"联系方式";
    } else if ( section == 2 ) {
        footerTitle = @"感谢您为我们提供公交线路的纠错信息，该信息一旦被我们核实并采纳，将会为您送上价值30元的公交卡一张，感谢您对南京公交事业的支持。";
    }
    
    CGSize size = [footerTitle sizeWithFont:TTFONT_SIZED(15) byWidth:296];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, size.height+16)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 296, size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.font = TTFONT_SIZED(15);
    label.textColor = [UIColor flatBlackColor];
    label.numberOfLines = 0;
    label.text = footerTitle;
    [view addSubview:label];
    [label release];
    
    return [view autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 1 && self.error == BHPointErrorSoftware )
    {
        if ( _selectedImage ) {
            CGSize imageSize = [_selectedImage aspectScaleSize:120];
            return imageSize.height + 48.0;
        } else {
            return 40.0;
        }
    }
    else
    {
        return 40.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( self.error == BHPointErrorSoftware && indexPath.section == 1 )
    {
        if ( !_photoPicker ) {
            _photoPicker = [[BHPhotoPickerPreviewer alloc] initWithDelegate:self];
        }
        [_photoPicker show];
    }
}


#pragma mark - BHPhotoPickerDelegate

- (void)photoPickerPreviewer:(id)previewer didFinishPickingWithImage:(UIImage *)image
{
    SAFE_RELEASE(_selectedImage);
    _selectedImage = [image retain];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.egoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.egoTableView setContentOffset:CGPointZero animated:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    BeeUITableViewCell *cell = (BeeUITableViewCell *)textField.superview.superview;
    if ( ![cell isKindOfClass:[BHTextStyleCell class]] ) {
        cell = (BeeUITableViewCell *)textField.superview.superview.superview;
    }
    
    NSIndexPath *indexPath = [self.egoTableView indexPathForCell:cell];
    
    if ( indexPath.section == 2 )
    {
        if ( _selectedImage ) {
            [self.egoTableView setContentOffset:CGPointMake(0, 160) animated:YES];
        } else {
            [self.egoTableView setContentOffset:CGPointMake(0, 40) animated:YES];
        }
    }
}


@end
