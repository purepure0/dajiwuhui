//
//  PersonalHeaderView.h
//  SuperDancer
//
//  Created by yu on 2017/10/21.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VideoListModel.h"

typedef void(^EditBtnBlock)(UIButton *btn);
typedef void(^ChangeBgImageBlock)(void);

@interface PersonalHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *avatarImg;

@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

@property (weak, nonatomic) IBOutlet UIView *blackView;


@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (nonatomic, copy) EditBtnBlock editBtnBlock;
@property (nonatomic, copy) ChangeBgImageBlock changeBgImageBlock;

- (void)updateUserInfo:(UserInfo *)userInfo;

@end
