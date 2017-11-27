//
//  HandleCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/9.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "HandleCell.h"

@implementation HandleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineColor;
    [self.contentView addSubview:lineView];
    
    lineView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(1);
}

- (void)setAvatarImgView:(UIImageView *)avatarImgView
{
    _avatarImgView = avatarImgView;
    _avatarImgView.layer.masksToBounds = YES;
    _avatarImgView.layer.cornerRadius  = 18;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapGesture)];
    [_avatarImgView addGestureRecognizer:tapGesture];
}

- (void)imgTapGesture
{
    if (self.imgTapBlock) {
        self.imgTapBlock();
    }
}

- (IBAction)downloadAction:(UIButton *)sender
{
    if (self.handleBlock) {
        self.handleBlock(sender.tag);
    }
}

- (IBAction)collectionAction:(UIButton *)sender
{
    if (self.handleBlock) {
        self.handleBlock(sender.tag);
    }
}

- (IBAction)likeAction:(UIButton *)sender
{
//    PPLog(@"点赞");
    if (self.handleBlock) {
        self.handleBlock(sender.tag);
    }
}


- (void)setLikeModel:(LikeModel *)likeModel {
    _likeModel = likeModel;
    [_likeModel addObserver:self forKeyPath:@"message" options:NSKeyValueObservingOptionNew context:@"Like"];
}

- (void)setKeepModel:(KeepModel *)keepModel {
    _keepModel = keepModel;
    [_keepModel addObserver:self forKeyPath:@"message" options:NSKeyValueObservingOptionNew context:@"Keep"];
    
}
- (void)dealloc {
    [_likeModel removeObserver:self forKeyPath:@"message"];
    [_keepModel removeObserver:self forKeyPath:@"message"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSString *type = [NSString stringWithFormat:@"%@", context];
    if ([keyPath isEqualToString:@"message"] && [type isEqualToString:@"Like"]) {
        NSLog(@"点赞_message_change: %@", change);
        NSString *new = [NSString stringWithFormat:@"%@", change[@"new"]];
        if ([new isEqualToString:@"未点赞"] || [new isEqualToString:@"未登陆"] || [new isEqualToString:@"请先登录"] || [new isEqualToString:@"取消点赞"]) {
            NSLog(@"未点赞/取消点赞/未登陆");
            [self.likeBtn setImage:[UIImage imageNamed:@"video_agree"] forState:UIControlStateNormal];
        }else {
            NSLog(@"点赞");
            [self.likeBtn setImage:[UIImage imageNamed:@"video_agree_success"] forState:UIControlStateNormal];
        }
    }
    
    if ([keyPath isEqualToString:@"message"] && [type isEqualToString:@"Keep"]) {
        NSLog(@"收藏_message_change: %@", change);
        NSString *new = [NSString stringWithFormat:@"%@", change[@"new"]];
        if ([new isEqualToString:@"未收藏"] || [new isEqualToString:@"未登陆"] || [new isEqualToString:@"请先登录"] || [new isEqualToString:@"取消收藏！"]) {
            NSLog(@"未收藏/取消收藏/未登陆");
            [self.collectionBtn setImage:[UIImage imageNamed:@"video_collection"] forState:UIControlStateNormal];
        }else {
            NSLog(@"收藏");
            [self.collectionBtn setImage:[UIImage imageNamed:@"video_collection_success"] forState:UIControlStateNormal];
        }
    }
}


- (void)updateDownloadStatus:(BOOL)isExit {
    if (isExit) {
        [self.downloadBtn setImage:IMAGE_NAMED(@"video_download_success") forState:UIControlStateNormal];
    } else {
        [self.downloadBtn setImage:IMAGE_NAMED(@"video_download") forState:UIControlStateNormal];
    }
}

@end
