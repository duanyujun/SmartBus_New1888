//
//  BHImageContainer.h
//  SmartBus
//
//  Created by launching on 13-11-1.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageContainerDelegate <NSObject>
- (void)imageContainerDidChangeHeight:(CGFloat)height;
- (void)imageContainerDidInsertImage:(UIView *)container;
@optional
- (void)imageContainer:(UIView *)container didShowImage:(UIImage *)image;
@end

@interface BHImageContainer : UIView
{
    UIButton *addButton;
    id _delegate;
}

@property (nonatomic, retain) NSMutableArray *images;

- (id)initWithDelegate:(id<ImageContainerDelegate>)delegate;

- (void)insertImage:(UIImage *)image;
- (void)removeImageAtIndex:(NSInteger)index;

@end
