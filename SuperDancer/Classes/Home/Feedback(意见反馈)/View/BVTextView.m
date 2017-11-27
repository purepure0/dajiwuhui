//
//  BVTextView.m
//  BuyVegetable
//
//  Created by yushanchang on 16/10/7.
//  Copyright © 2016年 com.yinding. All rights reserved.
//

#import "BVTextView.h"

@interface BVTextView ()<UITextViewDelegate>

@end

@implementation BVTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textColor = [UIColor blueColor];
        self.delegate = self;
        [self resignFirstResponder];
        [self layoutUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.textColor = [UIColor blueColor];
        self.delegate = self;
        [self resignFirstResponder];
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.frame = CGRectMake(5, 11, kScreenWidth - 10 * 3, 10);
    _placeholderLabel.text = @"您想对卖家说点什么...";
    _placeholderLabel.font = [UIFont systemFontOfSize:14];
    _placeholderLabel.textColor = kColorHexStr(@"#BDBDBD");
    [self addSubview:_placeholderLabel];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.frame = CGRectMake(kScreenWidth - 60 - 10 - 5, 170 - 20, 60, 20);
    _numLabel.text = @"0/100";
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.font = [UIFont systemFontOfSize:13];
    _numLabel.textColor = kColorHexStr(@"#BDBDBD");
    [self addSubview:_numLabel];
}

#pragma mark -
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    long long remainNum ;
    NSString * textContent;
    if (textView.text.length == 0) {
        _placeholderLabel.text = @"您想对卖家说点什么...";
        _numLabel.text = [NSString stringWithFormat:@"0/100"];
    }else if(textView.text.length >= 100){
        textView.text = [textView.text substringToIndex:100];
        _placeholderLabel.text = @"";
        _numLabel.text = [NSString stringWithFormat:@"100/0"];
    }else{
        _placeholderLabel.text = @"";
        textContent = textView.text;
        long long existNum = [textContent length];
        remainNum = 100 - existNum;
        _numLabel.text = [NSString stringWithFormat:@"%lld/%lld",existNum,remainNum];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
    if(range.location >= 100){
        return NO;
    }
    return YES;
}
@end
