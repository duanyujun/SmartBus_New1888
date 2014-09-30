//
//  BHOnSiteCell.m
//  SmartBus
//
//  Created by launching on 13-11-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHOnSiteCell.h"
#import "UIImageView+WebCache.h"

@interface BHOnSiteCell ()
{
    UILabelExt *subjectLabel;
    UILabel *summaryLabel;
    UILabel *authorLabel;
    UILabel *departmentLabel;
    UILabel *createDateLabel;
    UIView *imagesContainer;
    UIView *hline1;
    UIView *hline2;
}
@end

@implementation BHOnSiteCell

@synthesize site = _site;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(subjectLabel);
    SAFE_RELEASE_SUBVIEW(summaryLabel);
    SAFE_RELEASE_SUBVIEW(authorLabel);
    SAFE_RELEASE_SUBVIEW(createDateLabel);
    SAFE_RELEASE(_site);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        subjectLabel = [[UILabelExt alloc] initWithFrame:CGRectMake(10.f, 8.f, 300.f, 25.f)];
        subjectLabel.backgroundColor = [UIColor clearColor];
        subjectLabel.font = [UIFont systemFontOfSize:15.f];
        subjectLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [self.contentView addSubview:subjectLabel];
        
        authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 33.f, 140.f, 16.f)];
        authorLabel.backgroundColor = [UIColor clearColor];
        authorLabel.font = [UIFont systemFontOfSize:12.f];
        authorLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:authorLabel];
        
        departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.f, 33.f, 80.f, 16.f)];
        departmentLabel.backgroundColor = [UIColor clearColor];
        departmentLabel.font = [UIFont systemFontOfSize:12.f];
        departmentLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:departmentLabel];
        departmentLabel.hidden = YES;
        
        createDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(202.f, 33.f, 100.f, 16.f)];
        createDateLabel.backgroundColor = [UIColor clearColor];
        createDateLabel.font = [UIFont systemFontOfSize:12.f];
        createDateLabel.textColor = [UIColor darkGrayColor];
        createDateLabel.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:createDateLabel];
        
        imagesContainer = [[UIView alloc] initWithFrame:CGRectMake(10.f, 55.f, 240.f, 60.f)];
        imagesContainer.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imagesContainer];
        imagesContainer.hidden = YES;
        
        summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 55.f, 300.f, 20.f)];
        summaryLabel.backgroundColor = [UIColor clearColor];
        summaryLabel.textColor = [UIColor darkGrayColor];
        summaryLabel.font = [UIFont systemFontOfSize:14.f];
        summaryLabel.numberOfLines = 0;
        [self.contentView addSubview:summaryLabel];
        
        hline1 = [[UIView alloc] initWithFrame:CGRectMake(0.f, 2.f, 320.f, 1.f)];
        hline1.backgroundColor = RGB(211.f, 211.f, 211.f);
        [self.contentView addSubview:hline1];
        
        hline2 = [[UIView alloc] initWithFrame:CGRectMake(0.f, 1.f, 320.f, 1.f)];
        hline2.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:hline2];
    }
    return self;
}


- (void)setSite:(BHOnSiteModel *)site
{
    SAFE_RELEASE(_site);
    _site = [site retain];
    
    [subjectLabel setText:_site.title];
    
    if (_site.level > 0)
    {
        CGSize size = [_site.author sizeWithFont:FONT_SIZE(12) byWidth:300.];
        authorLabel.frame = CGRectMake(10.f, 33.f, size.width, 16.f);
        departmentLabel.hidden = NO;
        departmentLabel.frame = CGRectMake(15.f+size.width, 33.f, 120.f, 16.f);
        if (_site.level == 2 || _site.level == 3) {
            departmentLabel.text = _site.ugroup;
        } else if (_site.level == 1 || _site.level == 4) {
            departmentLabel.text = _site.ucity;
        }
    } else {
        authorLabel.frame = CGRectMake(10.f, 33.f, 140.f, 16.f);
        departmentLabel.hidden = YES;
    }
    
    [authorLabel setText:_site.author];
    [createDateLabel setText:_site.date];
    
    CGFloat height = 55.f;
    if ([_site.attachs count] > 0) {
        imagesContainer.hidden = NO;
        
        for (UIView *view in imagesContainer.subviews) {
            [view removeFromSuperview];
        }
        
        NSInteger count = [_site countOfAttachs] > 3 ? 3 : [_site countOfAttachs];
        for (int i = 0; i < count; i++) {
            BHAttachModel *attach = [_site attachAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f+i*80.f, 0.f, 70.f, 52.f)];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 3.f;
            [imageView setImageWithURL:[NSURL URLWithString:attach.link] placeholderImage:[UIImage imageNamed:@"contentimage.png"]];
            [imagesContainer addSubview:imageView];
            [imageView release];
        }
        
        height += 60.f;
    } else {
        imagesContainer.hidden = YES;
    }
    
    CGSize size = [_site.remark sizeWithFont:FONT_SIZE(14) constrainedToSize:CGSizeMake(240.f, 50.f)];
    CGRect rc = summaryLabel.frame;
    rc.origin.y = height;
    rc.size.height = size.height;
    [summaryLabel setFrame:rc];
    [summaryLabel setText:_site.remark];
    
    [hline1 setFrame:CGRectMake(0.f, rc.origin.y+rc.size.height+6.f, 320.f, 1.f)];
    [hline2 setFrame:CGRectMake(0.f, rc.origin.y+rc.size.height+7.f, 320.f, 1.f)];
}

@end
