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
@property (nonatomic, strong)NSDictionary *userInfo;
@property (nonatomic, assign)NSInteger sectionCount;
@end

@implementation FrindAddDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.fd_prefersNavigationBarHidden = YES;
    _sectionCount = 0;
    _userInfo = [NSDictionary new];
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
            _userInfo = responseObject[@"data"][@"res"];
            _sectionCount = 3;
            [_tableView reloadData];
        }else {
            [self toast:@"获取用户信息失败"];
            _sectionCount = 0;
            [_tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self hideLoading];
        [self toast:@"获取用户信息失败"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionCount;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendAddDetailCell *cell = [FriendAddDetailCell initTableViewCellWith:tableView indexPath:indexPath];
    if (indexPath.section == 0) {
        [cell updateFirstCellWithAvatarUrl:_userInfo[@"user_headimg"] nickname:_userInfo[@"nick_name"]];
    }else if (indexPath.section == 1) {
        [cell updateSecondCellWithTitle:@"手机号码" content:_userInfo[@"user_tel"]];
    }else {
        [cell updateThirdCellWithTitle:@"个人签名" introduction:_userInfo[@"signature"]];
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
        if (_model.operation == NIMUserOperationRequest) {//好友请求
            if (_model.notification.handleStatus == 0) {//未处理
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
    
        }
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
    }
    return nil;
}




- (void)refuseAction:(UIButton *)btn {
    RefuseApplyOrInviteViewController *refuseApply = [[RefuseApplyOrInviteViewController alloc] init];
    refuseApply.title = @"拒绝申请";
    [self.navigationController pushViewController:refuseApply animated:YES];
    
}

- (void)agreeAction:(UIButton *)btn {
    NSLog(@"同意");
    [self showLoading];
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = _model.notification.sourceID;
    request.operation = NIMUserOperationVerify;
    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
        [self hideLoading];
        if (error) {
            [MBProgressHUD showError:@"失败" toView:[UIApplication sharedApplication].keyWindow];
        }else {
            [MBProgressHUD showSuccess:@"成功" toView:[UIApplication sharedApplication].keyWindow];
            _model.notification.handleStatus = 1;
            [self.navigationController popToRootViewControllerAnimated:nil];
        }
        [_tableView reloadData];
    }];
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
