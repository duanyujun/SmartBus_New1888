//
//  BHProdItemView.m
//  SmartBus
//
//  Created by launching on 13-12-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHProdItemView.h"
#import "UIImageView+WebCache.h"

#define kCoverImageHeight  116.f

@interface BHProdItemView ()
{
    UIImageView *coverImageView;
    UILabel *titleLabel;
    UILabel *priceLabel;
}
@end

@implementation BHProdItemView

@synthesize product = __product;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(coverImageView);
    SAFE_RELEASE_SUBVIEW(titleLabel);
    SAFE_RELEASE_SUBVIEW(priceLabel);
    SAFE_RELEASE(__product);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.f;
        
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)]];
        bubbleImageView.frame = self.bounds;
        [self addSubview:bubbleImageView];
        [bubbleImageView release];
        
        coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_default.png"]];
        coverImageView.frame = CGRectMake(2.f, 0.f, self.frame.size.width-4.f, kCoverImageHeight);
        [self addSubview:coverImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.f, kCoverImageHeight+8.f, kItemWidth-16.f, 25.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONT_SIZE(15);
        [self addSubview:titleLabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8.f, kCoverImageHeight+33.f, 30.f, 19.f)];
        label.backgroundColor = [UIColor clearColor];
        label.font = FONT_SIZE(12);
        label.textColor = [UIColor lightGrayColor];
        label.text = @"兑换:";
        [self addSubview:label];
        [label release];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.f, kCoverImageHeight+33.f, kItemWidth-48.f, 19.f)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = FONT_SIZE(12);
        priceLabel.textColor = [UIColor flatRedColor];
        [self addSubview:priceLabel];
    }
    return self;
}


- (void)setProduct:(BHProductModel *)product
{
    SAFE_RELEASE(__product);
    __product = [product retain];
    
    [coverImageView setImageWithURL:[NSURL URLWithString:__product.pcover]
                   placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    
    [titleLabel setText:__product.pname];
    [priceLabel setText:[NSString stringWithFormat:@"%d银币", __product.coin]];
}

@end
