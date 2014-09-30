//
//  BHRemindBoard.m
//  SmartBus
//
//  Created by jstv on 13-10-18.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHRemindBoard.h"

@interface BHRemindBoard () <UITableViewDataSource, UITableViewDelegate>
{
    BeeUITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation BHRemindBoard

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"icon_settings.png"] title:@"提醒设置"];
        
        _tableView = [BeeUITableView new];
        _tableView.backgroundColor = [UIColor clearColor];
		_tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
//        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.beeView addSubview:_tableView];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE_SUBVIEW(_tableView);
	}
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_tableView.frame = self.beeView.bounds;
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
        [self loadDataSource];
	}
	else if ( [signal is:BeeUIBoard.FREE_DATAS] )
	{
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
	}
}

#pragma mark - private methods
- (void)loadDataSource
{
    NSArray *dataArray1 = [[NSArray alloc] initWithObjects:@"震动提醒",@"铃声提醒", nil];
    NSArray *dataArray2 = [[NSArray alloc] initWithObjects:@"铃声", nil];
    
    _dataArray = [[NSMutableArray alloc] initWithObjects:dataArray1, dataArray2, nil];
    
    SAFE_RELEASE(dataArray1);
    SAFE_RELEASE(dataArray2);
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableIdentifier";
    
    BeeUITableViewCell *cell = (BeeUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[BeeUITableViewCell alloc] initWithReuseIdentifier:identifier] autorelease];
        
        CGFloat btnDX = 0.f;
        if (indexPath.section == 0) {
            btnDX = 270.f;
        } else {
            btnDX = 280.f;
        }
        BeeUIButton *remindButton = [BeeUIButton new];
        remindButton.frame = CGRectMake(btnDX, 10.f, 20.f, 20.f);
        remindButton.tag = 1235;
        [remindButton setBackgroundColor:[UIColor yellowColor]];
        [remindButton addSignal:@"remind" forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:remindButton];
        [remindButton release];
        
        BeeUILabel *TcellTextLabel = [[BeeUILabel alloc] initWithFrame:CGRectMake(20.f, 8.f, 100.f, 30.f)];
        TcellTextLabel.textColor = [UIColor blackColor];
        TcellTextLabel.backgroundColor = [UIColor greenColor];
        TcellTextLabel.font = FONT_SIZE(16);
        TcellTextLabel.tag = 1236;
        TcellTextLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:TcellTextLabel];
        [TcellTextLabel release];
        
        cell.contentView.frame = CGRectMake(10.f, 0.f, 300.f, 40.f);
    }
    
    BeeUILabel *cellTextLabel = (BeeUILabel *)[cell.contentView viewWithTag:1236];
    cellTextLabel.text = [(NSArray *)[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor orangeColor];
    
    return cell;
}

#pragma mark - table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 300.f, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    
    return [view autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 0.f;
    if (indexPath.section == 0) {
        heightForRow = 40.f;
    } else {
        heightForRow = 45.f;
    }
    
    return heightForRow;
}

@end
