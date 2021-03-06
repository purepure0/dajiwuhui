//
//  MsgCommentModel.m
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MsgCommentModel.h"
#import "DateMarkTool.h"

@implementation MsgCommentModel

- (instancetype)initMsgCommentModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.dateMark = [DateMarkTool dateMarkFromStartDateStr:self.time toEndDateStr:nil];
    }
    return self;
}

@end
