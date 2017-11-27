//
//  DateMarkTool.m
//  SuperDancer
//
//  Created by yu on 2017/10/21.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "DateMarkTool.h"

//一天的秒数
#define kDaySeconds 86400

@implementation DateMarkTool
/*思路：距离结束时间当天的0点，求这个0点的时间戳和开始时间的时间戳差值x
     x<0，今天
     0<x<24小时，昨天
     x>24小时，前天
*/
//区分出今天、昨天，超过昨天的返回xxxx年xx月xx日
+ (NSString *)dateMarkFromStartDateStr:(NSString *)startDateStr toEndDateStr:(NSString *)endDateStr {
    
    if (startDateStr == nil) {
        NSLog(@"DateMarkTool:开始时间不能为nil");
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *endDate = nil;
    if (endDateStr == nil) {//没有结束时间时，以当前时间为结束时间
        endDate = [NSDate date];
    }else {
        endDate = [formatter dateFromString:endDateStr];
    }
    //结束时间
    endDateStr = [formatter stringFromDate:endDate];
    //获取结束当天的00:00:00时的时间戳
    endDateStr = [endDateStr stringByReplacingCharactersInRange:NSMakeRange(11, 8) withString:@"00:00:00"];
    endDate = [formatter dateFromString:endDateStr];
    NSString *endInterval = [NSString stringWithFormat:@"%ld", (long)[endDate timeIntervalSince1970]];
    
    
    //获取开始时间的时间戳
    NSDate *startDate = [formatter dateFromString:startDateStr];
    NSString *startInterval = [NSString stringWithFormat:@"%ld", (long)[startDate timeIntervalSince1970]];
    //时间差（秒）
    NSInteger timeDif = [endInterval integerValue] - [startInterval integerValue];
   
    
    //相差时间小于24小时，有可能是今天，也可能是昨天
    if (timeDif < 0) {
        return @"今天";
    }else if (timeDif < kDaySeconds) {
        return @"昨天";
    }else {
        return [startDateStr substringToIndex:10];
    }
}



@end
