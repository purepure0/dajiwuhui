//
//  IMSystemNotificationClassifier.h
//  SuperDancer
//
//  Created by yu on 2017/12/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
//分类获取通知工具
@interface IMSystemNotificationClassifier : NSObject
//根据通知类型获取通知
+ (NSArray<NIMSystemNotification *> *)fetchNotificationByType:(NIMSystemNotificationType)type fromNotifications:(NSArray<NIMSystemNotification *> *)notifications;

//通知--申请入群
+ (NSArray<NIMSystemNotification *> *)typeTeamApply:(NSArray<NIMSystemNotification *> *)notifications;

//通知--拒绝入群
+ (NSArray<NIMSystemNotification *> *)typeTeamApplyReject:(NSArray<NIMSystemNotification *> *)notifications;

//通知--邀请入群
+ (NSArray<NIMSystemNotification *> *)typeTeamInvite:(NSArray<NIMSystemNotification *> *)notifications;

//通知--拒绝入群邀请
+ (NSArray<NIMSystemNotification *> *)typeTeamIviteReject:(NSArray<NIMSystemNotification *> *)notifications;

//通知--添加好友
+ (NSArray<NIMSystemNotification *> *)typeFriendAdd:(NSArray<NIMSystemNotification *> *)notifications;

//通知--添加好友-同意
+ (NSArray<NIMSystemNotification *> *)featchFriendAddNotificationsByUserOperation:(NIMUserOperation)operation fromNotifications:(NSArray<NIMSystemNotification *> *)notifications;

//通知--team
+ (NSArray<NIMSystemNotification *> *)typeTeam:(NSArray<NIMSystemNotification *> *)notifications;

//通知--friend
+ (NSArray<NIMSystemNotification *> *)typeFriend:(NSArray<NIMSystemNotification *> *)notifications;

//计算未读通知的数目
+ (NSInteger)countUndreadNotifications:(NSArray<NIMSystemNotification *> *)notifications;
@end
