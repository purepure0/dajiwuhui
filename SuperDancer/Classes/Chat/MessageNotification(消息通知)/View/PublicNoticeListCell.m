//
//  PublicNoticeListCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "PublicNoticeListCell.h"

@implementation PublicNoticeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellWithData:(NSDictionary *)data {
    self.mTitleLabel.text = data[@"title"];
    self.contentLabel.text = data[@"content"];
    self.dateLabel.text = data[@"date"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
