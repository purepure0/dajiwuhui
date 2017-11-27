//
//  MsgAttentionCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MsgAttentionCell.h"

@implementation MsgAttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = 20;
}

- (void)setModel:(MsgAttentionModel *)model {
    _model = model;
    [self.avatarView setImageWithURL:[NSURL URLWithString:_model.user_headimg] placeholder:[UIImage imageNamed:@"myaccount"]];
    self.whoAttentionLabel.text = [NSString stringWithFormat:@"%@  关注了你", _model.nick_name];
    self.dateLabel.text = _model.dateMark;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
