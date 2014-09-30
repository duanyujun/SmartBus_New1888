//
//  BHPhotoPickerPreviewer.m
//  SmartBus
//
//  Created by launching on 13-11-1.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPhotoPickerPreviewer.h"

@interface BHPhotoPickerPreviewer ()
- (UIImagePickerController *)imagePicker;
- (void)showWithCamera;
- (void)showWithPhotoLibrary;
@end

@implementation BHPhotoPickerPreviewer

- (void)dealloc {
    [imagePicker release], imagePicker = nil;
    _delegate = nil;
    [super dealloc];
}

- (id)initWithDelegate:(id)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}


- (void)show {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"我要拍一下"
                                                        otherButtonTitles:@"本地媒体库", nil];
        
        if ([_delegate respondsToSelector:@selector(view)]) {
            [actionSheet showInView:[_delegate view]];
        }
    } else {
        [self showWithPhotoLibrary];
    }
}

- (void)showImagePicker {
    if ([_delegate respondsToSelector:@selector(presentModalViewController:animated:)]) {
        [_delegate presentModalViewController:imagePicker animated:YES];
    }
}

- (void)showWithCamera {
    [[self imagePicker] setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self showImagePicker];
}

- (void)showWithPhotoLibrary {
    [[self imagePicker] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self showImagePicker];
}

- (UIImagePickerController *)imagePicker {
    if (imagePicker) {
        return imagePicker;
    }
    
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:NO];
    return imagePicker;
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *newImage = image;
    if (image.size.width > 2000 || image.size.height > 2000) {
        CGSize newSize = CGSizeMake(image.size.width / 4, image.size.height / 4);
        newImage = [image resize:newSize];
    }
    
    if ([_delegate respondsToSelector:@selector(photoPickerPreviewer:didFinishPickingWithImage:)]) {
        [_delegate photoPickerPreviewer:self didFinishPickingWithImage:newImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self showWithCamera];
            break;
        case 1:
            [self showWithPhotoLibrary];
            break;
        case 2:
            break;
        default:
            break;
    }
}

@end
