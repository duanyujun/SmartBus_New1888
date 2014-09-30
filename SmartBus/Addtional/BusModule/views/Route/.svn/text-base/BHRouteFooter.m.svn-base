//
//  BHRouteFooter.m
//  SmartBus
//
//  Created by launching on 13-10-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHRouteFooter.h"

@interface BHRouteFooter ()
{
    UILabel *subjectLabel;
    UILabel *summaryLabel;
    BeeUIImageView *coverImageView;
}
@end

@implementation BHRouteFooter

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame] )
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 4;
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 7.f, 18.f, 18.f)];
        iconImageView.image = [UIImage imageNamed:@"icon_group.png"];
        [self addSubview:iconImageView];
        [iconImageView release];
        
        subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.f, 6.f, 260.f, 20.f)];
        subjectLabel.backgroundColor = [UIColor clearColor];
        subjectLabel.font = FONT_SIZE(15);
        subjectLabel.text = @"线路圈子";
        subjectLabel.numberOfLines = 0;
        [self addSubview:subjectLabel];
        
//        summaryLabel = [[BeeUILabel alloc] initWithFrame:CGRectMake(10.f, 30.f, 235.f, 32.f)];
//        summaryLabel.backgroundColor = [UIColor clearColor];
//        summaryLabel.font = FONT_SIZE(12);
//        summaryLabel.textAlignment = NSTextAlignmentLeft;
//        summaryLabel.textColor = [UIColor lightGrayColor];
//        summaryLabel.numberOfLines = 0;
//        [self addSubview:summaryLabel];
        
//        coverImageView = [[BeeUIImageView alloc] initWithFrame:CGRectMake(320.f-62.f, 6.f, 52.f, 52.f)];
//        coverImageView.contentMode = UIViewContentModeScaleAspectFit;
//        coverImageView.backgroundColor = [UIColor flatBlueColor];
//        [self addSubview:coverImageView];
    }
    return self;
}


- (void)setSummary:(NSString *)summary cover:(NSString *)cover
{
    [subjectLabel setText:[NSString stringWithFormat:@"线路圈 : %@", summary]];
    //summaryLabel.text = summary;
    //[coverImageView GET:cover useCache:YES placeHolder:nil];
}

@end
