//
//  BHFavHeaderView.m
//  SmartBus
//
//  Created by launching on 13-10-14.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHFavHeaderView.h"
#import "BHPlanResult.h"

@interface BHFavHeaderView ()
{
    UIImageView *bubbleImageView;
    UIImageView *titleImageView;
    UILabel *titleLabel;
    UIButton *disclosureButton;
    
    id<BHBHFavHeaderDelegate> _delegate;
}
@end

#define kHeaderHeight  36.f
#define kBaseLabelTag  120121
#define kArrowImageTag 220121
#define kTipsLabelTag  320121

@implementation BHFavHeaderView

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(bubbleImageView);
    SAFE_RELEASE_SUBVIEW(titleImageView);
    SAFE_RELEASE_SUBVIEW(titleLabel);
    SAFE_RELEASE_SUBVIEW(disclosureButton);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<BHBHFavHeaderDelegate>)delegate
{
    if ( self = [super initWithFrame:frame] )
    {
        _delegate = delegate;
        
        self.backgroundColor = [UIColor whiteColor];
        
        bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11.f, 10.f, 298.f, 36.f)];
        [self addSubview:bubbleImageView];
        
        titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, 18.f, 20.f, 20.f)];
        [self addSubview:titleImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.f, 18.f, 100.f, 20.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = BOLD_FONT_SIZE(15);
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        
        disclosureButton = [[UIButton alloc] initWithFrame:CGRectMake(270.f, 10.f, 40.f, 40.f)];
        disclosureButton.backgroundColor = [UIColor clearColor];
        disclosureButton.adjustsImageWhenHighlighted = NO;
        [disclosureButton setImage:[UIImage imageNamed:@"icon_unfold.png"] forState:UIControlStateNormal];
        [disclosureButton setImage:[UIImage imageNamed:@"icon_fold.png"] forState:UIControlStateSelected];
        [disclosureButton addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disclosureButton];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle:)];
        [self addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame delegate:nil];
}


#pragma mark -
#pragma mark custom methods

- (void)setHeaderStyle:(HeaderStyle)style
{
    if ( style == HeaderStyleStation )
    {
        titleImageView.image = [UIImage imageNamed:@"icon_station.png"];
        titleLabel.text = @"站点";
        bubbleImageView.image = [[UIImage imageNamed:@"bubble_orange.png"] stretchableImageWithLeftCapWidth:10.f topCapHeight:5.f];
    }
    else
    {
        titleImageView.image = [UIImage imageNamed:@"icon_route.png"];
        titleLabel.text = @"线路";
        bubbleImageView.image = [[UIImage imageNamed:@"bubble_blue.png"] stretchableImageWithLeftCapWidth:10.f topCapHeight:5.f];
    }
}


- (void)toggleOpenWithUserAction:(BOOL)userAction
{
    disclosureButton.selected = !disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction)
    {
        if (disclosureButton.selected) {
            if ([_delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [_delegate sectionHeaderView:self sectionOpened:self.section];
            }
        } else {
            if ([_delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [_delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}

- (void)toggle:(id)sender
{
    [self toggleOpenWithUserAction:YES];
}

@end
