//
//  CommentView.h
//  SuperDancer
//
//  Created by yu on 2017/10/16.
//  Copyright © 2017年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ViewType) {
    ViewTypeComment,
    ViewTypeReply
};
typedef void(^CommitCommentBlock) (void);
typedef void(^ReplyBlock) (NSString *cid);
typedef void(^UpdateHeightBlock) (CGFloat height);

@interface CommentView : UIView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewRightSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTopSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitBtnTopSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitBtnRightSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnTopSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnLeftSpace;


@property (weak, nonatomic) IBOutlet UIButton *frontBtn;


@property (nonatomic, copy)CommitCommentBlock commitBlock;
@property (nonatomic, copy)ReplyBlock replyBlock;
@property (nonatomic, copy)UpdateHeightBlock updateHeightBlock;

@property (nonatomic, assign)ViewType viewType;

- (instancetype)initCommentViewWithFrame:(CGRect)frame andViewType:(ViewType)type;


#pragma mark -- 评论 、回复
//评论
- (void)commentWithVid:(NSString *)vid;
//回复
- (void)replyWithCId:(NSString *)cID andAuthor:(NSString *)author;


@end
