//
//  NearTeamCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "NearTeamCell.h"

@implementation NearTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTModel:(NearbyTeamModel *)tModel
{
    _tModel = tModel;
    self.teamNameLabel.text = tModel.tname;
    self.distanceLabel.text = NSStringFormat(@"%.2lfkm",[tModel.distance floatValue]);
    self.introLabel.text = tModel.intro.length ? tModel.intro:@"未填写群介绍";
    [self.iconImgView setImageWithURL:[NSURL URLWithString:tModel.icon] placeholder:IMAGE_NAMED(@"placeholder_img")];
}

- (void)setDModel:(NearbyDancerModel *)dModel
{
    _dModel = dModel;
    self.teamNameLabel.text = dModel.name;
    self.distanceLabel.text = NSStringFormat(@"%.2lfkm",[dModel.distance floatValue]);
    self.teamNameLabel.text = dModel.name;
    self.introLabel.text = dModel.sign.length ? dModel.sign:@"未填写个人介绍";
    [self.iconImgView setImageWithURL:[NSURL URLWithString:dModel.icon] placeholder:IMAGE_NAMED(@"placeholder_img")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
