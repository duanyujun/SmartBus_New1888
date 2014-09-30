//
//  BHChooseGroopButton.m
//  SmartBus
//
//  Created by 王 正星 on 14-1-9.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHChooseGroopButton.h"

@interface BHChooseGroopButton ()
{
    UILabel *chooseGroupLbl;
}
@end
@implementation BHChooseGroopButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundImage = [[UIImage imageNamed:@"bg_comment.png"] stretchableImageWithLeftCapWidth:14.f topCapHeight:14.f];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_public.png"]];
        iconImageView.frame = CGRectMake(10.f, 6.5f, 15.f, 15.f);
        [self addSubview:iconImageView];
        [iconImageView release];
        
        chooseGroupLbl = [[UILabel alloc]initWithFrame:CGRectMake(35.f, 0.f, self.width - 45.f, self.height)];
        [chooseGroupLbl setBackgroundColor:[UIColor clearColor]];
        [chooseGroupLbl setFont:FONT_SIZE(12.f)];
        [chooseGroupLbl setTextColor:[UIColor grayColor]];
        [self addSubview:chooseGroupLbl];
    }
    return self;
}


- (void)setGroupName:(NSString *)groupName
{
    CGSize size = [groupName sizeWithFont:FONT_SIZE(12.f) constrainedToSize:CGSizeMake(270, 9999) lineBreakMode:NSLineBreakByCharWrapping];
    chooseGroupLbl.width = size.width;
    chooseGroupLbl.text = groupName;
    self.width = chooseGroupLbl.width + 45.f;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
