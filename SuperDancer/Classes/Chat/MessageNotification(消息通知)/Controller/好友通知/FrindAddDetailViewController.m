//
//  FrindAddDetailViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/26.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "FrindAddDetailViewController.h"
#import "FriendAddDetailCell.h"
#import "RefuseApplyOrInviteViewController.h"
#import "FriendChatViewController.h"
@interface FrindAddDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy)NSString *avatarUrl;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *tel;
@property (nonatomic, copy)NSString *signature;
@end

@implementation FrindAddDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@", _model.notification.sourceID);
    self.fd_prefersNavigationBarHidden = YES;
    
    _avatarUrl = [NSString new];
    _nickname = @"昵称";
    _tel = @"未设置";
    _signature = @"未设置";

    [self initDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)initDataSource {
    [self showLoading];
    
    [PPNetworkHelper POST:NSStringFormat(@"%@%@", kApiPrefix, kGetUserInfoByUserId) parameters:@{@"uid": _model.notification.sourceID} success:^(id responseObject) {
        [self hideLoading];
        NSLog(@"%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *userInfo = responseObject[@"data"][@"res"];
            _avatarUrl = userInfo[@"user_headimg"];
            _nickname = userInfo[@"nick_name"];
            _tel = userInfo[@"user_tel"];
            _signature = userInfo[@"signature"];
            [_tableView reloadData];
        }else {
            [self toast:@"获取用户信息失败"];
            [_tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self hideLoading];
        [self toast:@"获取用户信息失败"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendAddDetailCell *cell = [FriendAddDetailCell initTableViewCellWith:tableView indexPath:indexPath];
    if (indexPath.section == 0) {
        [cell updateFirstCellWithAvatarUrl:_avatarUrl nickname:_nickname];
    }else if (indexPath.section == 1) {
        [cell updateSecondCellWithTitle:@"手机号码" content:_tel];
    }else {
        [cell updateThirdCellWithTitle:@"个人签名" introduction:_signature];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 60;
    }
    return 0.1;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        if (_model.notification.type == NIMSystemNotificationTypeFriendAdd) {//好友请求
            if (_model.operation == NIMUserOperationRequest) {
                if (_model.notification.handleStatus == 0) {//未处理
                    return [self untreated];
                }
            }
        }else if (_model.notification.type == NIMSystemNotificationTypeTeamApply) {//入队申请
            if (_model.notification.handleStatus == 0) {
                return [self untreated];
            }
        }

    }
    return nil;
}

- (UIView *)untreated {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
    CGFloat width = (kScreenSize.width - 45) / 2;
    UIButton *refuseBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, width, 45)];
    [refuseBtn setTitle:@"拒 绝" forState:UIControlStateNormal];
    [refuseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    refuseBtn.layer.masksToBounds = YES;
    refuseBtn.layer.cornerRadius = 3;
    refuseBtn.layer.borderWidth = 1;
    refuseBtn.layer.borderColor = kLineColor.CGColor;
    [refuseBtn addTarget:self action:@selector(refuseAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:refuseBtn];
    
    UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 * 2 + width, 15, width, 45)];
    [agreeBtn setTitle:@"同 意" forState:UIControlStateNormal];
    agreeBtn.backgroundColor = kColorRGB(75, 169, 39);
    agreeBtn.layer.masksToBounds = YES;
    agreeBtn .layer.cornerRadius = 4;
    [agreeBtn addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:agreeBtn];
    return view;

}


- (void)refuseAction:(UIButton *)btn {
    RefuseApplyOrInviteViewController *refuseApply = [[RefuseApplyOrInviteViewController alloc] init];
    refuseApply.title = @"拒绝申请";
    refuseApply.model = _model;
    [self.navigationController pushViewController:refuseApply animated:YES];
}

- (void)agreeAction:(UIButton *)btn {
    NSLog(@"同意");
    [self showLoading];
    if (_model.notification.type == NIMSystemNotificationTypeFriendAdd) {
        NIMUserRequest *request = [[NIMUserRequest alloc] init];
        request.userId = _model.notification.sourceID;
        request.operation = NIMUserOperationVerify;
        [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
            [self hideLoading];
            if (error) {
                [self toast:error.localizedDescription];
            }else {
                [self toast:@"通过申请"];
                _model.notification.handleStatus = 1;
            }
            [_tableView reloadData];
        }];
    }else if (_model.notification.type == NIMSystemNotificationTypeTeamApply) {
        [[NIMSDK sharedSDK].teamManager passApplyToTeam:_model.notification.targetID userId:_model.notification.sourceID completion:^(NSError * _Nullable error, NIMTeamApplyStatus applyStatus) {
            [self hideLoading];
            if (error) {
                [self toast:error.localizedDescription];
            }else {
                [self toast:@"通过申请"];
                _model.notification.handleStatus = 1;
            }
            [_tableView reloadData];
        }];
    }
    
}


- (void)sendMessage:(UIButton *)btn {
    NSLog(@"发消息");
    NIMSession *session = [NIMSession session:_model.notification.sourceID type:NIMSessionTypeP2P];
    FriendChatViewController *fChat = [[FriendChatViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:fChat animated:YES];
}

- (void)addFriend:(UIButton *)btn {
    NSLog(@"添加好友");
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = _model.notification.sourceID;
    request.operation = NIMUserOperationRequest;
    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
        NSLog(@"error:%@", error);
        if (!error) {
            [self toast:@"申请发送成功"];
        }else {
            [self toast:error.description];
        }
    }];
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    
    //            else if (_model.notification.handleStatus == 1) {//已同意
    //                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
    //                UIButton *sendMessage = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width / 2 - 50, 15, 100, 45)];
    //                [sendMessage setTitle:@"发消息" forState:UIControlStateNormal];
    //                sendMessage.backgroundColor = kColorRGB(75, 169, 39);
    //                sendMessage.layer.masksToBounds = YES;
    //                sendMessage .layer.cornerRadius = 4;
    //                [sendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    //                [view addSubview:sendMessage];
    //                return view;
    //            }else {//被拒绝
    //                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
    //                UIButton *addFriend = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width / 2 - 50, 15, 100, 45)];
    //                [addFriend setTitle:@"添加好友" forState:UIControlStateNormal];
    //                [addFriend setTitle:@"发消息" forState:UIControlStateNormal];
    //                addFriend.backgroundColor = kColorRGB(75, 169, 39);
    //                addFriend.layer.masksToBounds = YES;
    //                addFriend .layer.cornerRadius = 4;
    //                [addFriend addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    //                [view addSubview:addFriend];
    //                return view;
    //            }
    
//}
//        else if (_model.operation == NIMUserOperationVerify) {
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
//            UIButton *sendMessage = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width / 2 - 50, 15, 100, 45)];
//            [sendMessage setTitle:@"发消息" forState:UIControlStateNormal];
//            sendMessage.backgroundColor = kColorRGB(75, 169, 39);
//            sendMessage.layer.masksToBounds = YES;
//            sendMessage .layer.cornerRadius = 4;
//            [sendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
//            [view addSubview:sendMessage];
//            return view;
//        }else if (_model.operation == NIMUserOperationReject) {
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
//            UIButton *addFriend = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width / 2 - 50, 15, 100, 45)];
//            [addFriend setTitle:@"添加好友" forState:UIControlStateNormal];
//            [addFriend setTitle:@"发消息" forState:UIControlStateNormal];
//            addFriend.backgroundColor = kColorRGB(75, 169, 39);
//            addFriend.layer.masksToBounds = YES;
//            addFriend .layer.cornerRadius = 4;
//            [addFriend addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
//            [view addSubview:addFriend];
//            return view;
//        }
