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
                        centerStr = @"直接添加您为好友";
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
            self.message = [NSString stringWithFormat:@"%@ %@", _notification.sourceID, centerStr];
            self.sourceName = _notification.sourceID;
            self.postscript = _notification.postscript;
            [[NIMSDK sharedSDK].userManager fetchUserInfos:@[_notification.sourceID] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
                if (!error) {
                    NIMUser *source = users[0];
                    self.message = [NSString stringWithFormat:@"%@ %@", source.userInfo.nickName, centerStr];
                    self.sourceName = source.userInfo.nickName;
                    self.sourceAvatarURL = source.userInfo.avatarUrl;
                    if ([self.delegate respondsToSelector:@selector(updateUIWithModel)]) {
                        [self.delegate updateUIWithModel];
                    }
                }else {
                    NSLog(@"error:%@", error.description);
                }
                
            }];
        }else {
            NSString *centerStr = @"";
            BOOL sourceIsTeam = NO;
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
                    
                }
                    break;
                case NIMSystemNotificationTypeTeamIviteReject:
                {
                    centerStr = @"拒绝加入您的舞队";
                }
                    break;
                    
                default:
                    break;
            }
            
            NSLog(@"%@", centerStr);
            self.message = [NSString stringWithFormat:@"%@ %@", _notification.sourceID, centerStr];
            self.sourceName = _notification.sourceID;
            self.postscript = _notification.postscript;
            [[NIMSDK sharedSDK].userManager fetchUserInfos:@[_notification.sourceID] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
                if (!error) {
                    NIMUser *source = users[0];
                    self.message = [NSString stringWithFormat:@"%@ %@", source.userInfo.nickName, centerStr];
                    self.sourceName = source.userInfo.nickName;
                    self.sourceAvatarURL = source.userInfo.avatarUrl;
                    if ([self.delegate respondsToSelector:@selector(updateUIWithModel)]) {
                        [self.delegate updateUIWithModel];
                    }
                }else {
                    NSLog(@"error:%@", error.description);
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
