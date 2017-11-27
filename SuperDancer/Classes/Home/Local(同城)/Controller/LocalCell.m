//
//  LocalCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "LocalCell.h"

@implementation LocalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.label.layer.masksToBounds = YES;
    self.label.layer.cornerRadius = 2;
    self.label.layer.borderColor = kColorRGB(117, 117, 117).CGColor;
    self.label.layer.borderWidth = 0.5;
}



@end
