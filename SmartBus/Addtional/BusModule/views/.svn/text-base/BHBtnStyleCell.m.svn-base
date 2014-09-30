//
//  BHBtnStyleCell.m
//  SmartBus
//
//  Created by launching on 14-8-1.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHBtnStyleCell.h"
#import "UIImage+Helper.h"

#define kPhotoViewTag   5514

@implementation BHBtnStyleCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 40, 120, 120)];
        photoView.backgroundColor = [UIColor clearColor];
        photoView.tag = kPhotoViewTag;
        [self.contentView addSubview:photoView];
        [photoView release];
    }
    return self;
}

- (void)fillImage:(UIImage *)image
{
    if ( image )
    {
        CGSize imageSize = [image aspectScaleSize:120];
        UIImageView *photoView = (UIImageView *)[self.contentView viewWithTag:kPhotoViewTag];
        photoView.frame = CGRectMake(12, 40, imageSize.width, imageSize.height);
        [photoView setImage:image];
    }
}

- (CGSize)sizeToImage:(UIImage *)image maxSize:(CGSize)size
{
    CGSize imageSize = CGSizeMake(image.size.width, image.size.height);
	
	CGFloat hScaleFactor = imageSize.width / size.width;
	CGFloat vScaleFactor = imageSize.height / size.height;
	
	CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
	
	CGFloat newWidth = imageSize.width   / scaleFactor;
	CGFloat newHeight = imageSize.height / scaleFactor;
    
    return CGSizeMake(newWidth, newHeight);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.textLabel setFont:TTFONT_BOLD_SIZE(16)];
    [self.textLabel setText:@"添加照片"];
    self.textLabel.frame = CGRectMake(52, 0, 150, 40);
    
    [self.imageView setImage:TTIMAGE(@"icon_camera")];
    self.imageView.frame = CGRectMake(12, 9, 29, 22);
}

@end
