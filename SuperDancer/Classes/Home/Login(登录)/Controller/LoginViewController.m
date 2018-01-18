//
//  LoginViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/7.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "LoginViewController.h"
#import "BindingMobileViewController.h"
#import "SCVerifyButton.h"
#import "Utility.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UMSocialWechatHandler.h>

#import "UserAgreeViewController.h"


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top2;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UITextField *verifTextField;

@property (weak, nonatomic) IBOutlet SCVerifyButton *verifBtn;

@property (weak, nonatomic) IBOutlet UIButton *WXBtn;

// 手机号是否合法
@property (nonatomic, assign) BOOL isTelValid;

@property (nonatomic, strong) NSDictionary *result;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.top.constant = kAutoHeight(80);
    self.top2.constant = kAutoHeight(54);
    self.fd_prefersNavigationBarHidden = YES;
}

/** 获取验证码*/
- (IBAction)vertifyBtnAction:(id)sender
{
    [self.mobileTextField resignFirstResponder];
    [self.verifTextField resignFirstResponder];
    [self.requestManager fetchVerifyCodeByMobile:self.mobileTextField.text success:^ (NSDictionary *restut){
        PPLog(@"%@",restut);
        [self toast:restut[@"message"]];
        self.result = restut;
    } failure:^(NSString *error) {
        [self toast:error];
    }];
}
- (IBAction)textFieldChanged:(UITextField *)sender {
    self.verifBtn.enabled = [Utility valiMobile:sender.text];
}

/** 手机号登录*/
- (IBAction)loginAction:(id)sender
{
    [self.mobileTextField resignFirstResponder];
    [self.verifTextField resignFirstResponder];
    
    // 退出界面，token会失效
    NSString *token = self.result[@"data"][@"token"] == nil ? @"":self.result[@"data"][@"token"];
    //    PPLog(@"token = %@",self.result[@"token"]);
    if ([Utility valiMobile:self.mobileTextField.text] == NO) {
        [self toast:@"请输入正确手机号"];
        return;
    } else {
        if (self.verifTextField.text.length != 4) {
            [self toast:@"请输入正确验证码"];
            return;
        }
        if (token.length == 0) {
            [self toast:@"验证码失效,请重新获取"];
            return;
        }
    }
    
    [self.hud show:YES];
    [self.requestManager loginByMobile:self.mobileTextField.text code:self.verifTextField.text token:token success:^(NSDictionary *result) {
        [self.hud hide:YES];
        NSLog(@"%@",result);
        NSString *code = NSStringFormat(@"%@",result[@"code"]);
        if (![code isEqualToString:@"0"]) {
            [self toast:result[@"message"]];
        } else {
            [self toast:@"登录成功"];
            //登录IM
            [self loginNIMSDK];
            //设置请求头
            [self updateHttpHeader];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_HAS_LOGIN object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AcountBtnImgNotification" object:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSString *error) {
        [self.hud hide:YES];
        [self toast:error];
    }];
}

/** 微信绑定手机号*/
- (IBAction)WXLoginAction:(id)sender
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            PPLog(@"%@", error);
        }else {
            UMSocialUserInfoResponse *userInfo = result;
            NSLog(@"%@--%@--%@", userInfo.unionId, userInfo.iconurl, userInfo.name);
            NSDictionary *body = @{@"unionid": userInfo.unionId,
                                   @"nick_name": userInfo.name,
                                   @"head_img": userInfo.iconurl};
            [self showLoading];
            [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kWchatLogin) parameters:body success:^(id responseObject) {
                PPLog(@"%@", responseObject);
                NSString *code = NSStringFormat(@"%@", responseObject[@"code"]);
                [self hideLoading];
                if ([code isEqualToString:@"0"]) {
                    NSString *tel = responseObject[@"data"][@"tel"];
                    if (tel.length != 0) {
                        self.users.userId = NSStringFormat(@"%@",responseObject[@"data"][@"uid"]);
                        self.users.token = NSStringFormat(@"%@",responseObject[@"data"][@"token"]);
                        [MBProgressHUD showSuccess:@"登录成功" toView:self.view];
                        //登录IM
                        [self loginNIMSDK];
                        //设置请求头
                        [self updateHttpHeader];
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_HAS_LOGIN object:nil];
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }else {
                        BindingMobileViewController *binding = [[BindingMobileViewController alloc] init];
                        binding.uid = NSStringFormat(@"%@",responseObject[@"data"][@"uid"]);
                        binding.token = NSStringFormat(@"%@",responseObject[@"data"][@"token"]);
                        [self.navigationController pushViewController:binding animated:YES];
                    }
                }
            } failure:^(NSError *error) {
                [self hideLoading];
                PPLog(@"%@", error.description);
            }];
        }
    }];
}

/** 用户协议*/
- (IBAction)agreementAction:(id)sender
{
    UserAgreeViewController *agreement = [[UserAgreeViewController alloc] init];
    [self.navigationController pushViewController:agreement animated:YES];
}

- (IBAction)returnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVerifBtn:(SCVerifyButton *)verifBtn
{
    _verifBtn = verifBtn;
    _verifBtn.layer.borderWidth = 0.5;
    _verifBtn.layer.borderColor = kColorHexStr(@"#BD10E0").CGColor;
    [_verifBtn setCountdown:3];

    _verifBtn.enabled = NO;
}

- (void)setWXBtn:(UIButton *)WXBtn
{
    _WXBtn = WXBtn;
    _WXBtn.layer.borderWidth = 0.5;
    _WXBtn.layer.borderColor = kColorHexStr(@"#8C32B4").CGColor;
    
    _WXBtn.imageView.sd_layout
    .centerYEqualToView(_WXBtn)
    .heightRatioToView(_WXBtn, 0.45)
    .autoWidthRatio(1.1);
    
    _WXBtn.titleLabel.sd_layout
    .centerYEqualToView(_WXBtn)
    .leftSpaceToView(_WXBtn.imageView, 7);
}

- (void)setMobileTextField:(UITextField *)mobileTextField
{
    _mobileTextField = mobileTextField;
    _mobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"点击输入手机号" attributes:@{NSFontAttributeName:SYSTEM_FONT(13),NSForegroundColorAttributeName:kColorHexStr(@"#BDBDBD")}];
}

- (void)setVerifTextField:(UITextField *)verifTextField
{
    _verifTextField = verifTextField;
    _verifTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"点击输入验证码" attributes:@{NSFontAttributeName:SYSTEM_FONT(13),NSForegroundColorAttributeName:kColorHexStr(@"#BDBDBD")}];
}


- (void)loginNIMSDK {
    SDUser *user = [SDUser sharedUser];
    //用户userId对应IM的account
    [[[NIMSDK sharedSDK] loginManager] login:user.userId token:user.token completion:^(NSError * _Nullable error) {
        PPLog(@"网易云信登录error：%@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IMConnected" object:@""];
    }];
    
}




@end
