//
//  TeamJoinViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamJoinViewController.h"
#import "TeamJoinCell.h"
#import "RefuseApplyOrInviteViewController.h"
#import "GroupNoticeViewController.h"
//#import "GroupVideoViewController.h"
@interface TeamJoinViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign)JoinState joinState;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *data;
@end

@implementation TeamJoinViewController

- (instancetype)initWithJoinState:(JoinState)joinSate {
    if (self = [super init]) {
        _joinState = joinSate;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.fd_prefersNavigationBarHidden = YES;
    [self initDataSource];
}


- (void)initDataSource {
    if (_joinState == JoinStateJoined) {
        _data = @[
                  @[@{@"icon": @"pic1", @"nickname": @"舞队名称001", @"city": @"菏泽"}],
                  @[@{@"#": @"#"}],
                  @[@{@"title": @"领队名称", @"content": @"舞者名称007"},
                    @{@"#": @"#"}],
                  @[@{@"title": @"聊天记录"}],
                  @[@{@"title": @"领队名称", @"content": @"舞者名称007"},
                    @{@"title": @"成立时间", @"content": @"2017-10-10"},
                    @{@"title": @"所在地区", @"content": @"山东省菏泽市牡丹区"}],
                  @[@{@"title": @"舞队介绍", @"content": @"舞队坐落于山东省菏泽市牡丹区，舞队成员有10名"}]
                  ];
        
    }else {
        _data = @[
                  @[@{@"icon": @"pic1", @"nickname": @"舞队名称001", @"city": @"菏泽"}],
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
    BOOL joined = NO;
    if (_joinState == JoinStateJoined) {
        joined = YES;
    }
    TeamJoinCell *cell = [TeamJoinCell initTableViewCellWith:tableView indexPath:indexPath joined:joined];

    //13011022106
    //13011021878
    NSDictionary *dic = _data[indexPath.section][indexPath.row];
    
    if (_joinState != JoinStateJoined) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            [cell updateFirstCellWithData:dic];
        }else if (indexPath.section == 2) {
            [cell updateThirdCellWithData:dic];
        }else {
            [cell updateSecondCellWithData:dic];
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
        }else if (indexPath.section == 5) {
            [cell updateThirdCellWithData:dic];
        }else {
            [cell updateSecondCellWithData:dic];
            if (indexPath.row == 0) {
                [cell showRigthArrow:YES];
            }
            
        }
    }
//#pragma mark - 公告/视频/投票/签到
//    // 公告/视频/投票/签到
//    @weakify(self);
//    [cell setHandleBtnBlock:^(NSInteger index) {
//        @strongify(self);
//        switch (index) {
//            case 10:
//            {//群公告
//                GroupNoticeViewController *gn = [[GroupNoticeViewController alloc] init];
//                [self.navigationController pushViewController:gn animated:YES];
//            }
//                break;
//            case 11:
//            {//群视频
////                GroupVideoViewController *gv = [[GroupVideoViewController alloc] init];
////                [self.navigationController pushViewController:gv animated:YES];
//            }
//                break;
//            case 12:
//                break;
//            case 13:
//                break;
//            default:
//                break;
//        }
//    }];

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
    if (_joinState == JoinStateJoined) {
        if (section == 5) {
            return 75;
        }
    }else {
        if (section == 2) {
            return 75;
        }
    }

    return 0.1;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == _data.count - 1) {
        if (_joinState == JoinStateJoined) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, kScreenSize.width - 30, 45)];
            [btn setTitle:@"发送消息" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = kColorRGB(120, 23, 165);
            [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            return view;
        }else if (_joinState == JoinStateWillJoin) {
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
            agreeBtn .layer.cornerRadius = 3;
            [agreeBtn addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:agreeBtn];
            return view;
        }
    }
    return nil;
    
}

- (void)agreeAction:(UIButton *)btn {
    NSLog(@"同意");
}


- (void)refuseAction:(UIButton *)btn {
    RefuseApplyOrInviteViewController *refuseApply = [[RefuseApplyOrInviteViewController alloc] init];
    refuseApply.title = @"拒绝邀请";
    [self.navigationController pushViewController:refuseApply animated:YES];
    
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
