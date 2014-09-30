//
//  BHChannelGridCell.m
//  SmartBus
//
//  Created by 王 正星 on 13-10-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHChannelGridCell.h"

#define NUMBER_PER_LINE 2
#define TAGWIDTH    145.f

@implementation BHChannelGridCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        for (int i = 0; i < 2; i++) {
            BHChannelCellVIew *view = [[BHChannelCellVIew alloc]initWithFrame:CGRectMake(10.f+(i%NUMBER_PER_LINE)*(TAGWIDTH+10.f), 5.f, TAGWIDTH, TAGWIDTH-10.f)];
            [view setTag:i+1000];
            [self.contentView addSubview:view];
        }
    }
    return self;
}

- (void)setCellData:(NSDictionary *)dic withIndex:(int)index
{
    if (index%2 == 0) {
        BHChannelCellVIew *view = (BHChannelCellVIew *)[self.contentView viewWithTag:1000];
        [view setCellData:dic];
        [view setBtnTag:index+1000];
        view = (BHChannelCellVIew *)[self.contentView viewWithTag:1001];
        [view setHidden:YES];
    }else{
        BHChannelCellVIew *view = (BHChannelCellVIew *)[self.contentView viewWithTag:1001];
        [view setCellData:dic];
        [view setBtnTag:index+1000];
        [view setHidden:NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
