//
//  ContactHeaderView.m
//  SuperDancer
//
//  Created by yu on 2018/1/2.
//  Copyright © 2018年 yu. All rights reserved.
//

#import "ContactHeaderView.h"

@implementation ContactHeaderView
- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _isShow = NO;
        _arrowView = [[UIImageView alloc] init];
        _arrowView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowView.image = [UIImage imageNamed:@"arrow_right"];
        [self addSubview:_arrowView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
        
        _arrowView.sd_layout
        .leftSpaceToView(self, 15)
        .heightIs(15)
        .widthIs(15)
        .centerYIs(self.centerY);
        
        _titleLabel.sd_layout
        .leftSpaceToView(_arrowView, 5)
        .topEqualToView(self)
        .bottomEqualToView(self)
        .widthIs(100);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap {
    if (_isShow) {
        _isShow = NO;
        [UIView animateWithDuration:1 animations:^{
            _arrowView.image = [UIImage imageNamed:@"arrow_right"];
        } completion:^(BOOL finished) {
            if (_showBlock) {
                _showBlock(_isShow);
            }
        }];
    }else {
        _isShow = YES;
        [UIView animateWithDuration:1 animations:^{
            _arrowView.image = [UIImage imageNamed:@"arrow_down"];
        } completion:^(BOOL finished) {
            if (_showBlock) {
                _showBlock(_isShow);
            }
        }];
        
    }
}



@end
