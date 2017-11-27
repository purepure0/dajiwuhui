//
//  CommentCell.h
//  SuperDancer
//
//  Created by yu on 2017/10/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "ReplyCommentModel.h"

typedef void(^ReplyActionBlock) (CommentModel *commentModel);
@interface CommentCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarX;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarH;

@property (nonatomic, strong) CommentModel *commentModel;
@property (nonatomic, strong) ReplyCommentModel *replyCommentModel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyBtn;

@property (nonatomic, copy) ReplyActionBlock replyBlock;


@end
