//
//  SaveBrowseRecord.m
//  SuperDancer
//
//  Created by yu on 2017/10/21.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SaveBrowseRecord.h"

@implementation SaveBrowseRecord

+ (void)saveBrowseRecordWithUid:(NSString *)vid {
    NSDictionary *body = @{@"vid": vid,
                           @"v_long": @"1"
                           };
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kPlayLog) parameters:body success:^(id responseObject) {
        PPLog(@"%@", responseObject);
    } failure:^(NSError *error) {
        PPLog(@"%@", error.description);
    }];
}

@end
