//
//  BUSDBUpdateHelper.m
//  SmartBus
//
//  Created by 王 正星 on 14-6-26.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BUSDBUpdateHelper.h"
#import "BUSDBHelper.h"

#define PERPAGE        100
#define UPDATE_TEST    0

#define LINE_STATION_UPDATE_KEY  @"line_st_updated"
#define LINE_UPDATE_KEY          @"line_updated"
#define STATION_UPDATE_KEY       @"st_updated"
#define UPDOWN_UPDATE_KEY        @"updown_updated"

@interface BUSDBUpdateHelper ()
{
    NSMutableArray *updateArray;
    int upDateIndex;
    int pageIndex;
}
@end


@implementation BUSDBUpdateHelper

- (id)init
{
    if (self = [super init]) {
        updateArray = [[NSMutableArray alloc] initWithCapacity:0];
        pageIndex = 1;
    }
    return self;
}

- (BOOL)checkUpdate:(NSDictionary *)dic
{
    if ([_delegate respondsToSelector:@selector(DBUpdateInfo:)]) {
        [_delegate DBUpdateInfo:nil];
    }
    
    if ( UPDATE_TEST )
    {
        [self upDate:LINE_UPDATE_KEY];
        
        [[BUSDBHelper sharedInstance] checkTable:TABLE_NAME_LINE];
        [[BUSDBHelper sharedInstance] checkTable:TABLE_NAME_STATION];
        [[BUSDBHelper sharedInstance] checkTable:TABLE_NAME_LINE_UPDOWN];
        [[BUSDBHelper sharedInstance] checkTable:TABLE_NAME_LINE_STATION];
    }
    else
    {
        int line_station_updated = [[dic objectForKey:LINE_STATION_UPDATE_KEY] integerValue];
        if (line_station_updated > [BHAPP lst_updated]) {
            [updateArray addObject:LINE_STATION_UPDATE_KEY];
        }
        
        int line_updated = [[dic objectForKey:LINE_UPDATE_KEY] integerValue];
        if (line_updated > [BHAPP line_updated]) {
            [updateArray addObject:LINE_UPDATE_KEY];
        }
        
        int station_updated = [[dic objectForKey:STATION_UPDATE_KEY] integerValue];
        if (station_updated > [BHAPP st_updated]) {
            [updateArray addObject:STATION_UPDATE_KEY];
        }
        
        int updown_updated = [[dic objectForKey:UPDOWN_UPDATE_KEY] integerValue];
        if (updown_updated > [BHAPP updown_updated]) {
            [updateArray addObject:UPDOWN_UPDATE_KEY];
        }
        
        if (updateArray.count)
        {
            [self upDateWithIndex:upDateIndex];
        }
        else
        {
            if ([_delegate respondsToSelector:@selector(DBUpdateFinish)]) {
                [_delegate DBUpdateFinish];
            }
        }
    }
    
    return YES;
}

- (void)upDateWithIndex:(int)index
{
    if (index > (int)(updateArray.count - 1)) {
        if ([_delegate respondsToSelector:@selector(DBUpdateFinish)]) {
            [_delegate DBUpdateFinish];
        }
        return;
    }
    [self upDate:updateArray[index]];
}

- (void)upDate:(NSString *)target
{
    if ([target is:LINE_STATION_UPDATE_KEY]) {
        [self updateLine_station];
    }
    else if ([target is:LINE_UPDATE_KEY]){
        [self updateLine];
    }
    else if ([target is:STATION_UPDATE_KEY]){
        [self updateStations];
    }
    else if ([target is:UPDOWN_UPDATE_KEY]){
        [self updateUpdowns];
    }
}

- (void)updateLine_station
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:[BHAPP lst_updated]], @"line_st_updated",
                           [NSNumber numberWithInt:pageIndex], @"page",
                           [NSNumber numberWithInt:PERPAGE], @"per_page", nil];
    NSString *url = [NSString stringWithFormat:@"%@Line/getLineStations", SBDomain];
    self
    .HTTP_GET( url )
    .PARAM ([SMBusEncryption encryption:param])
    .TIMEOUT (10)
    .USER_INFO (LINE_STATION_UPDATE_KEY);
}

- (void)writeLine_station:(NSDictionary *)dic
{
    NSArray *line_sts = dic[@"line_sts"];
    [[BUSDBHelper sharedInstance] insertObjects:line_sts intoTable:TABLE_NAME_LINE_STATION];
}

