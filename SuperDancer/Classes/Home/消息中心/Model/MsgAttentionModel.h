//
//  MsgAttentionModel.h
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgAttentionModel : NSObject

@property (nonatomic, copy)NSString *nick_name;
@property (nonatomic, copy)NSString *user_headimg;
@property (nonatomic, copy)NSString *time;

@property (nonatomic, copy)NSString *dateMark;

- (instancetype)initMsgAttentionModelWithDict:(NSDictionary *)dict;
@end
