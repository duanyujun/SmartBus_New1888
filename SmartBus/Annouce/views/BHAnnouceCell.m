//
//  BHAnnouceCell.m
//  SmartBus
//
//  Created by launching on 13-12-10.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAnnouceCell.h"
#import "BHAnnouceModel.h"
#import "NSDate+Helper.h"

@interface BHAnnouceCell ()
{
    UIImageView *tagImageView;
    UILabel *subjectLabel;
    UILabel *summaryLabel;
}
@end

@implementation BHAnnouceCell

@synthesize annouce = _annouce;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        tagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_unread.png"]];
        tagImageView.layer.cornerRadius = 3.f;
        tagImageView.layer.masksToBounds = YES;
        tagImageView.frame = CGRectMake(8.f, 18.f, 6.f, 6.f);
        [self.contentView addSubview:tagImageView];
        
        subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 8.f, 270.f, 24.f)];
        subjectLabel.backgroundColor = [UIColor clearColor];
        subjectLabel.font = FONT_SIZE(15);
        [self.contentView addSubview:subjectLabel];
        
        summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 32.f, 270.f, 15.f)];
        summaryLabel.backgroundColor = [UIColor clearColor];
        summaryLabel.font = FONT_SIZE(12);
        summaryLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:summaryLabel];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_push.png"]];
        iconImageView.frame = CGRectMake(295.f, 21.f, 15.f, 13.f);
        [self.contentView addSubview:iconImageView];
        [iconImageView release];
        
        // 划线
        UIView *hline1 = [[UIView alloc] initWithFrame:CGRectMake(0.f, 53.f, 320.f, 1.f)];
        hline1.backgroundColor = RGB(211.f, 211.f, 211.f);
        [self.contentView addSubview:hline1];
        [hline1 release];
        
        UIView *hline2 = [[UIView alloc] initWithFrame:CGRectMake(0.f, 54.f, 320.f, 1.f)];
        hline2.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:hline2];
        [hline2 release];
    }
    return self;
}

- (void)setAnnouce:(BHAnnouceModel *)annouce
{
    SAFE_RELEASE(_annouce);
    _annouce = [annouce retain];
    
    [subjectLabel setText:annouce.title];
    [summaryLabel setText:[NSDate stringFromTimeInterval:annouce.ctime]];
    
    if ( annouce.read )
    {
        [tagImageView setImage:[UIImage imageNamed:@"icon_read.png"]];
        [subjectLabel setTextColor:[UIColor darkGrayColor]];
    }
    else
    {
        [tagImageView setImage:[UIImage imageNamed:@"icon_unread.png"]];
        [subjectLabel setTextColor:[UIColor blackColor]];
    }
}

@end
