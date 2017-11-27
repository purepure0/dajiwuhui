//
//  BindingMobileViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/10.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "BindingMobileViewController.h"
#import "SCVerifyButton.h"

@interface BindingMobileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

@property (weak, nonatomic) IBOutlet SCVerifyButton *verifyBtn;

//是否已经绑定手机号
@property (nonatomic, assign)BOOL isConnnect;

@end

@implementation BindingMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定手机号";
    //初始状态为：未绑定
    _isConnnect = NO;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.users.userId = self.uid;
    self.users.token = self.token;
    [self updateHttpHeader];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"消失");
    if (!_isConnnect) {
        self.users.userId = nil;
        self.users.token = nil;
        [self updateHttpHeader];
    }
}


- (IBAction)bingingMobileAction:(id)sender
{
    if (_mobileTextField.text.length < 11 || _verifyTextField.text.length < 6) {
        [MBProgressHUD showError:@"请确认手机号和验证码！" toView:self.view];
        return;
    }
    [self showLoading];
    NSDictionary *body = @{@"mobile": _mobileTextField.text,
                           @"code": _verifyTextField.text
                           };
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kCheckCode) parameters:body success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        [self hideLoading];
        NSString *code = NSStringFormat(@"%@", responseObject[@"code"]);
        if ([code isEqualToString:@"0"]) {
            
            self.users.userId = responseObject[@"data"][@"uid"];
            self.users.token = responseObject[@"data"][@"token"];;
            [self updateHttpHeader];
            _isConnnect = YES;
            [MBProgressHUD showSuccess:@"登录成功" toView:kKeyWindow];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }];
        }else {
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
        NSLog(@"%@", responseObject);
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
    PPLog(@"绑定");
}

- (void)setVerifyBtn:(SCVerifyButton *)verifyBtn
{
    _verifyBtn = verifyBtn;
    _verifyBtn.layer.borderWidth = 0.5;
    _verifyBtn.layer.borderColor = kColorHexStr(@"#BD10E0").CGColor;
    [_verifyBtn setCountdown:59];
}

- (void)setMobileTextField:(UITextField *)mobileTextField
{
    _mobileTextField = mobileTextField;
    _mobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"点击输入手机号" attributes:@{NSFontAttributeName:SYSTEM_FONT(13),NSForegroundColorAttributeName:kColorHexStr(@"#BDBDBD")}];
}

- (void)setVerifyTextField:(UITextField *)verifyTextField
{
    _verifyTextField = verifyTextField;
    _verifyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"点击输入验证码" attributes:@{NSFontAttributeName:SYSTEM_FONT(13),NSForegroundColorAttributeName:kColorHexStr(@"#BDBDBD")}];
}


- (IBAction)sendVerifyCode:(id)sender {
    if (_mobileTextField.text.length < 11) {
        [MBProgressHUD showError:@"请确认手机号！" toView:self.view];
        return;
    }
    [self showLoading];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kGetCode) parameters:@{@"mobile": _mobileTextField.text} success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        [self hideLoading];
        NSString *code = NSStringFormat(@"%@", responseObject[@"code"]);
        if ([code isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:responseObject[@"message"] toView:self.view];
        }else {
            [MBProgressHUD showError:responseObject[@"message"] toView:self.view];
        }
    } failure:^(NSError *error) {
        PPLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
