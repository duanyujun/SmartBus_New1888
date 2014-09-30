//
//  BHPlanCell.m
//  SmartBus
//
//  Created by launching on 13-10-15.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPlanCell.h"

@interface BHPlanCell ()
{
    UIImageView *bubbleImageView;
    UIImageView *transImageView;
    UILabel *stationLabel;
    UILabel *subtitleLabel;
    UIView *line;
}
- (NSString *)busNameCutted:(NSString *)name;
@end

@implementation BHPlanCell

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(bubbleImageView);
    SAFE_RELEASE_SUBVIEW(transImageView);
    SAFE_RELEASE_SUBVIEW(stationLabel);
    SAFE_RELEASE_SUBVIEW(subtitleLabel);
    SAFE_RELEASE_SUBVIEW(line);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:bubbleImageView];
        
        transImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:transImageView];
        
        stationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        stationLabel.backgroundColor = [UIColor clearColor];
        stationLabel.font = BOLD_FONT_SIZE(15);
        [self.contentView addSubview:stationLabel];
        
        subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.font = FONT_SIZE(14);
        subtitleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:subtitleLabel];
        
        line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor flatGrayColor];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setFinal:(BOOL)final
{
    UIImage *image = final ? [UIImage imageNamed:@"bubble_bottom.png"] : [UIImage imageNamed:@"bubble_middle.png"];
    [bubbleImageView setImage:[image stretchableImageWithLeftCapWidth:5.f topCapHeight:2.f]];
}

- (void)setPlan:(BHPlanModel *)plan style:(PlanStyle)style
{
    if ( style == PlanStyleNormal )
    {
        subtitleLabel.hidden = NO;
        bubbleImageView.frame = CGRectMake(10.f, 0.f, 300.f, kPlanCellHeight);
        transImageView.frame = CGRectMake(18.f, 8.f, 20.f, 20.f);
        stationLabel.frame = CGRectMake(45.f, 5.f, 250.f, 22.f);
        subtitleLabel.frame = CGRectMake(45.f, 27.f, 240.f, 16.f);
        line.frame = CGRectMake(45.f, kPlanCellHeight, 240.f, 1.f);
        
        NSString *transmode = nil;
        NSString *subtitle = nil;
        UIImage *icon = nil;
        if ( plan.type == 0 || plan.type == 1 ) {
            subtitle = [NSString stringWithFormat:@"%d米", plan.distance];
            icon = [UIImage imageNamed:@"icon_walk.png"];
            stationLabel.text = [NSString stringWithFormat:@"步行至%@", plan.rname];
        } else {
            transmode = @"乘坐";
            subtitle = [NSString stringWithFormat:@"经过%d站,在%@下车", plan.snumber, plan.ename];
            icon = [UIImage imageNamed:@"icon_bus.png"];
            stationLabel.text = [NSString stringWithFormat:@"乘坐%@", [self busNameCutted:plan.rname]];
        }
        
        transImageView.image = icon;
        subtitleLabel.text = subtitle;
    }
    else
    {
        subtitleLabel.hidden = YES;
        bubbleImageView.frame = CGRectMake(10.f, 0.f, 300.f, kPotCellHeight);
        transImageView.frame = CGRectMake(20.f, 12.f, 16.f, 16.f);
        stationLabel.frame = CGRectMake(45.f, 8.f, 200.f, 24.f);
        line.frame = CGRectMake(45.f, kPotCellHeight, 240.f, 1.f);
        
        if ( style == PlanStyleStart ) {
            transImageView.image = [UIImage imageNamed:@"icon_start_pot.png"];
            stationLabel.text = plan.rname;
        } else {
            transImageView.image = [UIImage imageNamed:@"icon_end_pot.png"];
            stationLabel.text = plan.rname;
        }
    }
}


- (NSString *)busNameCutted:(NSString *)name
{
    NSString *string = nil;
    
    if ( [name rangeOfString:@"("].location != NSNotFound )
    {
        string = [name substringToIndex:[name rangeOfString:@"("].location];
    }
    
    if ( [name rangeOfString:@"空调"].location != NSNotFound )
    {
        string = [name substringToIndex:[name rangeOfString:@"空调"].location];
    }
    
    return string;
}

@end
