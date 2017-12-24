//
//  TeamInfoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/20.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamInfoViewController.h"
#import "TeamJoinCell.h"
#import "GroupNoticeViewController.h"
#import "GroupVideoViewController.h"
#import "MemberManageViewController.h"
#import "AddMembersViewController.h"
#import "TeamManageViewController.h"
#import "TeamQRCodeViewController.h"

@interface TeamInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *data;

@end

@implementation TeamInfoViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    _isTeamOwner = [_team.owner isEqualToString:[SDUser sharedUser].userId];
    [self initDataSource];
}


- (void)initDataSource {
    if (_isTeamOwner) {
        _data = @[@[@{@"icon": @"pic1", @"nickname": @"舞队名称001", @"city": @"菏泽"}],
                  @[@{@"#": @"#"}],
                  @[@{@"title": @"我的舞队名片", @"content": @"未设置"},
                    @{@"#": @"#"}],
                  @[@{@"title": @"舞队管理", @"content": @""}],
                  @[@{@"title": @"聊天记录", @"content": @""}]
                  ];
    }else {
        _data = @[
                  @[@{@"icon": @"pic1", @"nickname": @"舞队名称001", @"city": @"菏泽"}],
                  @[@{@"#": @"#"}],
                  @[@{@"title": @"我的舞队名片", @"content": @"未设置"},
                    @{@"#": @"#"}],
                  @[@{@"title": @"聊天记录", @"content":@""}],
                  @[@{@"title": @"领队名称", @"content": @"舞者名称007"},
                    @{@"title": @"成立时间", @"content": @"2017-10-10"},
                    @{@"title": @"所在地区", @"content": @"山东省菏泽市牡丹区"}],
                  @[@{@"title": @"舞队介绍", @"content": @"舞队坐落于山东省菏泽市牡丹区，舞队成员有10名"}]
                  ];

    }
    
    [_tableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamJoinCell *cell = [TeamJoinCell initTableViewCellWith:tableView indexPath:indexPath joined:YES];
    
    NSDictionary *dic = _data[indexPath.section][indexPath.row];
    
    if (_isTeamOwner) {
        if (indexPath.section == 0) {
            [cell updateFirstCellWithData:dic];
        }else if (indexPath.section == 1) {
            [cell updateFourthCellWithData:dic];
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                [cell updateSecondCellWithData:dic];
                if (indexPath.row == 0) {
                    [cell showRigthArrow:YES];
                }
            }else {
                [cell updateFifthCellWithData:dic];
                __weak typeof(self) weakSelf = self;
                cell.addMemberBlock = ^{
                    AddMembersViewController *addMember = [[AddMembersViewController alloc] init];
                    [weakSelf.navigationController pushViewController:addMember animated:YES];
                };
            }
        }else if (indexPath.section == 3) {
            [cell updateSecondCellWithData:dic];
            [cell showRigthArrow:YES];
        }else {
            [cell updateSecondCellWithData:dic];
            [cell showRigthArrow:YES];
        }
    }else {
        if (indexPath.section == 0) {
            [cell updateFirstCellWithData:dic];
        }else if (indexPath.section == 1) {
            [cell updateFourthCellWithData:dic];
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                [cell updateSecondCellWithData:dic];
                if (indexPath.row == 0) {
                    [cell showRigthArrow:YES];
                }
            }else {
                [cell updateFifthCellWithData:dic];
            }
        }else if (indexPath.section == 3) {
            [cell updateSecondCellWithData:dic];
            [cell showRigthArrow:YES];
            
        }else if (indexPath.section == 4) {
            [cell updateSecondCellWithData:dic];
            if (indexPath.row == 0) {
                [cell showRigthArrow:YES];
            }
        }else {
            [cell updateThirdCellWithData:dic];
            
        }
    }
    
    
#pragma mark - 公告/视频/投票/签到
    // 公告/视频/投票/签到
    @weakify(self);
    [cell setHandleBtnBlock:^(NSInteger index) {
        @strongify(self);
        switch (index) {
            case 10:
            {//群公告
                GroupNoticeViewController *gn = [[GroupNoticeViewController alloc] init];
                [self.navigationController pushViewController:gn animated:YES];
            }
                break;
            case 11:
            {//群视频
                GroupVideoViewController *gv = [[GroupVideoViewController alloc] init];
                [self.navigationController pushViewController:gv animated:YES];
            }
                break;
            case 12:
                break;
            case 13:
                break;
            default:
                break;
        }
    }];
    
#pragma mark - 舞队二维码
    [cell setQRCodeBlock:^{
        @strongify(self);
        TeamQRCodeViewController *qRCode = [[TeamQRCodeViewController alloc] init];
        [self.navigationController pushViewController:qRCode animated:YES];
    }];
    
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
    
    if (section == _data.count - 1) {
        return 75;
    }
    return 0.1;
    
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isTeamOwner) {
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                NSLog(@"舞队名片");
            }else {
                
            }
        }else if (indexPath.section == 3) {//舞队管理
            TeamManageViewController *tm = [[TeamManageViewController alloc] init];
            tm.team = self.team; //123 id = 239423354
//            PPLog(@"team id = %@",self.team.teamId);
            [self.navigationController pushViewController:tm animated:YES];
        }else if (indexPath.section == 4){
            NSLog(@"聊天记录");
        }
    }else {
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                NSLog(@"舞队名片");
            }else {
                MemberManageViewController *memberMag = [[MemberManageViewController alloc] init];
                [self.navigationController pushViewController:memberMag animated:YES];
            }
        }else if (indexPath.section == 3) {
            NSLog(@"聊天记录");
        }else  if (indexPath.section == 4) {
            if (indexPath.row == 0) {
                NSLog(@"领队名称");
            }

        }
    }
}




- (void)sendMessage:(UIButton *)btn {
    NSLog(@"发送消息");
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
