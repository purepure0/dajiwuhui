//
//  CommentModel.h
//  SuperDancer
//
//  Created by yu on 2017/10/17.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyModel : NSObject

@property (nonatomic, assign)NSInteger count;
@property (nonatomic, strong)NSArray *data;

- (instancetype)initReplyModelWithDict:(NSDictionary *)dict;

@end


@interface CommentModel : NSObject

@property (nonatomic, copy)NSString *cid; //id
@property (nonatomic, copy)NSString *vid;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *ctime;
@property (nonatomic, copy)NSString *nick_name;
@property (nonatomic, copy)NSString *user_headimg;
@property (nonatomic, strong)ReplyModel *replyModel;
- (instancetype)initModelWithDict:(NSDictionary *)dict;

@end








