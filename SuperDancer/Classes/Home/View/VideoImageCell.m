//
//  VideoImageCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/28.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "VideoImageCell.h"

@implementation VideoImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgView.layer.borderWidth = 0.5;
}

@end
