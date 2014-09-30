//
//  NSDateFunctions.m
//  SmartBus
//
//  Created by launching on 13-11-4.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "NSDateFunctions.h"

@implementation NSDateFunctions

+ (NSString *) getCurrentDateDetail {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

+ (NSString *) getCurrentDetailTime {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    return currentDateStr;
}

+ (NSString *) getCurrentDateFilename {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    return currentDateStr;
}

//星期 和 中文日期
+ (NSArray *) getCurrentWeekDayAndDate {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *currentWeek = [dateFormatter stringFromDate:[NSDate date]];
    
    NSArray *currentDates = [NSArray arrayWithObjects:currentDateStr,currentWeek, nil];
    return currentDates;
}

//EPG格式的日期
+ (NSString *) getCurrentYearMonthDay {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

+ (NSString *) getCurrentHourAndMin {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    return currentDateStr;
}

+ (double) getCurrentSec {
    NSTimeInterval timeInt = [[NSDate date] timeIntervalSince1970];
    return timeInt;
}

+ (NSInteger) getSecFormMinAndSec : (NSString *) HourAndMin{
    //用冒号分割
    NSArray *secs = [HourAndMin componentsSeparatedByString:@":"];
    return [[secs objectAtIndex:0] doubleValue]*60*60+[[secs objectAtIndex:1] doubleValue]*60;
}

+ (double) getCurrentSecInday {
    double currentHMSSec  = [NSDateFunctions getSecFormMinAndSec :[NSDateFunctions getCurrentHourAndMin]] ;
    return currentHMSSec;
}

//获取当前的年月日的时间戳
+ (double) getCurrentYearMonthDayInt {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *yearDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval yearDateInt = [yearDate timeIntervalSince1970];
    return yearDateInt;
}

//通过时间戳找中文日期
+ (NSString *) getDateMonthDayZhFromTimeInt:(int) timeInt {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInt]];
    return currentDateStr;
}

//通过时间戳找EPG格式的日期
+ (NSString *) getYearMonthDayEPGFromTimeInt:(int) timeInt {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInt]];
    return currentDateStr;
}

+ (NSString *) parseWeekEntoEn:(NSString *) ch {
    NSString *en = @"Monday";
    if ([ch isEqualToString:@"星期一"]) {
        en = @"Monday";
    }else if ([ch isEqualToString:@"星期二"]) {
        en = @"Tuesday";
    }else if ([ch isEqualToString:@"星期三"]) {
        en = @"Wednesday";
    }else if ([ch isEqualToString:@"星期四"]) {
        en = @"Thursday";
    }else if ([ch isEqualToString:@"星期五"]) {
        en = @"Friday";
    }else if ([ch isEqualToString:@"星期六"]) {
        en = @"Saturday";
    }else if ([ch isEqualToString:@"星期日"]) {
        en = @"Sunday";
    }
    
    return en;
}

+ (NSString *) parseWeekEntoCh:(NSString *) en {
    NSString *ch = @"星期一";
    if ([en isEqualToString:@"Monday"]) {
        ch = @"星期一";
    }else if ([en isEqualToString:@"Tuesday"]) {
        ch = @"星期二";
    }else if ([en isEqualToString:@"Wednesday"]) {
        ch = @"星期三";
    }else if ([en isEqualToString:@"Thursday"]) {
        ch = @"星期四";
    }else if ([en isEqualToString:@"Friday"]) {
        ch = @"星期五";
    }else if ([en isEqualToString:@"Saturday"]) {
        ch = @"星期六";
    }else if ([en isEqualToString:@"Sunday"]) {
        ch = @"星期日";
    }
    
    return ch;
}

+ (NSString *) getEpgScreenShotTimeForTimeInt  {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"YYYYMM"];
    NSString *year = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"HH"];
    NSString *hour = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"YYYYMMddHH"];
    NSString *timeDetail = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"mm:ss"];
    NSString *sec = [dateFormatter stringFromDate:date];
    NSArray *secs = [sec componentsSeparatedByString:@":"];
    NSInteger minSecs =  [[secs objectAtIndex:0] doubleValue]*60+[[secs objectAtIndex:1] doubleValue];
    if (minSecs > 10) {
        minSecs = minSecs - 15;
    }
    NSString *minSecsString = [NSString stringWithFormat:@"%d",minSecs];
    
    int minSecCount = minSecsString.length;
    
    //位数不够补0
    for (int i = 4 - minSecCount; i > 0; i --) {
        minSecsString = [NSString stringWithFormat:@"%d%d",0,minSecs];
    }
    
    timeDetail = [NSString stringWithFormat:@"%@%@",timeDetail,minSecsString];
    
    timeDetail = [NSString stringWithFormat:@"%@/%@/%@/l_%@.jpg",year,day,hour,timeDetail];
    return timeDetail;
}

