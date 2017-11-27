//
//  HomeCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/6.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBgImageView:(UIImageView *)bgImageView
{
    _bgImageView = bgImageView;
    _bgImageView.layer.masksToBounds = YES;
    _bgImageView.layer.cornerRadius = 3;
}

- (void)setIconImageView:(UIImageView *)iconImageView
{
    _iconImageView = iconImageView;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 12;
    _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconImageView.layer.borderWidth = 1;
}
    
- (void)setModel:(VideoListModel *)model {
    
    [_bgImageView setImageWithURL:[NSURL URLWithString:model.img] placeholder:[UIImage imageNamed:@"video_rebg"]];
//    UIImageView *iconImageView;
    [_iconImageView setImageWithURL:[NSURL URLWithString:model.user_headimg] placeholder:[UIImage imageNamed:@"myaccount"]];
    _titleLabel.text = model.title;
    _typeLabel.text = model.tname;
    _browseLabel.text = [NSString stringWithFormat:@"%@浏览", model.num];
    
}

@end
