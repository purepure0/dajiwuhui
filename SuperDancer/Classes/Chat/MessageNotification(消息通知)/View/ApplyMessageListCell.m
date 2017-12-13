//
//  ApplyMessageListCell.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ApplyMessageListCell.h"

@implementation ApplyMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)updateCellWithData:(NSDictionary *)data {
    self.nameLabel.text = data[@"name"];
    self.iconImageView.image = [UIImage imageNamed:data[@"icon"]];
    self.applyContentLabel.text = data[@"content"];
    self.noteLabel.text = data[@"note"];
    if ([data[@"apply"] isEqualToString:@"0"]) {
        [_btn setTitle:@"同 意" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor colorWithHexString:@"5AB433"];
        _btn.enabled = YES;
    }else if ([data[@"apply"] isEqualToString:@"1"]) {
        [_btn setTitle:@"已同意" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.enabled = NO;
    }else {
        [_btn setTitle:@"已拒绝" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.enabled = NO;
    }
}

- (IBAction)agreeAction:(id)sender {
    NSLog(@"同意");
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
