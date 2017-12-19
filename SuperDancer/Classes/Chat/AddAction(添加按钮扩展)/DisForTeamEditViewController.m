//
//  DisForTeamEditViewController.m
//  SuperDancer
//
//  Created by 王司坤 on 2017/12/1.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "DisForTeamEditViewController.h"


@interface DisForTeamEditViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *dicOfTeamTextView;
@property (weak, nonatomic) IBOutlet UILabel *strNumLastLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation DisForTeamEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"舞队介绍";
    if (_teamIntro.length != 0) {
        _dicOfTeamTextView.text = _teamIntro;
        _placeholderLabel.hidden = YES;
        _strNumLastLabel.text = [NSString stringWithFormat:@"%ld", 30 - _teamIntro.length];
    }
    [self setRightItemTitle:@"完成" action:@selector(editEndAndGoPushAction)];
    self.view.backgroundColor = kBackgroundColor;
    self.dicOfTeamTextView.delegate = self;
}

#pragma mark------UITextViewDelegate

//-(void)textViewDidBeginEditing:(UITextView *)textView{
//    if ([textView.text isEqualToString:@"输入舞队介绍"]) {
//        self.dicOfTeamTextView.text = @"";
//        self.dicOfTeamTextView.textColor = kTextBlackColor;
//    }
//}
//-(void)textViewDidEndEditing:(UITextView *)textView{
//    if ([textView.text isEqualToString:@""]) {
//        self.dicOfTeamTextView.text = @"输入舞队介绍";
//        self.dicOfTeamTextView.textColor = [UIColor darkTextColor];
//    }
//}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeholderLabel.hidden = NO;
    }else {
        _placeholderLabel.hidden = YES;
    }
    NSInteger lastNum = 30 - self.dicOfTeamTextView.text.length;
    if(lastNum<0){
        [DJWYAlertView showOneButtonWithTitle:@"系统提示" message:@"超过文字个数限制" buttonTitle:@"知道了"];
        self.dicOfTeamTextView.text = [self.dicOfTeamTextView.text substringToIndex:30];
    }else{
        self.strNumLastLabel.text = [NSString stringWithFormat:@"%ld",(long)lastNum];
    }
}

#pragma mark------ACTION

- (void)editEndAndGoPushAction {
    if (_editFinised) {
        if (_dicOfTeamTextView.text.length == 0) {
            _editFinised(@"未填写");
        }else {
            _editFinised(_dicOfTeamTextView.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
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
