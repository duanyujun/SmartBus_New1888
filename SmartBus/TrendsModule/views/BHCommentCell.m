//
//  BHCommentCell.m
//  SmartBus
//
//  Created by launching on 13-11-12.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHCommentCell.h"
#import "UIButton+WebCache.h"
#import "BHCommentModel.h"
#import "NSDate+Helper.h"

@interface BHCommentCell ()
{
    UIButton *avatorButton;
    UILabel *titleLabel;
    UILabel *timeLabel;
    BeeUILabel *subtitleLabel;
    UIView *line;
    
    BHCommentModel *_comment;
}
@end

@implementation BHCommentCell

- (void)dealloc
{
    SAFE_RELEASE(_comment);
    SAFE_RELEASE_SUBVIEW(avatorButton);
    SAFE_RELEASE_SUBVIEW(titleLabel);
    SAFE_RELEASE_SUBVIEW(titleLabel);
    SAFE_RELEASE_SUBVIEW(subtitleLabel);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble_middle.png"] stretchableImageWithLeftCapWidth:5.f topCapHeight:2.f]];
        bubbleImageView.frame = CGRectMake(10.f, 0.f, 300.f, kCommentCellHeight);
        [self.contentView addSubview:bubbleImageView];
        [bubbleImageView release];
        
        avatorButton = [[UIButton alloc] initWithFrame:CGRectMake(20.f, 10.f, 50.f, 50.f)];
        avatorButton.layer.cornerRadius = 5.f;
        avatorButton.layer.masksToBounds = YES;
        [self.contentView addSubview:avatorButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.f, 10.f, 140.f, 23.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONT_SIZE(15);
        [self.contentView addSubview:titleLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(220.f, 10.f, 80.f, 23.f)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = FONT_SIZE(10);
        timeLabel.textColor = [UIColor darkGrayColor];
        timeLabel.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:timeLabel];
        
        subtitleLabel = [[BeeUILabel alloc] initWithFrame:CGRectMake(80.f, 33.f, 220.f, 32.f)];
        subtitleLabel.font = FONT_SIZE(12);
        subtitleLabel.textColor = [UIColor darkGrayColor];
        subtitleLabel.numberOfLines = 0;
        [self.contentView addSubview:subtitleLabel];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(20.f, kCommentCellHeight-1.f, 280.f, 1.f)];
        line.backgroundColor = [UIColor flatWhiteColor];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setComment:(id)comment
{
    SAFE_RELEASE(_comment);
    _comment = [(BHCommentModel *)comment retain];
    
    [avatorButton setImageWithURL:[NSURL URLWithString:_comment.user.avator] placeholderImage:[UIImage imageNamed:@"default_man.png"]];
    titleLabel.text = _comment.user.uname;
    timeLabel.text = [NSDate stringTimesAgo:_comment.ctime withFormat:@"yyyy-MM-dd HH:mm"];
    subtitleLabel.text = _comment.content;
}

- (void)setFinal:(BOOL)final
{
    line.hidden = final;
}

@end
