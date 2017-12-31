//
//  PublishNoticeViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/18.
//  Copyright © 2017年 yu. All rights reserved.
//  发布公告

#import "PublishNoticeViewController.h"
#define kSizeHeight (kAutoWidth(70))

@interface PublishNoticeViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

static NSString *kImageCellIdentifier = @"kImageCellIdentifier";

@implementation PublishNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"发布公告";
    self.titleBgView.layer.borderWidth = .5;
    self.titleBgView.layer.borderColor = kLineColor.CGColor;
    self.contentTextView.layer.borderWidth = .5;
    self.contentTextView.layer.borderColor = kLineColor.CGColor;
    self.view.backgroundColor = kBackgroundColor;
    
    [self setRightItemTitle:@"发布" action:@selector(publishGroupNoticeAction)];
    
    self.contentTextView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.titleBgView, 10)
    .heightIs(kAutoHeight(150));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.titleTextField endEditing:YES];
    [self.contentTextView endEditing:YES];
}

- (void)publishGroupNoticeAction {
    
    if (self.titleTextField.text.length < 4 &&self.titleTextField.text.length > 15) {
        [self toast:@"标题仅限4~15字"];
        return;
    }
    
    if (self.contentTextView.text.length < 15 && self.contentTextView.text.length > 500) {
        [self toast:@"正文仅限15~500字"];
    }
    
    [self.titleTextField endEditing:YES];
    [self.contentTextView endEditing:YES];
    NSString *title = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *content = [self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.navigationController popViewControllerAnimated:YES];
    if([self.delegate respondsToSelector:@selector(publishTeamAnnouncementCompleteWithTitle:content:)]) {
        [self.delegate publishTeamAnnouncementCompleteWithTitle:title content:content];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    CGFloat width = CGRectGetWidth(textView.frame);
    CGFloat height = CGRectGetHeight(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
    textView.frame = newFrame;

    long long remainNum ;
    NSString *textContent;
    if (textView.text.length == 0) {
        _placeholderLabel.text = @"正文(必填)，15~500字";
    }else if(textView.text.length >= 500){
        textView.text = [textView.text substringToIndex:500];
        _placeholderLabel.text = @"";
        [self toast:@"正文仅限15~500字"];
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
