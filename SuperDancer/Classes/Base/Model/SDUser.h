//
//  SDUser.h
//  SuperDancer
//
//  Created by yu on 2017/10/5.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDUser : NSObject

// 用户Id
@property (nonatomic, copy) NSString *userId;
// 昵称
@property (nonatomic, copy) NSString *nickName;
// 头像
@property (nonatomic, copy) NSString *avatarURL;
// 电话
@property (nonatomic, copy) NSString *mobile;
// 邮箱
@property (nonatomic, copy) NSString *email;
// 账户
@property (nonatomic, copy) NSString *account;
// 密码
@property (nonatomic, copy) NSString *password;
// 临时token
@property (nonatomic, copy) NSString *token;
//签名
@property (nonatomic, copy) NSString *signature;
//性别
@property (nonatomic, copy) NSString *sex;
//背景
@property (nonatomic, copy) NSString *background;
//生日
@property (nonatomic, copy) NSString *birthday;
//城市--定位
@property (nonatomic, copy) NSString *cityLocation;
//地区--定位
@property (nonatomic, copy)NSString *districtLocation;

//城市--选择
@property (nonatomic, strong)NSString *citySelected;
//地区--选择
@property (nonatomic, strong)NSString *districtSelected;
//地区ID--选择
@property (nonatomic, strong)NSString *districtID;


@property (nonatomic, copy) NSUserDefaults *userDefaults;


+ (SDUser *)sharedUser;

- (void)logout;

@end
