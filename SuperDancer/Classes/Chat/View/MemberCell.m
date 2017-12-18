//
//  MemberCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/18.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MemberCell.h"

@implementation MemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImg.layer.masksToBounds = YES;
    self.iconImg.layer.cornerRadius = kAutoHeight(25);
}

@end
