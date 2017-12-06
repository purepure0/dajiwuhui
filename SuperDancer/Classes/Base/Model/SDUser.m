//
//  SDUser.m
//  SuperDancer
//
//  Created by yu on 2017/10/5.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SDUser.h"

#define USER_USER_ID @"userId"
#define USER_NICK_NAME @"nickName"
#define USER_MOBILE @"mobile"
#define USER_EMAIL @"email"
#define USER_AVATARURL @"avatarURL"
#define USER_ACCOUNT @"account"
#define USER_PASSWORD @"password"
#define USER_TOKEN @"token"
#define USER_SIGNATURE @"signature"
#define USER_BACKGROUND @"background"
#define USER_SEX @"sex"
#define USER_BIRITHDAY @"birthday"
#define USER_CITY_LOCATION @"city_location"
#define USER_DISTRICT_LOCATION @"district_location"
#define USER_CITY_SELECTED @"city_selected"
#define USER_DISTRICT_SELECTED @"district_selected"
#define USER_DISTRICTID @"districtid"

@implementation SDUser

+ (SDUser *)sharedUser {
    static SDUser *sharedUserInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedUserInstance = [[SDUser alloc] init];
    });
    return sharedUserInstance;
}

#pragma mark Property Setter And Getter

- (NSString *)userId {
    return [self.userDefaults objectForKey:USER_USER_ID];
}

- (void)setUserId:(NSString *)userId {
    [self.userDefaults setObject:userId forKey:USER_USER_ID];
}


// 昵称
- (NSString *)nickName {
    return [self.userDefaults objectForKey:USER_NICK_NAME];
}

- (void)setNickName:(NSString *)nickName {
    [self.userDefaults setObject:nickName forKey:USER_NICK_NAME];
}

// 头像
- (NSString *)avatarURL {
    return [self.userDefaults objectForKey:USER_AVATARURL];
}

- (void)setAvatarURL:(NSString *)avatarURL {
    [self.userDefaults setObject:avatarURL forKey:USER_AVATARURL];
}

// 电话
- (NSString *)mobile {
    return [self.userDefaults objectForKey:USER_MOBILE];
}

- (void)setMobile:(NSString *)mobile {
    [self.userDefaults setObject:mobile forKey:USER_MOBILE];
}

// 邮箱
- (NSString *)email {
    return [self.userDefaults objectForKey:USER_EMAIL];
}

- (void)setEmail:(NSString *)email {
    [self.userDefaults setObject:email forKey:USER_EMAIL];
}

// 账户
- (NSString *)account {
    return [self.userDefaults objectForKey:USER_ACCOUNT];
}

- (void)setAccount:(NSString *)account {
    [self.userDefaults setObject:account forKey:USER_ACCOUNT];
}

// 密码
- (NSString *)password {
    return [self.userDefaults objectForKey:USER_PASSWORD];
}

- (void)setPassword:(NSString *)password {
    [self.userDefaults setObject:password forKey:USER_PASSWORD];
}

// 临时token
- (NSString *)token
{
     return [self.userDefaults objectForKey:USER_TOKEN];
}

- (void)setToken:(NSString *)token
{
    [self.userDefaults setObject:token forKey:USER_TOKEN];
}

//签名
- (NSString *)signature {
    return [self.userDefaults objectForKey:USER_SIGNATURE];
}

- (void)setSignature:(NSString *)signature {
    [self.userDefaults setObject:signature forKey:USER_SIGNATURE];
}

//背景
- (NSString *)background {
    return [self.userDefaults objectForKey:USER_BACKGROUND];
}

- (void)setBackground:(NSString *)background {
    [self.userDefaults setObject:background forKey:USER_SIGNATURE];
}

//性别
- (NSString *)sex {
    return [self.userDefaults objectForKey:USER_SEX];
}

- (void)setSex:(NSString *)sex {
    [self.userDefaults setObject:sex forKey:USER_SEX];
}

//生日
- (NSString *)birthday {
    return [self.userDefaults objectForKey:USER_BIRITHDAY];
}

- (void)setBirthday:(NSString *)birthday {
    [self.userDefaults setObject:birthday forKey:USER_BIRITHDAY];
}

//城市--定位
- (NSString *)cityLocation {
    return [self.userDefaults objectForKey:USER_CITY_LOCATION];
}

- (void)setCityLocation:(NSString *)cityLocation {
    [self.userDefaults setObject:cityLocation forKey:USER_CITY_LOCATION];
}

//地区--定位
- (NSString *)districtLocation {
    return [self.userDefaults objectForKey:USER_DISTRICT_LOCATION];
}

- (void)setDistrictLocation:(NSString *)districtLocation {
    [self.userDefaults setObject:districtLocation forKey:USER_DISTRICT_LOCATION];
}

//城市--选择
- (NSString *)citySelected {
    return [self.userDefaults objectForKey:USER_CITY_SELECTED];
}

- (void)setCitySelected:(NSString *)citySelected {
    [self.userDefaults setObject:citySelected forKey:USER_CITY_SELECTED];
}

//地区--选择
- (NSString *)districtSelected {
    return [self.userDefaults objectForKey:USER_DISTRICT_SELECTED];
}

- (void)setDistrictSelected:(NSString *)districtSelected {
    [self.userDefaults setObject:districtSelected forKey:USER_DISTRICT_SELECTED];
}

//地区ID
- (NSString *)districtID {
    return [self.userDefaults objectForKey:USER_DISTRICTID];
}

- (void)setDistrictID:(NSString *)districtID {
    [self.userDefaults setObject:districtID forKey:USER_DISTRICTID];
}


- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

/* 退出登录 */
- (void)logout {
    [self.userDefaults setObject:nil forKey:USER_USER_ID];//Id
    [self.userDefaults setObject:nil forKey:USER_EMAIL];//邮箱
    [self.userDefaults setObject:nil forKey:USER_NICK_NAME];//昵称
    [self.userDefaults setObject:nil forKey:USER_MOBILE];//电话
    [self.userDefaults setObject:nil forKey:USER_AVATARURL];//头像
    [self.userDefaults setObject:nil forKey:USER_ACCOUNT];//帐号
    [self.userDefaults setObject:nil forKey:USER_PASSWORD];//密码
    [self.userDefaults setObject:nil forKey:USER_TOKEN];//临时token
    [self.userDefaults setObject:nil forKey:USER_SIGNATURE];//签名
    [self.userDefaults setObject:nil forKey:USER_BACKGROUND];//背景
    [self.userDefaults setObject:nil forKey:USER_SEX];//性别
    [self.userDefaults setObject:nil forKey:USER_BIRITHDAY];//生日
    //用户当前城市不能清空，因为要在首页上显示
//    [self.userDefaults setObject:nil forKey:USER_CITY_LOCATION];//定位城市
//    [self.userDefaults setObject:nil forKey:USER_DISTRICT_LOCATION];
//    [self.userDefaults setObject:nil forKey:USER_CITY_SELECTED];
//    [self.userDefaults setObject:nil forKey:USER_DISTRICT_SELECTED];
//    [self.userDefaults setObject:nil forKey:USER_DISTRICTID];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KTUSER_HAS_LOGOUT object:nil];
}


@end
