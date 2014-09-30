//
//  BHEPGListCell.m
//  SmartBus
//
//  Created by 王 正星 on 13-10-24.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHEPGListCell.h"
#import "BHPlayTimeView.h"
#import "BHEPGListPlayNowTimeView.h"

@interface BHEPGListCell ()
{
    BHPlayTimeView *backTime;
    BHEPGListPlayNowTimeView *nowTime;
    UILabel *name;
}

@end
@implementation BHEPGListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        backTime = [[BHPlayTimeView alloc]initWithFrame:CGRectMake(20.f, 10.f, 60.f, 30.f) withType:BHPlayTimeTypeEnd];
        [self.contentView addSubview:backTime];
        nowTime = [[BHEPGListPlayNowTimeView alloc]initWithFrame:CGRectMake(20.f, 12.5f, 60.f, 25.f)];
        [self.contentView addSubview:nowTime];
        [nowTime setVisible:NO];
        
        name = [[UILabel alloc]initWithFrame:CGRectMake(85.f, 10.f, 230.f, 30.f)];
        [name setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:name];
        
    }
    return self;
}

- (void)setCellData:(NSDictionary *)dic withDateType:(DateType)type isNowIndex:(BOOL)isNow
{
    [backTime setTime:[dic objectForKey:@"epg_time"]];
    [name setText:[dic objectForKey:@"epg_name"]];
    
    [name setFont:[UIFont systemFontOfSize:14.f]];
    [name setTextColor:[UIColor grayColor]];
    if (type == DateTypeNow) {
        if (isNow) {
            [nowTime setVisible:YES];
            [backTime setVisible:NO];
            [nowTime  setTime:[dic objectForKey:@"epg_time"]];
            [name setFont:[UIFont boldSystemFontOfSize:16]];
            [name setTextColor:[UIColor blackColor]];
        }else
        {
            [nowTime setVisible:NO];
            [backTime setVisible:YES];
        }
    }else
    {
        
        [nowTime setVisible:NO];
        [backTime setVisible:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
