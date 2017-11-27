//
//  MsgCommentCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MsgCommentCell.h"

@implementation MsgCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = 20;
    
    self.videoImgView.layer.masksToBounds = YES;
    self.videoImgView.layer.cornerRadius = 2;
    self.playerBtn.layer.masksToBounds = YES;
    self.playerBtn.layer.cornerRadius = 2;
    
}

- (void)setModel:(MsgCommentModel *)model {
    _model = model;
    [self.avatarView setImageWithURL:[NSURL URLWithString:_model.user_headimg] placeholder:[UIImage imageNamed:@"myaccount"]];
    [self.videoImgView setImageWithURL:[NSURL URLWithString:_model.img] placeholder:[UIImage imageNamed:@"Group Copy 3"]];
    self.whoCommentLabel.text = [NSString stringWithFormat:@"%@  回复：", _model.nick_name];
    self.dateLabel.text = _model.dateMark;
    self.contentLabel.text = _model.content;
}


- (IBAction)vidoePlay:(id)sender {
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
