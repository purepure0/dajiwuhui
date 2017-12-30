//
//  ModifyTeamNicknameViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ModifyTeamNicknameViewController.h"

@interface ModifyTeamNicknameViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ModifyTeamNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的舞队名片";
    self.view.backgroundColor = kBackgroundColor;
    
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = kLineColor.CGColor;
    
    [self setRightItemTitle:@"完成" action:@selector(finishAction)];
   
    if ([self.nickname isEqualToString:@"未设置"])
    {
        self.nickname = @"";
    }
    self.textField.text = self.nickname;
}

- (void)finishAction
{
    if (!self.textField.text.length)
    {
        return;
    }
    
    [[NIMSDK sharedSDK].teamManager updateUserNick:self.users.userId newNick:self.textField.text inTeam:self.team.teamId completion:^(NSError * _Nullable error) {
        if (!error) {
            [self toast:@"我的舞队名片修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self toast:@"我的舞队名片修改失败"];
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
