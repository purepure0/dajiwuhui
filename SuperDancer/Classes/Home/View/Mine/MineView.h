//
//  MineView.h
//  SuperDancer
//
//  Created by yu on 2017/10/6.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AvatarBtnBlock)(void);

typedef void(^HandleBtnBlock)(NSInteger index);

typedef void(^SwitchAccountBlock)(void);

@interface MineView : UIView

@property (nonatomic, strong) HandleBtnBlock fourBtnBlock;

@property (nonatomic, strong) HandleBtnBlock threeBtnBlock;

@property (nonatomic, strong) AvatarBtnBlock avatarBtnBlock;

@property (nonatomic, strong) SwitchAccountBlock switchAccountBlock;


- (void)updateView;
@end
