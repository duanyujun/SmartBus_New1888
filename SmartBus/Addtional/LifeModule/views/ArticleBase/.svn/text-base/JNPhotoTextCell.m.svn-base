//
//  JNPhotoTextCell.m
//  JstvNews
//
//  Created by kukuasir on 13-6-22.
//  Copyright (c) 2013年 kukuasir. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JNPhotoTextCell.h"
#import "BHAttachModel.h"
#import "UIImageView+WebCache.h"
#import "BHArticleBoard.h"

#define kPlayButtonTag  12321

@implementation JNPhotoTextCell

@synthesize delegate = _delegate;

- (void)dealloc
{
    SAFE_RELEASE(_attach);
    SAFE_RELEASE_SUBVIEW(_textView);
    SAFE_RELEASE_SUBVIEW(_imageView);
    SAFE_RELEASE_SUBVIEW(_playImageView);
    SAFE_RELEASE_SUBVIEW(_imageViewContainer);
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _textView = [[SETextView alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.editable = NO;
        _textView.selectable = YES;
        _textView.lineSpacing = 8.0;
        [self.contentView addSubview:_textView];
        _textView.alpha = 0;
        
        _imageViewContainer = [[UIControl alloc]initWithFrame:CGRectMake(10, 10, 300, 225)];
        _imageViewContainer.backgroundColor = [UIColor whiteColor];
        _imageViewContainer.layer.cornerRadius = 5.0;
        _imageViewContainer.layer.masksToBounds = YES;
        [_imageViewContainer addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_imageViewContainer];
        
        _imageView = [[UIImageView alloc] initWithFrame:_imageViewContainer.bounds];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.backgroundColor = [UIColor clearColor];
        [_imageViewContainer addSubview:_imageView];
        _imageViewContainer.alpha = 0;
        
        CGSize size = _imageView.frame.size;
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake((size.width-60.f)/2, (size.height-60.f)/2, 60.f, 60.f)];
        [_imageView addSubview:_playImageView];
    }
    return self;
}

- (void)setAttach:(id)attach
{
    SAFE_RELEASE(_attach);
    _attach = [(BHAttachModel *)attach retain];
    
    if ([_attach.category isEqualToString:@"txt"])
    {
        _textView.alpha = 1;
        _imageViewContainer.alpha = 0;
        
        NSAttributedString *attributedString = [[SETextHelper sharedInstance] attributedStringWithText:_attach.text];
        _textView.attributedText = attributedString;
        
        CGSize actualSize = [SETextView frameRectWithAttributtedString:attributedString
                                                        constraintSize:CGSizeMake(300, CGFLOAT_MAX)
                                                           lineSpacing:8.0
                                                                  font:[UIFont systemFontOfSize:15]].size;
        CGRect frame = _textView.frame;
        frame.size.height = actualSize.height;
        _textView.frame = CGRectMake(10, 10, frame.size.width, frame.size.height);
    }
    else
    {
        _textView.alpha = 0;
        _imageViewContainer.alpha = 1;
        
        _imageViewContainer.backgroundColor = [UIColor whiteColor];
        [_imageViewContainer setFrame:CGRectMake(10.f, 6.f, _attach.size.width, _attach.size.height)];
        
        [_imageView setFrame:CGRectMake(0.f, 0.f, _attach.size.width, _attach.size.height)];
        [_imageView setImageWithURL:[NSURL URLWithString:_attach.link] placeholderImage:[[UIImage imageNamed:@"contentimage.png"] stretchableImageWithLeftCapWidth:10.f topCapHeight:10.f]];
        
        if ([_attach.category isEqualToString:@"video"])
        {
            // 添加播放按钮
            CGRect rect = _imageView.frame;
            rect.origin.x += 10;
            rect.origin.y += 10;
            rect.size.width -= 20;
            rect.size.height -= 20;
            _imageView.frame = rect;
            
            CGSize actualSize = _imageView.frame.size;
            _playImageView.image = [UIImage imageNamed:@"play.png"];
            _playImageView.frame = CGRectMake((actualSize.width-60.f)/2, (actualSize.height-60.f)/2, 60.f, 60.f);
        }
    }
}


- (void)tapped:(id)sender
{
    if ([_attach.category isEqualToString:@"video"])
    {
        if ([_delegate respondsToSelector:@selector(photoTextCell:didPlayVideoURL:)])
        {
            [_delegate photoTextCell:self didPlayVideoURL:_attach.play];
        }
    }
    else if ([_attach.category isEqualToString:@"image"] || [_attach.category isEqualToString:@"img"])
    {
        if ([_delegate respondsToSelector:@selector(photoTextCell:didSelectImageView:)])
        {
            [_delegate photoTextCell:self didSelectImageView:_imageView];
        }
    }
}


@end
