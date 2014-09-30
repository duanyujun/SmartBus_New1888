//
//  DAContextMenuCell.m
//  SmartBus
//
//  Created by launching on 13-11-15.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "DAContextMenuCell.h"

@interface DAContextMenuCell ()
{
    CGFloat initialTouchPositionX;
    UIImageView *bubbleImageView;
}
@end

@implementation DAContextMenuCell

@synthesize scrollView = _scrollView;
@synthesize verticalAlignment = _verticalAlignment;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(bubbleImageView);
    SAFE_RELEASE_SUBVIEW(_scrollView);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 300.f, 44.f)];
        [self.contentView addSubview:bubbleImageView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.f, 0.f, 300.f, 44.f)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self.contentView addSubview:_scrollView];
        
        UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
        menu.frame = CGRectMake(300.f, 0.f, 44.f, 44.f);
        menu.backgroundColor = [UIColor flatRedColor];
        menu.titleLabel.font = FONT_SIZE(14);
        [menu setTitle:@"删除" forState:UIControlStateNormal];
        [menu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [menu addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:menu];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [_scrollView addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (void)setVerticalAlignment:(BubbleVerticalAlignment)verticalAlignment
{
    _verticalAlignment = verticalAlignment;
    UIImage *image = _verticalAlignment == BubbleVerticalAlignmentBottom ? [UIImage imageNamed:@"bubble_bottom.png"] : [UIImage imageNamed:@"bubble_middle.png"];
    [bubbleImageView setImage:[image stretchableImageWithLeftCapWidth:5.f topCapHeight:2.f]];
}

- (void)setHeightForMenu:(CGFloat)height
{
    [bubbleImageView setFrame:CGRectMake(10.f, 0.f, 300.f, height)];
    
    [_scrollView setFrame:CGRectMake(11.f, 0.f, 298.f, height)];
    [_scrollView setContentSize:CGSizeMake(298.f+height, height)];
    
    UIButton *menu = (UIButton *)[_scrollView.subviews objectAtIndex:0];
    menu.frame = CGRectMake(300.f, 0.f, height-1.f, height-1.f);
}

- (void)menuAction:(UIButton *)button
{
    if ( [self.delegate respondsToSelector:@selector(contextMenuCellDidSelectDeleteOption:)] )
    {
        [self.delegate contextMenuCellDidSelectDeleteOption:self];
    }
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    if ( [self.delegate respondsToSelector:@selector(contextMenuCellDidSelectRow:)] )
    {
        [self.delegate contextMenuCellDidSelectRow:self];
    }
}

@end
