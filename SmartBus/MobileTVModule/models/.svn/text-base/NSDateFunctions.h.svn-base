//
//  NSDateFunctions.h
//  SmartBus
//
//  Created by launching on 13-11-4.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFunctions : NSObject

+ (NSString *) getCurrentDateDetail;
+ (NSString *) getCurrentDetailTime;
+ (NSString *) getCurrentDateFilename;
+ (NSArray *)  getCurrentWeekDayAndDate;
+ (NSString *) getCurrentYearMonthDay;
+ (NSString *) getCurrentHourAndMin;
+ (double)     getCurrentSec;
+ (NSInteger) getSecFormMinAndSec : (NSString *) HourAndMin;
+ (double) getCurrentSecInday;
//获取当前的年月日的时间戳
+ (double) getCurrentYearMonthDayInt;

+ (NSString *) getDateMonthDayZhFromTimeInt:(int) timeInt;
+ (NSString *) getYearMonthDayEPGFromTimeInt:(int) timeInt;

+ (NSString *) parseWeekEntoEn:(NSString *) ch;
+ (NSString *) parseWeekEntoCh:(NSString *) en ;
//将int转成string
//+(NSString *)parseIntToString : (NSInteger) i;
+ (NSString *) getEpgScreenShotTimeForTimeInt;

+ (NSString *) parseSecToMin : (NSInteger) secs;

//根据当前播放的时间戳获取 年月日和时分的时间戳数组
+ (NSArray *) getTimeIntArrayForTimeInt: (double) timeInt;
//通过时间戳找详细时间
+ (NSString *) getDetailTimeForTimeInt : (double) timeInt;

+ (NSString *)GetCurrentPlayScreenShotUrl:(NSString*)type withDate:(NSDate *)refreshDate withDelay:(int)delay;//s m l 小 中 大
+ (int)GetNowTimeIndex:(NSMutableArray *)mArray;

@end
