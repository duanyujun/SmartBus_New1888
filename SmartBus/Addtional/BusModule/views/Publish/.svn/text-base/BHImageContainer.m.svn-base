//
//  BHImageContainer.m
//  SmartBus
//
//  Created by launching on 13-11-1.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHImageContainer.h"

#define kMaxCount       20
#define kDetailWidth    297.f
#define kItemBaseTag    120
#define kDelBtnBaseTag  11
#define kShowBtnBaseTag 12

@interface BHImageContainer ()
{
    UIScrollView *scrollView;
    CGPoint lastPoint;    // 记录最后一张图片存放的位置
    NSMutableArray *views;
}
- (void)addImageView:(CGRect)frame withImage:(UIImage *)image atIndex:(NSInteger)index;
- (void)moveAddViewToRect:(CGRect)rc animated:(BOOL)animated;
- (void)updateDetailViewHeight:(CGFloat)height;
- (void)addTapGestureInView:(UIView *)view;
- (void)addLongPressGestureInView:(UIView *)view;
- (void)showImageAtIndex:(NSInteger)idx;
- (void)deleteImageAtIndex:(NSInteger)idx;
@end

@implementation BHImageContainer

@synthesize images = _images;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(addButton);
    SAFE_RELEASE(_images);
    SAFE_RELEASE(views);
    [super dealloc];
}

- (id)initWithDelegate:(id<ImageContainerDelegate>)delegate
{
    if (self = [super initWithFrame:CGRectMake(0.f, 0.f, 297.f, 112.f)])
    {
        _delegate = delegate;
        
        // 初始化增加按钮及坐标
        addButton = [[UIButton alloc] initWithFrame:CGRectMake(9.f, 10.f, 50.f, 50.f)];
        //[addButton setBackgroundImage:[UIImage imageNamed:@"pic_default.png"] forState:UIControlStateNormal];
        addButton.backgroundColor = [UIColor flatWhiteColor];
        addButton.layer.masksToBounds = YES;
        addButton.layer.cornerRadius = 3.f;
        [addButton setImage:[UIImage imageNamed:@"icon_add_picture.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addButton];
        
        _images = [[NSMutableArray alloc] initWithCapacity:0];
        views = [[NSMutableArray alloc] initWithCapacity:0];
        
        // 初始位置
        lastPoint = CGPointMake(9.f, 10.f);
    }
    return self;
}

- (void)insertImage:(UIImage *)image
{
    [_images addObject:image];
    
    NSInteger index = _images.count - 1;
    
    lastPoint = CGPointMake(9.f+(index%5)*(50.f+8.f), 10.f+floor(index/5)*(50.f+10.f));
    [self addImageView:CGRectMake(lastPoint.x, lastPoint.y, 50.f, 50.f) withImage:image atIndex:index];
    
    // 添加按钮向后移动
    CGRect rc = CGRectMake(9.f+(_images.count%5)*(50.f+8.f), 10.f+floor(_images.count/5)*(50.f+10.f), 50.f, 50.f);
    [self moveAddViewToRect:rc animated:YES];
    
    if ([_images count] >= kMaxCount) {
        [addButton removeFromSuperview];
        [self updateDetailViewHeight:floor(index/5)*(50.f+10.f)+50.f];
    } else {
        [self updateDetailViewHeight:floor(_images.count/5)*(50.f+10.f)+50.f];
    }
}

- (void)removeImageAtIndex:(NSInteger)index
{
    UIView *itemView = [self viewWithTag:kItemBaseTag + index];
    __block CGRect lastFrame = itemView.frame;
    [itemView removeFromSuperview];
    
    __block CGRect curFrame = CGRectZero;
    for (int i = index + 1; i < [views count]; i++) {
        [UIView animateWithDuration:0.2 animations:^{
            UIView *tempView = [views objectAtIndex:i];
            curFrame = tempView.frame;
            [tempView setFrame:lastFrame];
            lastFrame = curFrame;
            [tempView setTag:kItemBaseTag + i - 1];
        }];
    }
    
    [_images removeObjectAtIndex:index];
    [views removeObjectAtIndex:index];
    
    if ([_images count] < kMaxCount && addButton.superview == nil) {
        [self addSubview:addButton];
    }
    [self moveAddViewToRect:lastFrame animated:YES];
    [self updateDetailViewHeight:floor(_images.count/5)*(50.f+10.f)+50.f];
}


#pragma mark - private methods

- (void)addImageView:(CGRect)frame withImage:(UIImage *)image atIndex:(NSInteger)index
{
    UIView *itemView = [[UIView alloc] initWithFrame:frame];
    itemView.backgroundColor = [UIColor clearColor];
    itemView.tag = kItemBaseTag + index;
    
    UIImageView *elementButton = [[UIImageView alloc] initWithImage:image];
    elementButton.frame = CGRectMake(0.f, 0.f, 50.f, 50.f);
    elementButton.backgroundColor = [UIColor whiteColor];
    elementButton.layer.masksToBounds = YES;
    elementButton.layer.cornerRadius = 3.f;
    elementButton.tag = kShowBtnBaseTag;
    elementButton.contentMode = UIViewContentModeScaleAspectFill;
    [itemView addSubview:elementButton];
    [elementButton release];
    
    // 添加手势
    [self addTapGestureInView:itemView];
    [self addLongPressGestureInView:itemView];
    
    [self addSubview:itemView];
    [views addObject:itemView];
    [itemView release];
}

- (void)moveAddViewToRect:(CGRect)rc animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.2f animations:^{
            [addButton setFrame:rc];
        }];
    } else {
        [addButton setFrame:rc];
    }
}

- (void)updateDetailViewHeight:(CGFloat)height
{
    CGRect rc = self.frame;
    rc.size.height = height + 21.f;
    self.frame = rc;
    
    if ([_delegate respondsToSelector:@selector(imageContainerDidChangeHeight:)]) {
        [_delegate imageContainerDidChangeHeight:rc.size.height];
    }
}

- (void)addTapGestureInView:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [view addGestureRecognizer:tap];
    [tap release];
}

- (void)addLongPressGestureInView:(UIView *)view
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [view addGestureRecognizer:longPress];
    [longPress release];
}

- (void)showImageAtIndex:(NSInteger)idx
{
    if ([_delegate respondsToSelector:@selector(popoverDetails:didShowImage:)])
    {
        NSString *path = [_images objectAtIndex:idx];
        NSData *imageData = [NSData dataWithContentsOfFile:path];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [_delegate imageContainer:self didShowImage:image];
        [image release];
    }
}

- (void)deleteImageAtIndex:(NSInteger)idx
{
    [self removeImageAtIndex:idx];
}


#pragma mark - button events

- (void)addAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(imageContainerDidInsertImage:)]) {
        [_delegate imageContainerDidInsertImage:self];
    }
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    UIView *view = recognizer.view;
    NSInteger idx = view.tag - kItemBaseTag;
    [self showImageAtIndex:idx];
}

- (void)longPressed:(UILongPressGestureRecognizer *)recognizer
{
    UIView *view = recognizer.view;
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(30.f, 0.f, 20.f, 20.f);
    deleteButton.tag = view.tag;
    [deleteButton setImage:[UIImage imageNamed:@"disclose_close.png"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteButton];
}

- (void)deleteAction:(UIButton *)sender
{
    [self deleteImageAtIndex:sender.tag - kItemBaseTag];
}


@end
