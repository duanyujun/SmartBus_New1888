//
//  BHSegementButton.m
//  SmartBus
//
//  Created by user on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHSegementButton.h"

@interface BHSegementButton ()
{
    UILabel *scoreLabel;
    UILabel *score;
}
@end


#define kArrowImageTag  120111

@implementation BHSegementButton

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(score);
    SAFE_RELEASE_SUBVIEW(scoreLabel);
    [super dealloc];
}


- (id)initWithPosition:(CGPoint)point
{
    if ( self = [super initWithFrame:CGRectMake(point.x, point.y, 75.f, 52.f)] )
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(2.f, 2.f, 71.f, 41.f)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backgroundView];
        [backgroundView release];
        
        score = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 75.f, 16.f)];
        score.text = @"0";
        score.font = FONT_SIZE(14);
        score.textAlignment = NSTextAlignmentCenter;
        score.backgroundColor = [UIColor clearColor];
        score.textColor = [UIColor flatDarkGrayColor];
        [self addSubview:score];
        
        scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20.f, 75.f, 16.f)];
        scoreLabel.text = @"";
        scoreLabel.font = FONT_SIZE(14);
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        scoreLabel.textColor = [UIColor flatDarkGrayColor];
        scoreLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:scoreLabel];
        
        if ( point.x <= 75.f * 3 )
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(74.f, 0.f, 1.f, 46.f)];
            line.backgroundColor = [UIColor flatWhiteColor];
            [self addSubview:line];
            [line release];
        }
    }

    return self;
}

- (void)setScoreTitle:(NSString *)title
{
    score.text = title;
}

- (void)setscoreLabelTitle:(NSString *)title
{
    scoreLabel.text = title;
}

- (void)setSelected:(BOOL)selected
{
    if ( selected )
    {
        score.textColor = [UIColor flatRedColor];
        scoreLabel.textColor = [UIColor flatRedColor];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_down_arrow.png"]];
        arrowImageView.tag = kArrowImageTag;
        arrowImageView.frame = CGRectMake(25.5f, 37.1f, 24.f, 12.f);
        [self addSubview:arrowImageView];
        [self sendSubviewToBack:arrowImageView];
        [arrowImageView release];
    }
    else
    {
        score.textColor = [UIColor flatGrayColor];
        scoreLabel.textColor = [UIColor flatGrayColor];
        
        UIImageView *arrowImageView = (UIImageView *)[self viewWithTag:kArrowImageTag];
        [arrowImageView removeFromSuperview];
    }
}

- (void)setScore:(NSInteger)sscore
{
    score.text = [NSString stringWithFormat:@"%d",sscore];
}

- (NSString *)getScore
{
    return score.text;
}

@end
