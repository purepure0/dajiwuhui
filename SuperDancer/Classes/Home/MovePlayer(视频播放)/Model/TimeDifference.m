//
//  TimeDifference.m
//  SuperDancer
//
//  Created by yu on 2017/10/17.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TimeDifference.h"
#define kMinute 60.0
#define kHour (kMinute * 60)
#define kDay (kHour * 24)
#define kMonth (kDay * 30)
#define kYear (kDay * 365)

#define kSecondsMark @"秒前"
#define kMinuteMark @"分钟前"
#define kHourMark @"小时前"
#define kDayMark @"天前"
#define kMonthMark @"月前"
#define kYearMark @"年前"

@implementation TimeDifference

+ (NSString *)timeDifferenceWithTimeStr:(NSString *)timeStr {
    NSDate *date = [NSDate date];
    NSString *newInterval = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSinceDate:date]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [formatter dateFromString:timeStr];
    NSString *oldInterval = [NSString stringWithFormat:@"%ld", (long)[oldDate timeIntervalSinceDate:date]];
    
    NSInteger timeDif = [newInterval integerValue] - [oldInterval integerValue];
    
    if (timeDif < kMinute) {//不足一分钟：几秒前
        return [NSString stringWithFormat:@"%ld%@", timeDif, kSecondsMark];
    }else if (timeDif < kHour) {//不足一小时：几分钟前
        NSInteger minute = timeDif / kMinute;
        return [NSString stringWithFormat:@"%ld%@", minute, kMinuteMark];
    }else if (timeDif < kDay) {//不足一天：几小时前
        NSInteger hour = timeDif / kHour;
        return [NSString stringWithFormat:@"%ld%@", hour, kHourMark];
    }else if (timeDif < kMonth) {//不足一月：几天前
        NSInteger day = timeDif / kDay;
        return [NSString stringWithFormat:@"%ld%@", day, kDayMark];
    }else if (timeDif < kYear) {//不足一年：几月前
        NSInteger month = timeDif / kMonth;
        return [NSString stringWithFormat:@"%ld%@", month, kMonthMark];
    }else {//超过一年：几年前
        NSInteger year = timeDif / kYear;
        return [NSString stringWithFormat:@"%ld%@", year, kDayMark];
    }
}

@end
