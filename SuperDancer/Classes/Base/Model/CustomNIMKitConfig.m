//
//  CustomNIMKitConfig.m
//  SuperDancer
//
//  Created by yu on 2018/1/3.
//  Copyright © 2018年 yu. All rights reserved.
//

#import "CustomNIMKitConfig.h"

@implementation CustomNIMKitConfig
- (NSArray *)defaultMediaItems {
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[super defaultMediaItems]];
    [items removeObjectAtIndex:2];
    return (NSArray *)items;
}
@end
