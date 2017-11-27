//
//  CollectionCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/24.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CollectionModel *)model {
    _model = model;
    NSLog(@"%@", model.img);
    [self.imgView setImageWithURL:[NSURL URLWithString:_model.img] placeholder:[UIImage imageNamed:@"dance"]];
    self.tLabel.text = _model.title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
