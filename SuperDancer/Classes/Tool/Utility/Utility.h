//
//  Utility.h
//  SuperDancer
//
//  Created by yu on 2017/10/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

// 正则验证手机号是否有效
+ (BOOL)valiMobile:(NSString *)mobile;

// 判断是否同时包含数字、字符和无效字符
+ (BOOL)valiPassword:(NSString *)password;

// 正则验证邮箱是否有效
+ (BOOL)valiEmail:(NSString *)email;

// 时间戳转字符串
+ (NSString *)NSDateToString:(NSString *)timeStr;


@end
