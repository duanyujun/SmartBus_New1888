//
//  JNPhotoTextCell.h
//  JstvNews
//
//  Created by kukuasir on 13-6-22.
//  Copyright (c) 2013年 kukuasir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SETextHelper.h"

@class BHAttachModel;

@protocol JNPhotoTextCellDelegate <NSObject>
@optional
- (void)photoTextCell:(UITableViewCell *)cell didPlayVideoURL:(NSString *)videoURL;
- (void)photoTextCell:(UITableViewCell *)cell didSelectImageView:(UIImageView *)view;
@end

@interface JNPhotoTextCell : UITableViewCell {
@private
    SETextView *_textView;
    UIControl *_imageViewContainer;
    UIImageView *_imageView;
    UIImageView *_playImageView;
    BHAttachModel *_attach;
}

@property (nonatomic, assign) id<JNPhotoTextCellDelegate> delegate;

- (void)setAttach:(id)attach;

@end
