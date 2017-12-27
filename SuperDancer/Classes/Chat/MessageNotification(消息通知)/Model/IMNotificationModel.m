//
//  IMNotificationModel.m
//  SuperDancer
//
//  Created by yu on 2017/12/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "IMNotificationModel.h"

@implementation IMNotificationModel

- (instancetype)initWithSystemNotification:(NIMSystemNotification *)notication {
    if (self = [super init]) {
        _notification = notication;
        if (_notification.type == NIMSystemNotificationTypeFriendAdd) {
            id obj = _notification.attachment;
            NSString *centerStr = @"";
            if ([obj isKindOfClass:[NIMUserAddAttachment class]]) {
                _operation = [(NIMUserAddAttachment *)obj operationType];
                switch (_operation) {
                    case NIMUserOperationAdd:
                        centerStr = @"已经添加您为好友";
                        break;
                    case NIMUserOperationRequest:
                        centerStr = @"申请加您为好友";
                        break;
                    case NIMUserOperationVerify:
                        centerStr = @"通过了你的好友请求";
                        break;
                    case NIMUserOperationReject:
                        centerStr = @"拒绝了你的好友请求";
                        break;
                    default:
                        break;
                }
            }
            self.message = centerStr;
            self.sourceName = _notification.sourceID;
            self.postscript = _notification.postscript;
            [[NIMSDK sharedSDK].userManager fetchUserInfos:@[_notification.sourceID] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
                if (!error) {
                    NIMUser *source = users[0];
                    
                    self.sourceName = source.userInfo.nickName;
                    self.sourceAvatarURL = source.userInfo.avatarUrl;
                    self.lastMessage = [NSString stringWithFormat:@"%@ %@", self.sourceName, centerStr];
                    if ([self.delegate respondsToSelector:@selector(updateUIWithModel)]) {
                        [self.delegate updateUIWithModel];
                    }
                }else {
                    NSLog(@"error:%@", error.description);
                }
                
            }];
        }else {
            NSString *centerStr = @"";
            BOOL sourceIsTeam = NO; //舞队是发送者吗
            NSLog(@"%@--%@--%@", _notification.sourceID, _notification.targetID, _notification.postscript);
            switch (_notification.type) {
                case NIMSystemNotificationTypeTeamApply:
                {
                    centerStr = @"申请加入您的舞队";
                    sourceIsTeam = NO;
                }
                    break;
                case NIMSystemNotificationTypeTeamApplyReject:
                {
                    centerStr = @"拒绝您加入舞队";
                    sourceIsTeam = YES;
                }
                    break;
                case NIMSystemNotificationTypeTeamInvite:
                {
                    centerStr = @"邀请您加入舞队";
                    sourceIsTeam = YES;
                }
                    break;
                case NIMSystemNotificationTypeTeamIviteReject:
                {
                    centerStr = @"拒绝加入您的舞队";
                    sourceIsTeam = NO;
                }
                    break;
                    
                default:
                    break;
            }
            
            NSLog(@"%@", centerStr);
            self.message = centerStr;
            self.lastMessage = centerStr;
            self.sourceName = _notification.sourceID;
            self.postscript = _notification.postscript;
            //先获取操作者的信息
            [[NIMSDK sharedSDK].userManager fetchUserInfos:@[_notification.sourceID] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
                if (!error) {
                    NIMUser *source = users[0];
                    self.sourceName = source.userInfo.nickName;
                    self.sourceAvatarURL = source.userInfo.avatarUrl;
                    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:notication.targetID completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
                        if (!error) {
                            self.message = [NSString stringWithFormat:@"%@%@", centerStr, team.teamName];
                            self.lastMessage = [NSString stringWithFormat:@"%@ %@%@", self.sourceName, centerStr, team.teamName];
                            if ([self.delegate respondsToSelector:@selector(updateUIWithModel)]) {
                                [self.delegate updateUIWithModel];
                            }
                        }else {
                            PPLog(@"获取舞队信息:error:%@", error.description);
                        }
                    }];
                    if ([self.delegate respondsToSelector:@selector(updateUIWithModel)]) {
                        [self.delegate updateUIWithModel];
                    }
                }else {
                    PPLog(@"获取用户信息:error:%@", error.description);
                }
            }];
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_notification.timestamp];
        self.dateStr = [formatter stringFromDate:date];
    }
    return self;
}


@end
