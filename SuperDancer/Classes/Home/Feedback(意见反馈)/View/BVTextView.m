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
        self.textColor = kTextBlackColor;
        self.delegate = self;
        [self resignFirstResponder];
        [self layoutUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.textColor = kTextBlackColor;
        self.delegate = self;
        [self resignFirstResponder];
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.text = @"您想对我们说点什么...";
    _placeholderLabel.font = [UIFont systemFontOfSize:14];
    _placeholderLabel.textColor = kColorHexStr(@"#BDBDBD");
    [self addSubview:_placeholderLabel];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.text = @"0/100";
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.font = [UIFont systemFontOfSize:13];
    _numLabel.textColor = kColorHexStr(@"#BDBDBD");
    [self addSubview:_numLabel];
    
    
    _placeholderLabel.sd_layout
    .leftSpaceToView(self, 5)
    .rightSpaceToView(self, 5)
    .topSpaceToView(self, 10)
    .heightIs(10);
    
    _numLabel.sd_layout
    .rightSpaceToView(self, 15)
    .bottomSpaceToView(self, 10)
    .widthIs(100)
    .heightIs(20);
}

#pragma mark -
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    long long remainNum ;
    NSString * textContent;
    if (textView.text.length == 0) {
        _placeholderLabel.text = @"您想对我们说点什么...";
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
