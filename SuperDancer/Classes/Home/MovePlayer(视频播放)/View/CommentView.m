//
//  CommentView.m
//  SuperDancer
//
//  Created by yu on 2017/10/16.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView
{
    NSString *_cID;
}

- (instancetype)initCommentViewWithFrame:(CGRect)frame andViewType:(ViewType)type {
    self = [[[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:nil options:nil] lastObject];
    
    self.viewType = type;
    self.commentTextView.delegate = self;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 18;
    if (self.viewType == ViewTypeReply) {
        [self setHidden:YES];
    }
    return self;
    
}

//发送
- (IBAction)commitComment:(id)sender {
    if (self.viewType == ViewTypeComment) {
        if (self.commitBlock) {
            self.commitBlock();
        }
    }else {
        if (self.replyBlock) {
            self.replyBlock(_cID);
        }
    }
}

//取消
- (IBAction)cancelAction:(id)sender {
    [self.commentTextView resignFirstResponder];
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"begin");
    if (self.viewType == ViewTypeReply) {
        [self setHidden:NO];
    }
    [self.frontBtn setHidden:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.bgViewTopSpace.constant = 40;
        self.bgViewRightSpace.constant = 15;
        self.commitBtnTopSpace.constant = 10;
        self.cancelBtnTopSpace.constant = 10;
        if (self.updateHeightBlock) {
            self.updateHeightBlock(54.0 + 31.0);
        }
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"end");
    if (self.viewType == ViewTypeReply) {
        [self setHidden:YES];
    }
    [self.frontBtn setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        self.bgViewTopSpace.constant = 9;
        self.bgViewRightSpace.constant = 65;
        self.commitBtnTopSpace.constant = 17;
        self.cancelBtnTopSpace.constant = 17;
        if (self.updateHeightBlock) {
            self.updateHeightBlock(54.0);
        }
    }];
}


- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"change");
    
    textView.scrollEnabled = NO;
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }
    else if(!self.placeholderLabel.hidden){
        self.placeholderLabel.hidden = YES;
    }
    static CGFloat maxHeight = 80.0f;
    static CGFloat minHeight = 36.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    NSLog(@"%f", size.height);
    if (size.height <= minHeight) {
        NSLog(@"<");
        if (_updateHeightBlock) {
            _updateHeightBlock(85);
        }
    }
    else if(size.height > minHeight){
        NSLog(@">");
        if (size.height >= maxHeight)
        {
            
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
            CGFloat h = size.height - frame.size.height;
            
            if (_updateHeightBlock) {
                _updateHeightBlock(self.frame.size.height + h);
            }
        }
    }
}

#pragma mark -- 评论 、回复
- (void)commentWithVid:(NSString *)vid {
    self.placeholderLabel.text = @"我也说一句...";
    [self.commentTextView becomeFirstResponder];
}

- (void)replyWithCId:(NSString *)cID andAuthor:(NSString *)author {
    [self setHidden:NO];
    _cID = cID;
    self.placeholderLabel.text = [NSString stringWithFormat:@"@%@:", author];
    [self.commentTextView becomeFirstResponder];
}



@end
