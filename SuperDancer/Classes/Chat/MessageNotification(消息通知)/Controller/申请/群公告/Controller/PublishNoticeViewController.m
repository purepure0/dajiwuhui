//
//  PublishNoticeViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/18.
//  Copyright © 2017年 yu. All rights reserved.
//  发布公告

#import "PublishNoticeViewController.h"

@interface PublishNoticeViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;


@end

@implementation PublishNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"发布公告";
    self.titleBgView.layer.borderWidth = .5;
    self.titleBgView.layer.borderColor = kLineColor.CGColor;
    self.contentTextView.layer.borderWidth = .5;
    self.contentTextView.layer.borderColor = kLineColor.CGColor;
    self.imageBgView.layer.borderWidth = .5;
    self.imageBgView.layer.borderColor = kLineColor.CGColor;
    
    self.view.backgroundColor = kBackgroundColor;
    
    [self setRightItemTitle:@"发布" action:@selector(publishGroupNoticeAction)];
}

- (void)publishGroupNoticeAction {
    PPLog(@"发布公告");
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    long long remainNum ;
    NSString *textContent;
    if (textView.text.length == 0) {
        _placeholderLabel.text = @"正文(必填)，15~500字";
    }else if(textView.text.length >= 500){
        textView.text = [textView.text substringToIndex:500];
        _placeholderLabel.text = @"";
    }else{
        _placeholderLabel.text = @"";
        textContent = textView.text;
        long long existNum = [textContent length];
        remainNum = 500 - existNum;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
    if(range.location >= 500){
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
