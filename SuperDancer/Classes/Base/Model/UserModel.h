//
//  UserModel.h
//  SuperDancer
//
//  Created by yu on 2017/10/24.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy)NSString *background;
@property (nonatomic, copy)NSString *birthday;
@property (nonatomic, copy)NSString *district_id;
@property (nonatomic, copy)NSString *district_name;
@property (nonatomic, copy)NSString *nick_name;
@property (nonatomic, assign)NSInteger sex;
@property (nonatomic, copy)NSString *signature;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *user_headimg;
@property (nonatomic, copy)NSString *user_tel;

- (instancetype)initWithUserInfo:(NSDictionary *)dict;

@end
