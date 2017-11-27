//
//  VideoListModel.m
//  SuperDancer
//
//  Created by yu on 2017/10/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "VideoListModel.h"

@implementation VideoListModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
    
@end

@implementation PlayVideoModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end


@implementation UserInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
