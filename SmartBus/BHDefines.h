//
//  BHGlobalDefines.h
//  SmartBus
//
//  Created by launching on 13-9-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//


#import "BHUtil.h"
#import "BHUserModel.h"
#import "UIColor+FlatColors.h"
#import "AppDelegate.h"
#import "BHLoginBoard.h"

// AppDelegate
#define BHAPP        (AppDelegate *)[UIApplication sharedApplication].delegate

// 是否为iPhone5
#define IS_IPHONE_5  (fabs([[UIScreen mainScreen] bounds].size.height - 568.f) < DBL_EPSILON)

// 是否为IOS7或者以上版本
#define IS_IOS7      [[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0

// Documents目录
#define DOCUMENTS    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

// 当前版本号
#define IosAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 百度地图APPKEY
#define BMKMapAppKey   @"9d84f1516304d3fb0bc4ca92c46f6ab5"
#define MASearchKey    @"43755fed4c5fb8b542b5f98c590ad345"

// 域名  (测试域名:lujunbk.jstv.com)
#define SBDomain           @"http://testbk.jstv.com/rest/"
#define BHDomain           @"http://q.i5025.com/index.php"
#define SMNJDoamin         @"http://smartnj.jstv.com/"
#define BUSDomain          @"http://trafficomm.jstv.com/smartBus/Module=BusHelper/Controller=BusInfo/Action=:action/"
#define JNDISCLOSE_HOST    @"http://paipaiwebservice.jstv.com/api/"  //在现场接口域名
#define JNDISCLOSE_IMAGE   @"http://paipairesource.jstv.com"         //在现场图片域名

// 字体设置
#define FONT_SIZE(s)       [UIFont systemFontOfSize:s]
#define BOLD_FONT_SIZE(s)  [UIFont boldSystemFontOfSize:s]

#define SEXNAMEKEY @"sexNameKey"

// PAGE_SIZE
#define kPageSize  10

// 发送短信间隔时间
#define kSendInterval  60

// 计算偏移
#define y_offset   (IS_IOS7 ? 20.0 : 0.0)

