//
//  MineHandleCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/1.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MineHandleCell.h"

@implementation MineHandleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)btnsAction:(UIButton *)btn
{
    if (self.handleBlock) {
        self.handleBlock(btn.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
