//
//  BHUserHelper.h
//  SmartBus
//
//  Created by JaeHee on 13-10-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_Model.h"
#import "BHCheckModel.h"

@interface BHUserHelper : BeeModel

@property (nonatomic, retain) BHUserModel *user;
@property (nonatomic, retain) NSString *authCode;
@property (nonatomic, retain) NSMutableArray *nodes;
@property (nonatomic, assign) BOOL succeed;

// 检查手机号码
- (void)check:(NSString *)phone;

// 发送验证码
- (void)sendMessage:(NSString *)phone;

// 注册
- (void)registerUserInfo:(BHUserModel *)user;

// 登陆
- (void)login:(NSString *)phone password:(NSString *)pwd;

// 查看用户基本资料
- (void)getUserInfo:(NSInteger)uid shower:(NSInteger)mid;

// 查看用户详细资料
- (void)getUserDetail:(NSInteger)uid shower:(NSInteger)mid;

// 修改用户资料
- (void)updateUserInfo:(BHUserModel *)user withUserID:(NSInteger)uid;

// 上传用户头像
- (void)uploadUserAvator:(UIImage *)image withUserId:(NSInteger)uid;

// 忘记密码
- (void)updatePassword:(NSString *)pwd atPhone:(NSString *)phone;

// 修改密码
- (void)updatePassword:(NSString *)pwd oldPassword:(NSString *)oldpwd atPhone:(NSString *)phone;

// 获取用户相册列表(分页)
- (void)getUserAlbums:(NSInteger)uid shower:(NSInteger)mid atPage:(NSInteger)page;

// 添加/取消关注
- (void)toggleFocus:(BOOL)toggle to:(NSInteger)uid from:(NSInteger)mid;

// 获取关注列表
- (void)getFocus:(NSInteger)uid shower:(NSInteger)mid atPage:(NSInteger)page;

// 获取粉丝列表
- (void)getFans:(NSInteger)uid shower:(NSInteger)mid atPage:(NSInteger)page;

// 获取签到信息
- (void)getStationChecks;

@end
