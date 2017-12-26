//
//  RefuseApplyViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "RefuseApplyOrInviteViewController.h"

@interface RefuseApplyOrInviteViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placeHolder;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation RefuseApplyOrInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setRightItemTitle:@"完成" action:@selector(sendReason)];
    self.view.backgroundColor = kColorRGB(237, 237, 237);
    _textView.backgroundColor = [UIColor whiteColor];
    [_textView becomeFirstResponder];
    
}

- (void)sendReason {
    [self showLoading];
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = _model.notification.sourceID;
    request.operation = NIMUserOperationReject;
    request.message = _textView.text;
    
    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
        [self hideLoading];
        if (error) {
            [MBProgressHUD showError:@"发送失败" toView:[UIApplication sharedApplication].keyWindow];
        }else {
            [MBProgressHUD showSuccess:@"发送成功" toView:[UIApplication sharedApplication].keyWindow];
            _model.notification.handleStatus = 2;
            [self.navigationController popToRootViewControllerAnimated:nil];
        }
    }];
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.textView.text = @"";
        self.textView.textColor = kTextBlackColor;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.textView.text = @"请填写拒绝的原因!";
        self.textView.textColor = [UIColor darkTextColor];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([self.textView.text isEqualToString:@"请填写拒绝的原因!"]) {
        self.wordNumberLabel.text = @"30";
    }else{
        NSInteger lastNum = 30 - self.textView.text.length;
        if(lastNum<0){
            [DJWYAlertView showOneButtonWithTitle:@"系统提示" message:@"超过文字个数限制" buttonTitle:@"知道了"];
            self.textView.text = [self.textView.text substringToIndex:30];
        }else{
            self.wordNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)lastNum];
        }
        
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
