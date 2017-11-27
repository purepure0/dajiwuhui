//
//  EditNickNameViewController.m
//  SuperDancer
//
//  Created by yu on 2017/10/26.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "EditNickNameViewController.h"

@interface EditNickNameViewController ()

@end

@implementation EditNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kColorRGB(249, 249, 249);
    self.nickNameTextFiled.text = self.nickNameLabel.text;

    self.navigationItem.title = @"昵称";
    [self setRightItemTitle:@"保存" action:@selector(saveAction)];
    
}

- (void)saveAction {
    
    if ([self.nickNameLabel.text isEqualToString:self.nickNameTextFiled.text]) {
        [MBProgressHUD showError:@"请先修改昵称！" toView:self.view];
        return;
    }
    [self hideLoading];
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kUserUpdata) parameters:@{@"nick_name": _nickNameTextFiled.text} success:^(id responseObject) {
        [self hideLoading];
        NSLog(@"%@", responseObject);
        NSString *code = NSStringFormat(@"%@", responseObject[@"code"]);
        
        if ([code isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:responseObject[@"message"] toView:self.view];
            self.nickNameLabel.text = responseObject[@"data"][@"res"][@"nick_name"];
            [self.navigationController popViewControllerAnimated:YES];
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
