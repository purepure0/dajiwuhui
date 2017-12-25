//
//  MessageNotiCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MessageNotiCell.h"

@implementation MessageNotiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.unreadCountLabel.layer.masksToBounds = YES;
    self.unreadCountLabel.layer.cornerRadius  = self.unreadCountLabel.height / 2;
    
    
}

- (void)updateCellWithData:(NSDictionary *)dic {
    self.imgView.image = [UIImage imageNamed:dic[@"img"]];
    self.mTitleLabel.text = dic[@"title"];
    self.lastMessageLabel.text = dic[@"lastMessage"];
    self.dateLabel.text = dic[@"date"];
    self.unreadCountLabel.text = dic[@"unreadCount"];
    
    if ([dic[@"unreadCount"] integerValue] == 0) {
        [self.unreadCountLabel setHidden:YES];
    }else {
        [self.unreadCountLabel setHidden:NO];
    }
    
}


- (void)updateCellWithData:(NSDictionary *)dic andNotifications:(NSArray <NIMSystemNotification *> *)notifications {
    self.imgView.image = [UIImage imageNamed:dic[@"img"]];
    self.mTitleLabel.text = dic[@"title"];
    if (notifications.count != 0) {
        NIMSystemNotification *lastNoti = [notifications lastObject];
        _model = [[IMNotificationModel alloc] initWithSystemNotification:lastNoti];
        _model.delegate = self;
        self.lastMessageLabel.text = _model.message;
        self.dateLabel.text = _model.dateStr;
        NSInteger unreadCount = [IMSystemNotificationClassifier countUndreadNotifications:notifications];
        if (unreadCount == 0) {
            [self.unreadCountLabel setHidden:YES];
        }else {
            self.unreadCountLabel.text = [NSString stringWithFormat:@"%ld", unreadCount];
            [self.unreadCountLabel setHidden:NO];
        }
    }else {
        self.lastMessageLabel.text = @"无";
        self.dateLabel.text = @"";
        [self.unreadCountLabel setHidden:YES];
    }
}


- (void)updateUIWithModel {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lastMessageLabel.text = _model.message;
        self.dateLabel.text = _model.dateStr;
        NSLog(@"%@--%@", _model.message, _model.dateStr);
    });
}






//NIMSystemNotificationTypeTeamApply              = 0,
///**
// *  拒绝入群
// */
//NIMSystemNotificationTypeTeamApplyReject        = 1,
///**
// *  邀请入群
// */
//NIMSystemNotificationTypeTeamInvite             = 2,
///**
// *  拒绝入群邀请
// */
//NIMSystemNotificationTypeTeamIviteReject        = 3,
//
///**
// *  添加好友
// */
//NIMSystemNotificationTypeFriendAdd












- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
