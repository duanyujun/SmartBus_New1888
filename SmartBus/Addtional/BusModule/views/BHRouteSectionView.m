//
//  BHRouteSectionView.m
//  SmartBus
//
//  Created by launching on 13-10-24.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHRouteSectionView.h"
#import "LKStation.h"

@interface BHRouteSectionView ()
{
    UIImageView *bubbleImageView;
    UIView *contentView;
    id<BHRouteSectionDelegate> _delegate;
}
@end

@implementation BHRouteSectionView

DEF_SIGNAL( ITEM_SELECT )

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(bubbleImageView);
    SAFE_RELEASE_SUBVIEW(contentView);
    [super dealloc];
}

- (id)initWithPosition:(CGPoint)point delegate:(id<BHRouteSectionDelegate>)delegate
{
    if ( self = [super initWithFrame:CGRectMake(point.x, point.y, 320.f-point.x*2, 30.f)] )
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.f;
        
        bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:10.f topCapHeight:10.f]];
        bubbleImageView.frame = self.bounds;
        [self addSubview:bubbleImageView];
        
        // header
        UIView *headBar = [[UIView alloc] initWithFrame:CGRectMake(1.f, 0.f, 308.f, 30.f)];
        headBar.backgroundColor = [UIColor flatBlueColor];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 5.f, 20.f, 20.f)];
        iconImageView.image = [UIImage imageNamed:@"icon_route.png"];
        [headBar addSubview:iconImageView];
        [iconImageView release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.f, 5.f, 100.f, 20.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = BOLD_FONT_SIZE(15);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"站点公交";
        [headBar addSubview:titleLabel];
        [titleLabel release];
        
        [self addSubview:headBar];
        [headBar release];
        
        // content
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 30.f, 310.f, self.frame.size.height-30.f)];
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        
        _delegate = delegate;
    }
    return self;
}

- (id)initWithPosition:(CGPoint)point
{
    return [self initWithPosition:point delegate:nil];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [bubbleImageView setFrame:self.bounds];
    [contentView setFrame:CGRectMake(0.f, 30.f, 310.f, self.frame.size.height-30.f)];
}

- (void)setStationInfo:(LKStation *)station
{
    if (contentView.subviews.count > 0) {
        [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if ( station.st_routes.count > 0 )
    {
        for (int i = 0; i < station.st_routes.count; i++)
        {
            CGFloat x = 14.f + (i % 5) * 58.f;
            CGFloat y = 8.f + floor((float)i / 5) * 30.f;
            
            LKRoute *route = station.st_routes[i];
            
            BeeUIButton *button = [BeeUIButton new];
            button.frame = CGRectMake(x, y, 50.f, 25.f);
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 4.f;
            button.backgroundColor = [UIColor flatWhiteColor];
            button.title = route.line_name;
            button.titleColor = [UIColor darkGrayColor];
            button.titleFont = FONT_SIZE(12);
            [button addSignal:BHRouteSectionView.ITEM_SELECT
             forControlEvents:UIControlEventTouchUpInside
                       object:[NSNumber numberWithInt:i]];
            [contentView addSubview:button];
        }
        
        CGRect rc = self.frame;
        rc.size.height = 30.f + 16.f + ceil((float)station.st_routes.count / 5) * 30.f;
        [self setFrame:rc];
    }
    else
    {
        BeeUILabel *label = [[BeeUILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 280.f, 40.f)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor lightGrayColor];
        label.font = FONT_SIZE(15);
        label.text = @"当前无经过车辆";
        [contentView addSubview:label];
        [label release];
        
        CGRect rc = self.frame;
        rc.size.height = 36.f + 40.f;
        [self setFrame:rc];
    }
}


ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal is:BHRouteSectionView.ITEM_SELECT] )
    {
        if ([_delegate respondsToSelector:@selector(routeSectionView:didSelectAtIndex:)]) {
            NSNumber *number = (NSNumber *)signal.object;
            [_delegate routeSectionView:self didSelectAtIndex:[number intValue]];
        }
    }
}


@end
