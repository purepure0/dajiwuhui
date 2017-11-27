//
//  MusicViewCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/25.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MusicViewCell.h"
#import "MusicModel.h"
@implementation MusicViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = @[(__bridge id)kColorRGB(48, 25, 174).CGColor, (__bridge id)kColorRGB(200, 109, 215).CGColor];
//    gradientLayer.locations = @[@0.5, @0.5];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
//    gradientLayer.frame = _imgView.bounds;
//    [_imgView.layer addSublayer:gradientLayer];
}

- (void)setMusicList:(NSArray *)musicList {
    _musicList = musicList;
    NSArray *btnArr = @[_top1, _top2, _top3];
    for (int  i = 0; i < 3; i++) {
        MusicModel *model = _musicList[i];
        UIButton *btn = btnArr[i];
        btn.tag = 10 + i;
        [btn setTitle:model.title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)click:(UIButton *)btn {
    NSInteger tag = btn.tag - 10;
    MusicModel *model = _musicList[tag];
    if (_selectedBlock) {
        _selectedBlock(model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
