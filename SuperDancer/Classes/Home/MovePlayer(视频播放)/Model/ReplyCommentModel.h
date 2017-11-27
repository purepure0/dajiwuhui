//
//  ReplyCommentModel.h
//  SuperDancer
//
//  Created by yu on 2017/10/19.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyCommentModel : NSObject

@property (nonatomic, copy)NSString *cid;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *tid; //id
@property (nonatomic, copy)NSString *nick_name;
@property (nonatomic, copy)NSString *rtime;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *user_headimg;

- (instancetype)initReplyCommentModelWithDict:(NSDictionary *)dict;

@end
