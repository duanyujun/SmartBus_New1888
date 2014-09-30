//
//  BHPlanHeaderView.m
//  SmartBus
//
//  Created by launching on 13-10-14.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHPlanHeaderView.h"
#import "BHPlanResult.h"

@interface BHPlanHeaderView ()
{
    UIView *backgroundView;
    UIView *headBar;
    UIButton *disclosureButton;
    
    BHPlanResult *_result;
    id<BHPlanHeaderDelegate> _delegate;
}
- (NSString *)busNameCutted:(NSString *)name;
@end

#define kBaseLabelTag  120121
#define kArrowImageTag 220121
#define kTipsLabelTag  320121

@implementation BHPlanHeaderView

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(backgroundView);
    SAFE_RELEASE_SUBVIEW(headBar);
    SAFE_RELEASE_SUBVIEW(disclosureButton);
    SAFE_RELEASE(_result);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<BHPlanHeaderDelegate>)delegate
{
    if ( self = [super initWithFrame:frame] )
    {
        _delegate = delegate;
        
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10.f, 10.f, self.frame.size.width-20.f, self.frame.size.height-10.f)];
        backgroundView.backgroundColor = [UIColor clearColor];
        backgroundView.layer.masksToBounds = YES;
        backgroundView.layer.cornerRadius = 4.f;
        [self addSubview:backgroundView];
        
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:10.f topCapHeight:10.f]];
        bubbleImageView.frame = backgroundView.bounds;
        [backgroundView addSubview:bubbleImageView];
        [bubbleImageView release];
        
        // header
        headBar = [[UIView alloc] initWithFrame:CGRectMake(1.f, 0.f, backgroundView.frame.size.width-2.f, 36.f)];
        headBar.backgroundColor = [UIColor flatBlueColor];
        [backgroundView addSubview:headBar];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 8.f, 100.f, 20.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = BOLD_FONT_SIZE(15);
        titleLabel.textColor = [UIColor whiteColor];
        [headBar addSubview:titleLabel];
        [titleLabel release];
        
        disclosureButton = [[UIButton alloc] initWithFrame:CGRectMake(260.f, 60.f, 40.f, 40.f)];
        disclosureButton.backgroundColor = [UIColor clearColor];
        [disclosureButton setImage:[UIImage imageNamed:@"icon_down_arrow.png"] forState:UIControlStateNormal];
        [disclosureButton setImage:[UIImage imageNamed:@"icon_right_arrow.png"] forState:UIControlStateSelected];
        [disclosureButton addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:disclosureButton];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle:)];
        [self addGestureRecognizer:tap];
        [tap release];
        
        self.backgroundColor = [UIColor flatWhiteColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame delegate:nil];
}


#pragma mark -
#pragma mark custom methods

- (void)setTitle:(NSString *)title
{
    UILabel *titleLabel = (UILabel *)[headBar.subviews objectAtIndex:0];
    [titleLabel setText:title];
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

- (void)setPlanResult:(BHPlanResult *)result
{
    SAFE_RELEASE(_result);
    _result = [result retain];
    
    // 换乘的线路
    CGFloat x = 20.f;
    for (int i = 0; i < result.lines.count; i++)
    {
        NSString *name = [self busNameCutted:result.lines[i]];
        CGSize size = [name sizeWithFont:BOLD_FONT_SIZE(18) byWidth:200.f];
        
        UILabel *label = (UILabel *)[self viewWithTag:kBaseLabelTag + i];
        [label removeFromSuperview];
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, 51.f, size.width, 30.f)];
        label.backgroundColor = [UIColor clearColor];
        label.tag = kBaseLabelTag + i;
        label.font = BOLD_FONT_SIZE(18);
        label.text = name;
        [self addSubview:label];
        [label release];
        
        x += size.width;
        
        if ( i < result.lines.count - 1 )
        {
            x += 5.f;
            UIImageView *arrowImageView = (UIImageView *)[self viewWithTag:kArrowImageTag + i];
            [arrowImageView removeFromSuperview];
            arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_to_arrow.png"]];
            arrowImageView.frame = CGRectMake(x, 60.5f, 20.f, 13.f);
            arrowImageView.tag = kArrowImageTag + i;
            [self addSubview:arrowImageView];
            [arrowImageView release];
            x += 25.f;
        }
    }
    
    // 时间距离统计
    UILabel *tlabel = (UILabel *)[self viewWithTag:kTipsLabelTag];
    [tlabel removeFromSuperview];
    tlabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 80.f, 280.f, 20.f)];
    tlabel.backgroundColor = [UIColor clearColor];
    tlabel.tag = kTipsLabelTag;
    tlabel.font = FONT_SIZE(14.f);
    tlabel.textColor = [UIColor lightGrayColor];
    tlabel.text = [NSString stringWithFormat:@"共步行%d米 , 共%d站", result.distance, result.number];
    [self addSubview:tlabel];
    [tlabel release];
}

- (void)toggleOpenWithUserAction:(BOOL)userAction
{
    disclosureButton.selected = !disclosureButton.selected;
    
    UIImage *image = disclosureButton.selected ? [UIImage imageNamed:@"bubble_middle.png"] : [UIImage imageNamed:@"bubble.png"];
    UIImageView *bubbleImageView = (UIImageView *)[backgroundView.subviews objectAtIndex:0];
    [bubbleImageView setImage:[image stretchableImageWithLeftCapWidth:5.f topCapHeight:2.f]];
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
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
