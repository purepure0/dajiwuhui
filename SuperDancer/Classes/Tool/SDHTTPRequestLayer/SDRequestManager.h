//
//  SDRequestManager.h
//  SuperDancer
//
//  Created by yu on 2017/10/12.
//  Copyright © 2017年 yu. All rights reserved.
//  接口统一管理

#import <Foundation/Foundation.h>

#import "SDUser.h"
#import "SDHTTPRequest.h"

@interface SDRequestManager : NSObject

@property (nonatomic, strong) SDUser *users;

/** 获取手机验证码*/
- (void)fetchVerifyCodeByMobile:(NSString *)mobile success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *error))failure;

/** 手机号登录*/
- (void)loginByMobile:(NSString *)mobile code:(NSString *)code token:(NSString *)token success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *error))failure;

@end
