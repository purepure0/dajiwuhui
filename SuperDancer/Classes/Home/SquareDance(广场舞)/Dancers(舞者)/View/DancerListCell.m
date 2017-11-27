//
//  DancerListCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/21.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "DancerListCell.h"

@implementation DancerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = self.avatarView.frame.size.height / 2;

//    self.attentionBtn.layer.masksToBounds = YES;
//    self.attentionBtn.layer.cornerRadius = 2;
//    self.attentionBtn.layer.borderColor = kColorRGB(117, 117, 117).CGColor;
//    self.attentionBtn.layer.borderWidth = 0.5;
}

- (void)setModel:(DancerModel *)model {
    _model = model;
    
    [_model addObserver:self forKeyPath:@"attentionInfo" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.avatarView setImageWithURL:[NSURL URLWithString:_model.user_headimg] placeholder:[UIImage imageNamed:@"myaccount"]];
    self.nameLabel.text = _model.nick_name;
    [self.districtBtn setTitle:model.district_name forState:UIControlStateNormal];
    
    if ([@(_model.fans_type) isEqual:@(1)]) {
        [_attentionBtn setImage:IMAGE_NAMED(@"yiguanzhu") forState:UIControlStateNormal];
    }else {
        [_attentionBtn setImage:IMAGE_NAMED(@"guanzhu") forState:UIControlStateNormal];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSString *new = change[@"new"];
    if ([new isEqualToString:@"用户关注成功"]) {
        [_attentionBtn setImage:IMAGE_NAMED(@"yiguanzhu") forState:UIControlStateNormal];
    }else if ([new isEqualToString:@"取消关注成功"]){
        [_attentionBtn setImage:IMAGE_NAMED(@"guanzhu") forState:UIControlStateNormal];
    }
}


- (IBAction)attentionBtnClick:(id)sender {
    if (_attentionBlock) {
        _attentionBlock(_model);
    }
}

- (void)dealloc {
    [_model removeObserver:self forKeyPath:@"attentionInfo"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
