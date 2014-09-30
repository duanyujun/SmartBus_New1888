//
//  BHMessageListCell.m
//  SmartBus
//
//  Created by 王 正星 on 13-12-10.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHMessageListCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Helper.h"
@interface BHMessageListCell ()
{
    UIImageView *icon;
    UILabel *name;
    UILabel *talks;
    UILabel *time;
    UIView *redPoint;  //小红点
}
@end
@implementation BHMessageListCell

- (void)dealloc
{
    [super dealloc];
    SAFE_RELEASE_SUBVIEW(icon);
    SAFE_RELEASE_SUBVIEW(name);
    SAFE_RELEASE_SUBVIEW(talks);
    SAFE_RELEASE_SUBVIEW(time);
    SAFE_RELEASE_SUBVIEW(redPoint);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        icon = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 10.f, 32.f, 32.f)];
        [icon.layer setCornerRadius:5.f];
        [icon.layer setMasksToBounds:YES];
        [self.contentView addSubview:icon];

        name = [[UILabel alloc]initWithFrame:CGRectMake(50.f, 10.f, 210.f, 20.f)];
        [name setBackgroundColor:[UIColor clearColor]];
        [name setTextColor:[UIColor blackColor]];
        [name setFont:[UIFont systemFontOfSize:14.f]];
        [self.contentView addSubview:name];
        
        talks = [[UILabel alloc] initWithFrame:CGRectMake(50.f, 25.f, 260.f, 20.f)];
        [talks setBackgroundColor:[UIColor clearColor]];
        [talks setTextColor:[UIColor grayColor]];
        [talks setFont:[UIFont systemFontOfSize:12.f]];
        [self.contentView addSubview:talks];
        
        time = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 10.f, 305.f, 20.f)];
        [time setBackgroundColor:[UIColor clearColor]];
        [time setTextColor:[UIColor redColor]];
        [time setTextAlignment:NSTextAlignmentRight];
        [time setFont:[UIFont systemFontOfSize:12.f]];
        [self.contentView addSubview:time];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0.f, 52.f, 320.f, 1.f)];
        [line setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:241.f/255.f blue:238.f/255.f alpha:1.f]];
        [self.contentView addSubview:line];
        [line release];
        
        redPoint = [[UIView alloc] initWithFrame:CGRectMake(150.f, 17.f, 6.f, 6.f)];
        redPoint.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:redPoint];
        redPoint.hidden = YES;
    }
    return self;
}


- (void)setCellData:(BHMsgModel *)mModel withIndex:(int)iindex
{
    [icon setImageWithURL:[NSURL URLWithString:mModel.receiver.avator] placeholderImage:[UIImage imageNamed:@"default_man.png"]];
    [name setText:mModel.receiver.uname];
    [talks setText:mModel.content];
    [time setText:[NSDate stringTimesAgo:[NSDate stringFromTimeInterval:mModel.dtime] withFormat:@"yyyy年MM月dd日 HH:mm"]];
    
    if ( mModel.newnum > 0 )
    {
        redPoint.hidden = NO;
    }
    else
    {
        redPoint.hidden = YES;
    }
    
    index = iindex;
    if (iindex%2 == 0)
    {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:250.f/255.f blue:249.f/255.f alpha:1.f]];
    }
    else
    {   
        [self.contentView setBackgroundColor:[UIColor colorWithRed:247.f/255.f green:247.f/255.f blue:245.f/255.f alpha:1.f]];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
