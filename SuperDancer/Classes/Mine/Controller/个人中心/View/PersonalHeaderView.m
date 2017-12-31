//
//  PersonalHeaderView.m
//  SuperDancer
//
//  Created by yu on 2017/10/21.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "PersonalHeaderView.h"

#import "UIImageView+WebCache.h"

#import <SDWebImage/UIButton+WebCache.h>

@implementation PersonalHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBgImage)];
    self.blackView.userInteractionEnabled = YES;
    [self.blackView addGestureRecognizer:tap];
}


- (void)changeBgImage {
    if (_changeBgImageBlock) {
        self.changeBgImageBlock();
    }
}

- (void)setAvatarImg:(UIButton *)avatarImg {
    _avatarImg = avatarImg;
    _avatarImg.layer.masksToBounds = YES;
    _avatarImg.layer.cornerRadius = 32.5;
    _avatarImg.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.66].CGColor;
    _avatarImg.layer.borderWidth = 3;
}

- (void)updateUserInfo:(UserInfo *)userInfo {
    _nickNameLabel.text = userInfo.nick_name;
    _signatureLabel.text = userInfo.signature;
    [_avatarImg sd_setImageWithURL:[NSURL URLWithString:userInfo.user_headimg] forState:UIControlStateNormal placeholderImage:IMAGE_NAMED(@"placeholder_img")];
    [_bgImg sd_setImageWithURL:[NSURL URLWithString:userInfo.background] placeholderImage:IMAGE_NAMED(@"personal_placeholder")];
}

- (IBAction)editBtnAction:(UIButton *)btn {
    if (self.editBtnBlock) {
        self.editBtnBlock(btn);
    }
}


@end
