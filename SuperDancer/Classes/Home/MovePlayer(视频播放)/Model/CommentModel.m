//
//  CommentModel.m
//  SuperDancer
//
//  Created by yu on 2017/10/17.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
{
    NSDictionary *_dict;
}
- (instancetype)initModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _dict = dict;
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.cid = value;
    }
    if ([key isEqualToString:@"reply"]) {
        ReplyModel *replyModel = [[ReplyModel alloc] initReplyModelWithDict:_dict[@"reply"]];
        self.replyModel = replyModel;
    }
}

@end

@implementation ReplyModel

- (instancetype)initReplyModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.data = [NSArray new];
        self.count = [dict[@"count"] integerValue];
        if (_count > 0) {
            NSLog(@"存在");
            self.data = dict[@"data"];
        }
//        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end

