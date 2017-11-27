//
//  MsgCommentModel.h
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgCommentModel : NSObject
@property (nonatomic, copy)NSString *vid;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *img;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *nick_name;
@property (nonatomic, copy)NSString *user_headimg;
@property (nonatomic, copy)NSString *content;

@property (nonatomic, strong)NSString *dateMark;

- (instancetype)initMsgCommentModelWithDict:(NSDictionary *)dict;
@end
