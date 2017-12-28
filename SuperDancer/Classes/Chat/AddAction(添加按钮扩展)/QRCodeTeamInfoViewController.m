//
//  QRCodeTeamInfoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/28.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "QRCodeTeamInfoViewController.h"
#import "ApplyDetailCell.h"
#import "TeamSessionViewController.h"
@interface QRCodeTeamInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *data;

@property (nonatomic, copy)NSString *avatarUrl;
@property (nonatomic, copy)NSString *teamName;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *teamLeader;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *intro;


@end

@implementation QRCodeTeamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _avatarUrl = @"";
    _teamName = @"舞队名称";
    _city = @"城市";
    _teamLeader = @"领队";
    _createTime = @"2017-01-01";
    _address = @"活动区域";
    _intro = @"未填写";
    [self initDataSource];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)initDataSource {
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:_teamID completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
        if (!error) {
            NSLog(@"team:%@", team);
            weakSelf.avatarUrl = team.avatarUrl;
            weakSelf.teamName = team.teamName;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-mm-dd";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:team.createTime];
            weakSelf.createTime = [formatter stringFromDate:date];
            if (team.clientCustomInfo == NULL) {
                weakSelf.city = @"未设置";
                weakSelf.address = @"未设置";
            }else {
                NSArray *data = [NSJSONSerialization JSONObjectWithData:[team.clientCustomInfo dataUsingEncoding:NSUTF8StringEncoding] options:0 error:0];
                NSDictionary *teamInfo = [NSMutableArray arrayWithArray:data].lastObject;
                NSArray *localityArray = [teamInfo[@"locality"] componentsSeparatedByString:@","];
                weakSelf.city = localityArray[1];
                
                weakSelf.address = [NSString stringWithFormat:@"%@%@%@", localityArray[0], localityArray[1], localityArray[2]];
            }
            
            
            weakSelf.intro = team.intro;
            [_tableView reloadData];
            [[NIMSDK sharedSDK].userManager fetchUserInfos:@[team.owner] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
                if (!error) {
                    NIMUser *user = users[0];
                    weakSelf.teamLeader = user.userInfo.nickName;
                    [_tableView reloadData];
                }
            }];
            NSLog(@"%@--%@--%@--%@--%@--%@--%@", weakSelf.avatarUrl, weakSelf.teamName, weakSelf.city, weakSelf.teamLeader, weakSelf.createTime, weakSelf.address, weakSelf.intro);
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 3;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyDetailCell *cell = [ApplyDetailCell initTableViewCellWith:tableView indexPath:indexPath];
    if (indexPath.section == 0) {
        [cell updateFirstCellWithAvatarUrl:_avatarUrl nickname:_teamName city:_city];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell updateSecondCellWithTitle:@"领队名称" content:_teamLeader];
        }else if (indexPath.row == 1) {
            [cell updateSecondCellWithTitle:@"成立时间" content:_createTime];
        }else {
            [cell updateSecondCellWithTitle:@"所在地区" content:_address];
        }
    }else {
        [cell updateThirdCellWithTitle:@"舞队介绍" content:_intro];
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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
        if ([[NIMSDK sharedSDK].teamManager isMyTeam:_teamID]) {
            UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, kScreenSize.width - 30, 45)];
            [agreeBtn setTitle:@"发送消息" forState:UIControlStateNormal];
            agreeBtn.backgroundColor = kColorRGB(75, 169, 39);
            agreeBtn.layer.masksToBounds = YES;
            agreeBtn .layer.cornerRadius = 3;
            [agreeBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:agreeBtn];
        }else {
            UIButton *applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, kScreenSize.width - 30, 45)];
            [applyBtn setTitle:@"申请入群" forState:UIControlStateNormal];
            applyBtn.backgroundColor = kColorRGB(75, 169, 39);
            applyBtn.layer.masksToBounds = YES;
            applyBtn .layer.cornerRadius = 3;
            [applyBtn addTarget:self action:@selector(teamApply:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:applyBtn];
        }
        return view;
    }
    return nil;
    
}

- (void)teamApply:(UIButton *)btn {
    [[NIMSDK sharedSDK].teamManager applyToTeam:_teamID message:@"加群" completion:^(NSError * _Nullable error, NIMTeamApplyStatus applyStatus) {
        if (error) {
            [self toast:error.localizedDescription];
        }else {
            [self toast:@"申请成功,等待验证通过！"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (void)sendMessage:(UIButton *)btn {
    
    NIMSession *session = [NIMSession session:_teamID type:NIMSessionTypeTeam];
    TeamSessionViewController *teamSession = [[TeamSessionViewController alloc] initWithSession:session];
    teamSession.teamID = _teamID;
    [self.navigationController pushViewController:teamSession animated:YES];
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
