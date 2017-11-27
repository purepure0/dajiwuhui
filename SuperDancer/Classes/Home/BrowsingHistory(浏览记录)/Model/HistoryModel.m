//
//  HistoryModel.m
//  SuperDancer
//
//  Created by yu on 2017/10/18.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "HistoryModel.h"
#import "DateMarkTool.h"

@implementation HistoryModel

- (instancetype)initBrowseVideoModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.dateMark = [DateMarkTool dateMarkFromStartDateStr:self.start_time toEndDateStr:nil];
    }
    return self;
}

@end
