//
//  BHNewsCell.m
//  SmartBus
//
//  Created by launching on 13-11-20.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHNewsCell.h"
#import "UIImageView+WebCache.h"
#import "UILabelExt.h"
#import "NSDate+Helper.h"

@interface BHNewsCell ()
{
    UIImageView *coverImageView;
    UILabelExt *titleLabel;
    UILabelExt *summaryLabel;
    UILabel *utimeLabel;
}
@end

@implementation BHNewsCell

@synthesize news = _news;

- (void)dealloc
{
    SAFE_RELEASE(_news);
    SAFE_RELEASE_SUBVIEW(coverImageView);
    SAFE_RELEASE_SUBVIEW(titleLabel);
    SAFE_RELEASE_SUBVIEW(summaryLabel);
    SAFE_RELEASE_SUBVIEW(utimeLabel);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0.f, kNewsTableCellHeight-2.f, 320.f, 1.f)];
        line1.backgroundColor = RGB(211.f, 211.f, 211.f);
        [self.contentView addSubview:line1];
        [line1 release];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0.f, kNewsTableCellHeight-1.f, 320.f, 1.f)];
        line2.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line2];
        [line2 release];
        
        coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 8.f, 63.f, 50.f)];
        coverImageView.layer.masksToBounds = YES;
        coverImageView.layer.cornerRadius = 3.f;
        [self.contentView addSubview:coverImageView];
        
        titleLabel = [[UILabelExt alloc] initWithFrame:CGRectMake(80.f, 8.f, 232.f, 22.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONT_SIZE(15);
        titleLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [self.contentView addSubview:titleLabel];
        
        summaryLabel = [[UILabelExt alloc] initWithFrame:CGRectMake(80.f, 30.f, 232.f, 32.f)];
        summaryLabel.backgroundColor = [UIColor clearColor];
        summaryLabel.font = FONT_SIZE(13);
        summaryLabel.textColor = [UIColor lightGrayColor];
        summaryLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        summaryLabel.numberOfLines = 0;
        [self.contentView addSubview:summaryLabel];
        
        utimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210.f, 60.f, 100.f, 25.f)];
        utimeLabel.backgroundColor = [UIColor clearColor];
        utimeLabel.font = FONT_SIZE(12);
        utimeLabel.textColor = [UIColor lightGrayColor];
        utimeLabel.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:utimeLabel];
    }
    return self;
}

- (void)setNews:(BHNewsModel *)news
{
    SAFE_RELEASE(_news);
    _news = [news retain];
    
    [coverImageView setImageWithURL:[NSURL URLWithString:news.cover] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    [titleLabel setText:news.title];
    [summaryLabel setText:news.summary];
    [utimeLabel setText:[NSDate stringTimesAgo:news.ctime]];
}

@end
