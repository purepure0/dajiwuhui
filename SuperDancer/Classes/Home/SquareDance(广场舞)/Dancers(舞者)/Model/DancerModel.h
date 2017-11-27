//
//  DancerModel.h
//  SuperDancer
//
//  Created by yu on 2017/10/24.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DancerModel : NSObject

@property (nonatomic, copy)NSString *district_name;
@property (nonatomic, copy)NSString *fans_data;
@property (nonatomic, assign)NSInteger fans_type;
@property (nonatomic, copy)NSString *nick_name;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *user_headimg;
@property (nonatomic, copy)NSString *signature;
@property (nonatomic, copy)NSString *time;

@property (nonatomic, strong)NSString *attentionInfo; //而外 

- (instancetype)initDancerModelWithDict:(NSDictionary *)dict;

@end

