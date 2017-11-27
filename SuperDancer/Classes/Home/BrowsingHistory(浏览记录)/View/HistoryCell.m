//
//  HistoryCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/14.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HistoryModel *)model {
    _model = model;
    [self.imgView setImageWithURL:[NSURL URLWithString:_model.img] placeholder:[UIImage imageNamed:@"dance"]];
    self.tLabel.text = _model.title;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
