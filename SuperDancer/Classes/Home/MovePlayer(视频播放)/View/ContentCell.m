//
//  ContentCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/9.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ContentCell.h"

@implementation ContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineColor;
    [self.contentView addSubview:lineView];
    
    lineView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(1);
}



@end
