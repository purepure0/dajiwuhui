//
//  SDRequestManager.m
//  SuperDancer
//
//  Created by yu on 2017/10/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SDRequestManager.h"

#import "SDUser.h"

#define RESULT @"result"
#define CODE [response[@"code"] stringValue]

@implementation SDRequestManager

/** 获取手机验证码*/
- (void)fetchVerifyCodeByMobile:(NSString *)mobile success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure {
    NSString *url = NSStringFormat(@"%@%@",kApiPrefix,kVerifyCode);
    [SDHTTPRequest postRequestWithURL:url parameters:@{@"mobile":mobile} success:^(id response) {
        success(response);
    } failure:^(NSError *error) {
        failure(error.description);
    }];
}

/** 手机号登录*/
- (void)loginByMobile:(NSString *)mobile code:(NSString *)code token:(NSString *)token success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure {
    NSString *url = NSStringFormat(@"%@%@",kApiPrefix,kLogin);
    NSDictionary *params = @{@"mobile":mobile,@"code":code,@"token":token};
    [SDHTTPRequest postRequestWithURL:url parameters:params success:^(id response) {
        PPLog(@"login = %@",response);
        if ([CODE isEqualToString:@"0"])
        {
            self.users.userId = NSStringFormat(@"%@",response[@"data"][@"uid"]);
            self.users.token = NSStringFormat(@"%@",response[@"data"][@"token"]);
        }
        success(response);
    } failure:^(NSError *error) {
        failure(error.description);
    }];
}



- (NSString *)jsonToString:(id)data {
    if(data == nil) { return nil; }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (SDUser *)users
{
    if (_users == nil) {
        _users = [SDUser sharedUser];
    }
    return _users;
}

@end
