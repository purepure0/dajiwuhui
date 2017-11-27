//
//  CommentCell.m
//  SuperDancer
//
//  Created by yu on 2017/10/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "CommentCell.h"
#import "TimeDifference.h"
@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 12;
    
    self.avatar.layer.masksToBounds = YES;
    self.contentView.userInteractionEnabled = YES;
    [self.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setCommentModel:(CommentModel *)commentModel {
    _commentModel = commentModel;
    _nicknameLabel.text = _commentModel.nick_name;
    _contentLabel.text = _commentModel.content;
    [_avatar setImageWithURL:[NSURL URLWithString:_commentModel.user_headimg] placeholder:[UIImage imageNamed:@"myaccount"]];
    _timeLabel.text = [TimeDifference timeDifferenceWithTimeStr:_commentModel.ctime];
    self.avatarX.constant = 15;
    self.avatarW.constant = self.avatarH.constant = 36;
    self.avatar.layer.cornerRadius = 18;
    [self.replyBtn setHidden:NO];
}




- (void)replyAction:(id)sender {
    NSLog(@"click");
    if (self.replyBlock) {
        self.replyBlock(self.commentModel);
    }
}




- (void)setReplyCommentModel:(ReplyCommentModel *)replyCommentModel {
    _replyCommentModel = replyCommentModel;
    _nicknameLabel.text = _replyCommentModel.nick_name;
    _contentLabel.text = _replyCommentModel.content;
    [_avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _replyCommentModel.user_headimg]] placeholder:[UIImage imageNamed:@"myaccount"]];
    _timeLabel.text = [TimeDifference timeDifferenceWithTimeStr:_replyCommentModel.rtime];
    self.avatarX.constant = 70;
    self.avatarW.constant = self.avatarH.constant = 24;
    self.avatar.layer.cornerRadius = 12;
    [self.replyBtn setHidden:YES];
    
}




@end
