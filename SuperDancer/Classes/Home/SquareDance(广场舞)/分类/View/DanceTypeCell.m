//
//  DanceTypeCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "DanceTypeCell.h"

@implementation DanceTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 2;
    
}

- (void)setModel:(DanceTypeModel *)model {
    _model = model;
    [self.imgView setImageWithURL:[NSURL URLWithString:_model.background] placeholder:[UIImage imageNamed:@"Group Copy 3"]];
    self.typeLabel.text = _model.tname;
}



@end
