//
//  BHPhotoPickerPreviewer.h
//  SmartBus
//
//  Created by launching on 13-11-1.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BHPhotoPickerDelegate <NSObject>
@optional
- (void)photoPickerPreviewer:(id)previewer didFinishPickingWithImage:(UIImage *)image;
@end

@interface BHPhotoPickerPreviewer : NSObject
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate
>
{
@private
    id _delegate;
    UIImagePickerController *imagePicker;
}

- (id)initWithDelegate:(id<BHPhotoPickerDelegate>)delegate;
- (void)show;

@end
