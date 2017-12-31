//
//  ModifyTeamNameViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/31.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ModifyTeamNameViewController.h"

@interface ModifyTeamNameViewController ()

@end

@implementation ModifyTeamNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"编辑舞队名称";
    self.view.backgroundColor = kBackgroundColor;
    self.bgView.layer.borderWidth = .5;
    self.bgView.layer.borderColor = kLineColor.CGColor;
    
    [self setRightItemTitle:@"完成" action:@selector(finishAction)];
    
    self.textField.text = self.team.teamName;
}

- (void)finishAction {
    if (!self.textField.text.length) {
        [self toast:@"舞队名称不能为空"];
        return;
    }
    [[NIMSDK sharedSDK].teamManager updateTeamName:self.textField.text teamId:self.team.teamId completion:^(NSError * _Nullable error) {
        if (!error) {
            [self toast:@"编辑舞队名称成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self toast:@"编辑舞队名称失败"];
        }
    }];
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
