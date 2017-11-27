//
//  ReplyCommentModel.m
//  SuperDancer
//
//  Created by yu on 2017/10/19.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ReplyCommentModel.h"

@implementation ReplyCommentModel

- (instancetype)initReplyCommentModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.tid = value;
    }
}

@end