+ (NSString *) parseSecToMin : (NSInteger) secs {
    
    NSInteger hour = 0;
    NSInteger min = 0;
    NSInteger sec = 0;
    if (secs < 60) {
        sec = secs;
    }else {
        if (secs < 3600) {
            hour = 0;
            
            min = secs/60;
            sec = secs%60;
        }else {
            hour = secs/3600;
            min  = (secs%3600)/60;
            sec  = (secs%3600)%60;
        }
    }
    
    return [NSString stringWithFormat:@"%d:%d:%d",hour,min,sec];
}

//根据当前播放的时间戳获取 年月日和时分的时间戳数组
+ (NSArray *) getTimeIntArrayForTimeInt: (double) timeInt
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *hour = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInt]];
    NSArray *hours = [hour componentsSeparatedByString:@":"];
    NSInteger hourSecs =  [[hours objectAtIndex:0] doubleValue]*60*60+[[hours objectAtIndex:1] doubleValue]*60 + [[hours objectAtIndex:2] doubleValue];
    
    NSInteger yearSecs = timeInt - hourSecs ;
    NSString *yearDateString = [NSString stringWithFormat:@"%d",yearSecs];
    NSString *hourDateString = [NSString stringWithFormat:@"%d",hourSecs];
    return [NSArray arrayWithObjects:yearDateString,hourDateString, nil];
}

//通过时间戳找详细时间
+ (NSString *) getDetailTimeForTimeInt : (double) timeInt
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInt]];
    return currentDateStr;
}

+ (NSString *)GetCurrentPlayScreenShotUrl:(NSString*)type withDate:(NSDate *)refreshDate withDelay:(int)delay
{
    //获取时间
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //    NSDate *refreshDate = [NSDate dateWithTimeIntervalSinceNow:-30];
    refreshDate = [refreshDate dateByAddingTimeInterval:delay+0];//[APPDELEGATE timeIntervalWithServer]
    comps = [calendar components:unitFlags fromDate:refreshDate];
    
    int minute = [comps minute];
    int second = [comps second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHH"];
    
    NSString *tempSecond = [NSString stringWithFormat:@"0000%d",minute *60 + second];
    NSString *fourSecond = [tempSecond substringFromIndex:[tempSecond length]- 4];
    NSString *picName = [NSString stringWithFormat:@"%@_%@%@.jpg",type,[dateFormatter stringFromDate:refreshDate],fourSecond];
    NSString *cache = [NSString stringWithFormat:@"yyyyMM/dd/HH/"];
    [dateFormatter setDateFormat:cache];
    NSString *downloadPath = [NSString stringWithFormat:@"%@%@",[dateFormatter stringFromDate:refreshDate],picName];
    return downloadPath;
}

+ (int)GetNowTimeIndex:(NSMutableArray *)mArray
{
    int i = 0;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    
    int hour = [comps hour];
    int min = [comps minute];
    
    NSString * locationString = nil;
    if (hour < 10) {
        locationString  = [NSString stringWithFormat:@"0%d:%d",hour,min];
    }
    else {
        locationString  = [NSString stringWithFormat:@"%d:%d",hour,min];
    }
    
    for (; i < [mArray count]; i++) {
        NSDictionary *chatInfo = [mArray objectAtIndex:i];
        NSString *time = [chatInfo objectForKey:@"epg_time"];
        if (time) {
            if (strcmp((char *)[locationString UTF8String], (char *)[time UTF8String])<0) {
                NSLog(@"%@",time);
                if (i - 1 >= 0) {
                    return i - 1;
                }
                else {
                    return i;
                }
            }
        }
    
    }
    return [mArray count]-1;
}

@end
