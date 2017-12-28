//
//  ApplyMessageListCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ApplyMessageListCell.h"

@implementation ApplyMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 30;
}


- (void)updateCellWithData:(NSDictionary *)data {
    self.nameLabel.text = data[@"name"];
    self.iconImageView.image = [UIImage imageNamed:data[@"icon"]];
    self.applyContentLabel.text = data[@"content"];
    self.noteLabel.text = data[@"note"];
    if ([data[@"apply"] isEqualToString:@"0"]) {
        [_btn setTitle:@"同 意" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor colorWithHexString:@"5AB433"];
        _btn.enabled = YES;
    }else if ([data[@"apply"] isEqualToString:@"1"]) {
        [_btn setTitle:@"已同意" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.enabled = NO;
    }else {
        [_btn setTitle:@"已拒绝" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.enabled = NO;
    }
}

- (IBAction)agreeAction:(id)sender {
    NSLog(@"同意");
    if (_model.notification.type == NIMSystemNotificationTypeFriendAdd) {//添加好友请求
        NIMUserRequest *request = [[NIMUserRequest alloc] init];
        request.userId = _model.notification.sourceID;
        request.operation = NIMUserOperationVerify;
        [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
            if (!error) {
                [MBProgressHUD showSuccess:@"同意成功" toView:[UIApplication sharedApplication].keyWindow];
                _model.notification.handleStatus = 1;
                [self setStatus];
            }else {
                NSLog(@"error:%@", error.description);
                [MBProgressHUD showError:@"同意失败" toView:[UIApplication sharedApplication].keyWindow];
            }
        }];
    }else if (_model.notification.type == NIMSystemNotificationTypeTeamInvite) {//入队邀请
        [[NIMSDK sharedSDK].teamManager acceptInviteWithTeam:_model.notification.targetID invitorId:_model.notification.sourceID completion:^(NSError * _Nullable error) {
            if (!error) {
                [MBProgressHUD showSuccess:@"同意成功" toView:[UIApplication sharedApplication].keyWindow];
                _model.notification.handleStatus = 1;
                [self setStatus];
            }else {
                NSLog(@"error:%@", error.description);
                [MBProgressHUD showError:@"同意失败" toView:[UIApplication sharedApplication].keyWindow];
            }
        }];
    }else if (_model.notification.type == NIMSystemNotificationTypeTeamApply) {//入队申请
        [[NIMSDK sharedSDK].teamManager passApplyToTeam:_model.notification.targetID userId:_model.notification.sourceID completion:^(NSError * _Nullable error, NIMTeamApplyStatus applyStatus) {
            if (!error) {
                [MBProgressHUD showSuccess:@"同意成功" toView:[UIApplication sharedApplication].keyWindow];
                _model.notification.handleStatus = 1;
                [self setStatus];
            }else {
                NSLog(@"error:%@", error.description);
                [MBProgressHUD showError:@"同意失败" toView:[UIApplication sharedApplication].keyWindow];
            }
        }];
    }
    
    
}



- (void)updateCellWithModel:(IMNotificationModel *)model; {
    _model = model;
    _model.delegate = self;
    self.nameLabel.text = _model.sourceName;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:_model.sourceAvatarURL] placeholder:[UIImage imageNamed:@"pic1"]];
    self.applyContentLabel.text = _model.message;
    self.noteLabel.text = _model.postscript;
    [self setStatus];
}

- (void)setStatus {
    if (_model.notification.type == NIMSystemNotificationTypeFriendAdd) {
        id obj = _model.notification.attachment;
        if ([obj isKindOfClass:[NIMUserAddAttachment class]]) {
            NIMUserOperation operation = [(NIMUserAddAttachment *)obj operationType];
            switch (operation) {
                case NIMUserOperationRequest:
                    {
                        NSInteger status = _model.notification.handleStatus;
                        if (status == 0) {
                            [_btn setTitle:@"同 意" forState:UIControlStateNormal];
                            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            _btn.backgroundColor = [UIColor colorWithHexString:@"5AB433"];
                            _btn.enabled = YES;
                        }else if (status == 1) {
                            [_btn setTitle:@"已同意" forState:UIControlStateNormal];
                            [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            _btn.backgroundColor = [UIColor whiteColor];
                            _btn.enabled = NO;
                        }else {
                            [_btn setTitle:@"已拒绝" forState:UIControlStateNormal];
                            [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            _btn.backgroundColor = [UIColor whiteColor];
                            _btn.enabled = NO;
                        }
                    }
                    break;
                case NIMUserOperationVerify:
                    {
                        [_btn setTitle:@"已通过" forState:UIControlStateNormal];
                        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        _btn.backgroundColor = [UIColor whiteColor];
                        _btn.enabled = NO;
                    }
                    break;
                case NIMUserOperationReject:
                   {
                       [_btn setTitle:@"被拒绝" forState:UIControlStateNormal];
                       [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                       _btn.backgroundColor = [UIColor whiteColor];
                       _btn.enabled = NO;
                   }
                    break;
                default:
                    break;
            }
        }
    }else if (_model.notification.type == NIMSystemNotificationTypeTeamApply) {//入群申请
        NSInteger status = _model.notification.handleStatus;
        if (status == 0) {
            [_btn setTitle:@"同 意" forState:UIControlStateNormal];
            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor colorWithHexString:@"5AB433"];
            _btn.enabled = YES;
        }else if (status == 1) {
            [_btn setTitle:@"已同意" forState:UIControlStateNormal];
            [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor whiteColor];
            _btn.enabled = NO;
        }else {
            [_btn setTitle:@"已拒绝" forState:UIControlStateNormal];
            [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor whiteColor];
            _btn.enabled = NO;
        }
    }else if (_model.notification.type == NIMSystemNotificationTypeTeamApplyReject) {//拒绝入群
        [_btn setTitle:@"被拒绝" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.enabled = NO;
    }else if (_model.notification.type == NIMSystemNotificationTypeTeamInvite) {//邀请入群
        NSInteger status = _model.notification.handleStatus;
        if (status == 0) {
            [_btn setTitle:@"同 意" forState:UIControlStateNormal];
            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor colorWithHexString:@"5AB433"];
            _btn.enabled = YES;
        }else if (status == 1) {
            [_btn setTitle:@"已同意" forState:UIControlStateNormal];
            [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor whiteColor];
            _btn.enabled = NO;
        }else {
            [_btn setTitle:@"已拒绝" forState:UIControlStateNormal];
            [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _btn.backgroundColor = [UIColor whiteColor];
            _btn.enabled = NO;
        }
    }else if (_model.notification.type == NIMSystemNotificationTypeTeamIviteReject) {//拒绝入群邀请
        [_btn setTitle:@"被拒绝" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.enabled = NO;
    }
    
}

- (void)updateUIWithModel {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.nameLabel.text = _model.sourceName;
        [self.iconImageView setImageWithURL:[NSURL URLWithString:_model.sourceAvatarURL] placeholder:[UIImage imageNamed:@"pic1"]];
        self.applyContentLabel.text = _model.message;
    });
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
