//
//  ScrollViewCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ScrollViewCell.h"

@implementation ScrollViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderWidth = 1;
    self.layer.borderColor = kLineColor.CGColor;
}

@end
