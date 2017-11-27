//
//  HandleCell.h
//  SuperDancer
//
//  Created by yu on 2017/10/9.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeModel.h"
#import "KeepModel.h"

typedef void(^HandleBlock)(NSInteger index);
typedef void(^ImgTapBlock)(void);

@interface HandleCell : UICollectionViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
// 下载
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
// 收藏
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
// 点赞
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (nonatomic, copy) HandleBlock handleBlock;

@property (nonatomic, copy) ImgTapBlock imgTapBlock;


@property (nonatomic, strong)LikeModel *likeModel;
@property (nonatomic, strong)KeepModel *keepModel;

- (void)updateDownloadStatus:(BOOL)isExit;
@end
