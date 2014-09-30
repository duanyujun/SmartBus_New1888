//
//  BHMenuCell.m
//  SmartBus
//
//  Created by launching on 13-9-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHMenuCell.h"

@interface BHMenuCell ()
{
    UIImageView *iconImageView;
    UILabel *menuItemLabel;
}
@end

@implementation BHMenuCell

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(iconImageView);
    SAFE_RELEASE_SUBVIEW(menuItemLabel);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        [self.contentView setBackgroundColor:[UIColor fromHexValue:0x2D1D1D]];
        
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 12.f, 20.f, 20.f)];
        [self.contentView addSubview:iconImageView];
        
        menuItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.f, 12.f, 100.f, 20.f)];
        menuItemLabel.backgroundColor = [UIColor clearColor];
        menuItemLabel.font = FONT_SIZE(16);
        menuItemLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:menuItemLabel];
        
        UIView *hline = [[UIView alloc] initWithFrame:CGRectMake(0.f, 43.f, 320.f, 1.f)];
        hline.backgroundColor = [UIColor flatBlackColor];
        [self.contentView addSubview:hline];
        [hline release];
    }
    return self;
}

- (void)setMenuCellTitle:(NSString *)title andImage:(UIImage *)image
{
    [menuItemLabel setText:title];
    iconImageView.image = image;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if ( highlighted )
    {
        [self.contentView setBackgroundColor:[UIColor flatBlueColor]];
    }
    else
    {
        [self.contentView setBackgroundColor:[UIColor fromHexValue:0x1D1D1D]];
    }
}

@end