- (void)updateLine
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:[BHAPP line_updated]], @"line_updated",
                           [NSNumber numberWithInt:pageIndex], @"page",
                           [NSNumber numberWithInt:PERPAGE], @"per_page", nil];
    NSString *url = [NSString stringWithFormat:@"%@Line/getLines", SBDomain];
    self
    .HTTP_GET( url )
    .PARAM ([SMBusEncryption encryption:param])
    .TIMEOUT (10)
    .USER_INFO (LINE_UPDATE_KEY);
}

- (void)writeLine:(NSDictionary *)dic
{
    NSArray *lines = dic[@"lines"];
    [[BUSDBHelper sharedInstance] insertObjects:lines intoTable:TABLE_NAME_LINE];
}

- (void)updateStations
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:[BHAPP st_updated]], @"st_updated",
                           [NSNumber numberWithInt:pageIndex], @"page",
                           [NSNumber numberWithInt:PERPAGE], @"per_page", nil];
    NSString *url = [NSString stringWithFormat:@"%@Line/getStations", SBDomain];
    self
    .HTTP_GET( url )
    .PARAM ([SMBusEncryption encryption:param])
    .TIMEOUT (10)
    .USER_INFO (STATION_UPDATE_KEY);
}

- (void)writeStations:(NSDictionary *)dic
{
    NSArray *stations = dic[@"stations"];
    [[BUSDBHelper sharedInstance] insertObjects:stations intoTable:TABLE_NAME_STATION];
}

/*上下行*/
- (void)updateUpdowns
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:[BHAPP updown_updated]],@"updown_updated",
                           [NSNumber numberWithInt:pageIndex],@"page",
                           [NSNumber numberWithInt:PERPAGE],@"per_page", nil];
    NSString *url = [NSString stringWithFormat:@"%@Line/getUpdowns", SBDomain];
    self
    .HTTP_GET( url )
    .PARAM ([SMBusEncryption encryption:param])
    .TIMEOUT (10)
    .USER_INFO (UPDOWN_UPDATE_KEY);
}

- (void)writeUpdowns:(NSDictionary *)dic
{
    NSArray *updowns = dic[@"updowns"];
    [[BUSDBHelper sharedInstance] insertObjects:updowns intoTable:TABLE_NAME_LINE_UPDOWN];
}

#pragma mark- 页数控制

- (BOOL)isLastTime:(NSDictionary *)pageResult
{
    int totalNum = [[pageResult objectForKey:@"total"] integerValue];
    if (totalNum <= pageIndex*PERPAGE) {
        return YES;
    }
    return NO;
}

- (void)goNext:(NSString *)target withPageResult:(NSDictionary *)pageResult
{
    if (![self isLastTime:pageResult])
    {
        /*转下页*/
        pageIndex ++;
        [self upDate:target];
    }
    else
    {
        /*转到下个表更新*/
        upDateIndex ++;
        pageIndex = 1;
        [self upDateWithIndex:upDateIndex];
    }
}

#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.succeed )
	{
        NSDictionary *result = [request.responseString objectFromJSONString];
        NSDictionary *pageResult = [result objectForKey:@"result"];
        NSLog(@"updateResponse -> %@,%@",request.userInfo,request.responseString);
        if ( [request.userInfo is:LINE_STATION_UPDATE_KEY] )
        {
            /*更新操作*/
            [self writeLine_station:pageResult];
            [self goNext:request.userInfo withPageResult:pageResult];
        }
        else if ( [request.userInfo is:LINE_UPDATE_KEY] )
        {
            /*更新操作*/
            [self writeLine:pageResult];
            [self goNext:request.userInfo withPageResult:pageResult];
        }
        else if ( [request.userInfo is:STATION_UPDATE_KEY] )
        {
            /*更新操作*/
            [self writeStations:pageResult];
            [self goNext:request.userInfo withPageResult:pageResult];
        }
        else if ( [request.userInfo is:UPDOWN_UPDATE_KEY] )
        {
            /*更新操作*/
            [self writeUpdowns:pageResult];
            [self goNext:request.userInfo withPageResult:pageResult];
        }
	}
	else if ( request.failed )
	{
		NSLog(@"[ERROR] %@", request.error);
	}
}

@end
