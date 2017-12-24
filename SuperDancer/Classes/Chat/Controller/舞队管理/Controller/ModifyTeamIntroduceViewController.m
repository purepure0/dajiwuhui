//
//  ModifyTeamIntroduceViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/24.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ModifyTeamIntroduceViewController.h"

@interface ModifyTeamIntroduceViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation ModifyTeamIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"编辑群介绍";
    self.view.backgroundColor = kBackgroundColor;
    self.textView.layer.borderColor = kLineColor.CGColor;
    self.textView.layer.borderWidth = .5;
    self.textView.delegate = self;
    [self setRightItemTitle:@"完成" action:@selector(finishAction)];
    
    if (self.intro.length && ![self.intro isEqualToString:@"未填写"]) {
        _textView.text = self.intro;
        _placeholderLabel.text = @"";
    }
}

- (void)finishAction {
    
    if (self.textView.text.length < 15) {
        [self toast:@"至少15字~"];
        return;
    }
//    PPLog(@"11111===%@",self.textView.text);
//    NSDictionary *introduce = @{@"introduce": self.textView.text};
//    NSData *data = [NSJSONSerialization dataWithJSONObject:@[introduce] options:0 error:nil];
//    NSString *intro = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    [[NIMSDK sharedSDK].teamManager updateTeamCustomInfo:intro teamId:self.team.teamId completion:^(NSError * _Nullable error) {
//        PPLog(@"edit introduce error === %@",error.description);
//        if (!error) {
//            [self toast:@"编辑群介绍成功"];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }];
    [[NIMSDK sharedSDK].teamManager updateTeamIntro:self.textView.text teamId:self.team.teamId completion:^(NSError * _Nullable error) {
        PPLog(@"edit introduce error === %@",error.description);
        if (!error) {
            [self.textView resignFirstResponder];
            [self toast:@"编辑群介绍成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self toast:@"编辑失败"];
        }
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    long long remainNum ;
    NSString *textContent;
    if (textView.text.length == 0) {
        _placeholderLabel.text = @"设置群介绍~";
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

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _placeholderLabel.text = @"";
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
