//
//  IMSystemNotificationClassifier.m
//  SuperDancer
//
//  Created by yu on 2017/12/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "IMSystemNotificationClassifier.h"

@implementation IMSystemNotificationClassifier


//根据通知类型获取通知
+ (NSArray<NIMSystemNotification *> *)fetchNotificationByType:(NIMSystemNotificationType)type fromNotifications:(NSArray<NIMSystemNotification *> *)notifications {
    NSMutableArray *arr = [NSMutableArray new];
    for (NIMSystemNotification *noti in notifications) {
        if (noti.type == type) {
            [arr addObject:noti];
        }
    }
    if (arr.count == 0) {
        return [NSArray new];
    }
    return [NSArray arrayWithArray:arr];
}



//通知--申请入群
+ (NSArray<NIMSystemNotification *> *)typeTeamApply:(NSArray<NIMSystemNotification *> *)notifications {
    NSMutableArray *arr = [NSMutableArray new];
    for (NIMSystemNotification *noti in notifications) {
        if (noti.type == NIMSystemNotificationTypeTeamApply) {
            [arr addObject:noti];
        }
    }
    if (arr.count == 0) {
        return [NSArray new];
    }
    return [NSArray arrayWithArray:arr];
}

//通知--拒绝入群
+ (NSArray<NIMSystemNotification *> *)typeTeamApplyReject:(NSArray<NIMSystemNotification *> *)notifications {
    NSMutableArray *arr = [NSMutableArray new];
    for (NIMSystemNotification *noti in notifications) {
        if (noti.type == NIMSystemNotificationTypeTeamApplyReject) {
            [arr addObject:noti];
        }
    }
    if (arr.count == 0) {
        return [NSArray new];
    }
    return [NSArray arrayWithArray:arr];
}

//通知--邀请入群
+ (NSArray<NIMSystemNotification *> *)typeTeamInvite:(NSArray<NIMSystemNotification *> *)notifications {
    NSMutableArray *arr = [NSMutableArray new];
    for (NIMSystemNotification *noti in notifications) {
        if (noti.type == NIMSystemNotificationTypeTeamInvite) {
            [arr addObject:noti];
        }
    }
    if (arr.count == 0) {
        return [NSArray new];
    }
    return [NSArray arrayWithArray:arr];
}

//通知--拒绝入群邀请
+ (NSArray<NIMSystemNotification *> *)typeTeamIviteReject:(NSArray<NIMSystemNotification *> *)notifications {
    NSMutableArray *arr = [NSMutableArray new];
    for (NIMSystemNotification *noti in notifications) {
        if (noti.type == NIMSystemNotificationTypeTeamIviteReject) {
            [arr addObject:noti];
        }
    }
    if (arr.count == 0) {
        return [NSArray new];
    }
    return [NSArray arrayWithArray:arr];
}

//通知--添加好友
+ (NSArray<NIMSystemNotification *> *)typeFriendAdd:(NSArray<NIMSystemNotification *> *)notifications {
    NSMutableArray *arr = [NSMutableArray new];
    for (NIMSystemNotification *noti in notifications) {
        if (noti.type == NIMSystemNotificationTypeFriendAdd) {
            [arr addObject:noti];
        }
    }
    if (arr.count == 0) {
        return [NSArray new];
    }
    return [NSArray arrayWithArray:arr];
}

//通知--添加好友-同意
+ (NSArray<NIMSystemNotification *> *)featchFriendAddNotificationsByUserOperation:(NIMUserOperation)operation fromNotifications:(NSArray<NIMSystemNotification *> *)notifications {
    NSMutableArray *arr = [NSMutableArray new];
    for (NIMSystemNotification *noti in notifications) {
        if (noti.type == NIMSystemNotificationTypeFriendAdd) {
            id obj = noti.attachment;
            if ([obj isKindOfClass:[NIMSystemNotification class]]) {
                if ([(NIMUserAddAttachment *)obj operationType] == operation) {
                    [arr addObject:noti];
                }
            }
        }
    }
    if (arr.count == 0) {
        return [NSArray new];
    }
    return [NSArray arrayWithArray:arr];
}

//通知--team
+ (NSArray<NIMSystemNotification *> *)typeTeam:(NSArray<NIMSystemNotification *> *)notifications {
    NSMutableArray *arr = [NSMutableArray new];
    for (NIMSystemNotification *noti in notifications) {
        if (noti.type != NIMSystemNotificationTypeFriendAdd) {
            [arr addObject:noti];
        }
    }
    if (arr.count == 0) {
        return [NSArray new];
    }
    return [NSArray arrayWithArray:arr];
}

//通知--friend
+ (NSArray<NIMSystemNotification *> *)typeFriend:(NSArray<NIMSystemNotification *> *)notifications {
    NSMutableArray *arr = [NSMutableArray new];
    for (NIMSystemNotification *noti in notifications) {
        if (noti.type == NIMSystemNotificationTypeFriendAdd) {
            [arr addObject:noti];
        }
    }
    if (arr.count == 0) {
        return [NSArray new];
    }
    return [NSArray arrayWithArray:arr];
}

//计算未读通知的数目
+ (NSInteger)countUndreadNotifications:(NSArray<NIMSystemNotification *> *)notifications {
    NSInteger unreadCount = 0;
    for (NIMSystemNotification *noti in notifications) {
        
        if (!noti.read) {
            unreadCount++;
        }
    }
    return unreadCount;
}


//申请入群
//NIMSystemNotificationTypeTeamApply              = 0,
//拒绝入群
//NIMSystemNotificationTypeTeamApplyReject        = 1,
//邀请入群
//NIMSystemNotificationTypeTeamInvite             = 2,
//拒绝入群邀请
//NIMSystemNotificationTypeTeamIviteReject        = 3,
//添加好友
//NIMSystemNotificationTypeFriendAdd

//NIMUserOperationAdd     =   1,
//请求添加好友
//NIMUserOperationRequest =   2,
//通过添加好友请求
//NIMUserOperationVerify  =   3,
//拒绝添加好友请求
//NIMUserOperationReject  =   4,










@end
