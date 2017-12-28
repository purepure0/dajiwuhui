//
//  AddFriendViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verMessageTF;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
}


- (IBAction)addFriend:(id)sender {
    NSLog(@"add");
    if (self.telPhoneTF.text.length < 5) {
        [self toast:@"手机号位数不能为零"];
    }else {
        [self searchFriend];
    }
}

- (void)searchFriend {
    
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kGetUserInfoByTel) parameters:@{@"tel": self.telPhoneTF.text} success:^(id responseObject) {
        NSLog(@"resp:%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSString *userID = responseObject[@"data"][@"res"][@"uid"];
            NSString *nickname = responseObject[@"data"][@"res"][@"nick_name"];
            [self sendAddRequestWithUid:userID andNickname:nickname];
        }else {
            [self toast:@"用户不存在"];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", error);
        
    }];
}

- (void)sendAddRequestWithUid:(NSString *)uid andNickname:(NSString *)nickname {
    if ([[NIMSDK sharedSDK].userManager isMyFriend:uid]) {
        [self toast:[NSString stringWithFormat:@"%@ 已经是您的好友", nickname]];
        return;
    }
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = [NSString stringWithFormat:@"%@", uid];
    request.operation = NIMUserOperationRequest;
    request.message = self.verMessageTF.text;
    
    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
        NSLog(@"error:%@", error);
        if (!error) {
            [self toast:@"申请发送成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self toast:error.description];
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
