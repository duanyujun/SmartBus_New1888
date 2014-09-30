//
//  BHPhotoCell.m
//  SmartBus
//
//  Created by launching on 13-11-13.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPhotoCell.h"
#import "UIImageView+WebCache.h"

@interface BHPhotoCell ()
{
    UIImageView *bubbleImageView;
    UILabel *timeLabel;
    UIView *imageContainer;
}
@end

#define kPhotoBtnBaseTag  89421

@implementation BHPhotoCell

@synthesize photo = _photo;
@synthesize imageViews = _imageViews;
@synthesize delegate = _delegate;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(bubbleImageView);
    SAFE_RELEASE_SUBVIEW(timeLabel);
    SAFE_RELEASE_SUBVIEW(imageContainer);
    SAFE_RELEASE(_photo);
    SAFE_RELEASE(_imageViews);
    _delegate = nil;
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)]];
        bubbleImageView.frame = CGRectMake(10.f, 0.f, 300.f, 60.f);
        [self.contentView addSubview:bubbleImageView];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 0.f, 200.f, 30.f)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont boldSystemFontOfSize:16];//[UIFont fontWithName:@"SnellRoundhand-Black" size:16];
        timeLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:timeLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20.f, 29.f, 280.f, 1.f)];
        line.backgroundColor = [UIColor flatWhiteColor];
        [self.contentView addSubview:line];
        [line release];
        
        imageContainer = [[UIView alloc] initWithFrame:CGRectMake(18.f, 40.f, 284.f, 10.f)];
        imageContainer.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imageContainer];
        
        _imageViews = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)setPhoto:(BHPhotoModel *)photo
{
    SAFE_RELEASE(_photo);
    _photo = [photo retain];
    
    [timeLabel setText:_photo.dtime];
    
    if ( imageContainer.subviews.count > 0 ) {
        [imageContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    }
    [_imageViews removeAllObjects];
    
    // 设置container的大小
    CGRect rc = imageContainer.frame;
    rc.size.height = (ceil((float)_photo.links.count/4) * (65.f + 8.f));
    imageContainer.frame = rc;
    bubbleImageView.frame = CGRectMake(10.f, 0.f, 300.f, imageContainer.frame.size.height+50.f);
    
    for (int i = 0; i < _photo.links.count; i++)
    {
        CGPoint point = CGPointMake((i%4)*(65.f+8.f), floor(i/4)*(65.f+8.f));
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, 65.f, 65.f)];
        imageView.tag = kPhotoBtnBaseTag + i;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        [imageView setImageWithURL:[NSURL URLWithString:_photo.links[i]] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
        [imageContainer addSubview:imageView];
        [_imageViews addObject:imageView];
        
        // add gesture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [imageView addGestureRecognizer:tap];
        [tap release];
        
        [imageView release];
    }
}


- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    if ( [_delegate respondsToSelector:@selector(photoCell:didSelectWithView:)] )
    {
        [_delegate photoCell:self didSelectWithView:(UIImageView *)recognizer.view];
    }
}

@end
