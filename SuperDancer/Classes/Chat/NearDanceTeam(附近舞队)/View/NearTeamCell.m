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

- (void)setModel:(NearbyTeamModel *)model
{
    _model = model;
    self.teamNameLabel.text = model.tname;
    self.distanceLabel.text = NSStringFormat(@"%@m",model.distance);
    [self.iconImgView setImageWithURL:[NSURL URLWithString:model.icon] placeholder:IMAGE_NAMED(@"placeholder_img")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
