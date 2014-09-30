//
//  BHGroupCell.m
//  SmartBus
//
//  Created by launching on 13-12-23.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHGroupCell.h"
#import "UIImageView+WebCache.h"

@interface BHGroupCell ()
{
    UIImageView *coverImageView;
    UILabel *groupNameLabel;
    UILabel *attnumLabel;
    UIImageView *postImageView;
    UILabel *postnumLabel;
}
@end

@implementation BHGroupCell

@synthesize group = __group;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(coverImageView);
    SAFE_RELEASE_SUBVIEW(groupNameLabel);
    SAFE_RELEASE_SUBVIEW(attnumLabel);
    SAFE_RELEASE_SUBVIEW(postImageView);
    SAFE_RELEASE_SUBVIEW(postnumLabel);
    SAFE_RELEASE(__group);
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier] )
    {
        coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.f, 8.f, 50.f, 50.f)];
        [self.contentView addSubview:coverImageView];
        
        groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.f, 8.f, 246.f, 30.f)];
        groupNameLabel.backgroundColor = [UIColor clearColor];
        groupNameLabel.font = FONT_SIZE(15);
        [self.contentView addSubview:groupNameLabel];
        
        UIImageView *attImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_member.png"]];
        attImageView.frame = CGRectMake(66.f, 42.f, 12.f, 12.f);
        [self.contentView addSubview:attImageView];
        [attImageView release];
        
        attnumLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.f, 38.f, 60.f, 20.f)];
        attnumLabel.backgroundColor = [UIColor clearColor];
        attnumLabel.font = FONT_SIZE(12);
        [self.contentView addSubview:attnumLabel];
        
        postImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tiezi.png"]];
        postImageView.frame = CGRectMake(150.f, 42.f, 12.f, 12.f);
        [self.contentView addSubview:postImageView];
        
        postnumLabel = [[UILabel alloc] initWithFrame:CGRectMake(164.f, 38.f, 60.f, 20.f)];
        postnumLabel.backgroundColor = [UIColor clearColor];
        postnumLabel.font = FONT_SIZE(12);
        [self.contentView addSubview:postnumLabel];
    }
    return self;
}

- (void)setGroup:(BHGroupModel *)group
{
    SAFE_RELEASE(__group);
    __group = [group retain];
    
    [coverImageView setImageWithURL:[NSURL URLWithString:__group.cover] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    [groupNameLabel setText:__group.gpname];
    
    NSString *str = [NSString stringWithFormat:@"%d人", __group.attnum];
    CGSize size = [str sizeWithFont:FONT_SIZE(12) byWidth:120.f];
    [attnumLabel setFrame:CGRectMake(80.f, 38.f, size.width, 20.f)];
    [attnumLabel setText:str];
    
    [postImageView setFrame:CGRectMake(92.f+size.width, 42.f, 12.f, 12.f)];
    
    str = [NSString stringWithFormat:@"%d贴", __group.postnum];
    size = [str sizeWithFont:FONT_SIZE(12) byWidth:120.f];
    [postnumLabel setFrame:CGRectMake(postImageView.frame.origin.x+postImageView.frame.size.width+2.f, 38.f, size.width, 20.f)];
    [postnumLabel setText:str];
}

- (void)setIndex:(NSInteger)index
{
    if ( index % 2 == 0 )
    {
        [self.contentView setBackgroundColor:RGB(250.f, 250.f, 249.f)];
    }
    else
    {
        [self.contentView setBackgroundColor:RGB(246.f, 246.f, 243.f)];
    }
}

@end
