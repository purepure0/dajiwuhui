//
//  SelectTypeCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "SelectTypeCell.h"

@implementation SelectTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.typeLabel.layer.masksToBounds = YES;
    self.typeLabel.layer.cornerRadius = kAutoWidth(35) / 2;
    _typeLabel.textColor = [UIColor blackColor];
}

- (void)setModel:(DanceTypeModel *)model {
    _model = model;
    NSLog(@"%@", model.tname);
    self.typeLabel.text = _model.tname;
    NSLog(@"%@", self.typeLabel.text);
    
}


- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.typeLabel.textColor = [UIColor whiteColor];
        self.typeLabel.backgroundColor = kColorRGB(50, 91, 180);
        
    }else {
        self.typeLabel.textColor = [UIColor blackColor];
        self.typeLabel.backgroundColor = [UIColor whiteColor];
        
    }
}

@end
