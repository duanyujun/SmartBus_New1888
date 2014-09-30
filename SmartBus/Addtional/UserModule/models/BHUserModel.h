//
//  BHUserModel.h
//  SmartBus
//
//  Created by launching on 13-9-27.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef enum {
    USER_GENDER_ANONYMOUS = 0,
    USER_GENDER_MALE,      // 男
    USER_GENDER_FEMALE,    // 女
} USER_GENDER;


@interface BHUserModel : NSObject

AS_SINGLETON( BHUserModel )

/* 用户ID */
@property (nonatomic, assign) NSInteger uid;

/* 用户名 */
@property (nonatomic, retain) NSString *uname;

/* 性别 */
@property (nonatomic, assign) USER_GENDER ugender;

/* 手机号码 */
@property (nonatomic, retain) NSString *uphone;

/* 邮箱 */
@property (nonatomic, retain) NSString *uemail;

/* 用户密码 */
@property (nonatomic, retain) NSString *password;

/* 用户头像 */
@property (nonatomic, retain) NSString *avator;

/* 出省日期 */
@property (nonatomic, retain) NSString *birth;

/* 职业 */
@property (nonatomic, retain) NSString *profession;

/* 签名 */
@property (nonatomic, retain) NSString *signature;

/* 令牌 */
@property (nonatomic, retain) NSString *token;

/* 地理位置 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/* 地理位置（字符串） */
@property (nonatomic, retain) NSString *location;

/* 帖子数 */
@property (nonatomic, assign) NSInteger bbsnum;

/* 粉丝数 */
@property (nonatomic, assign) NSInteger fansnum;

/* 关注数 */
@property (nonatomic, assign) NSInteger attnum;

/* 图片数 */
@property (nonatomic, assign) NSInteger picnum;

/* 积分 */
@property (nonatomic, retain) NSString *score;

/* 距离 */
@property (nonatomic, assign) NSInteger distance;

/* 是否被关注 */
@property (nonatomic, assign) BOOL focused;

@end
