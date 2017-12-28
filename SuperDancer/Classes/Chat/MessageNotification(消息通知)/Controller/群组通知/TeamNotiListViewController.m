//
//  TeamNotiListViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/27.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamNotiListViewController.h"
#import "ApplyMessageListCell.h"
#import "IMNotificationModel.h"
#import "TeamSimpleInfoViewController.h"
#import "FrindAddDetailViewController.h"
@interface TeamNotiListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *modelList;
@end

@implementation TeamNotiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"舞队通知";
    [self initDataSource];
    [_tableView registerNib:[UINib nibWithNibName:@"ApplyMessageListCell" bundle:nil] forCellReuseIdentifier:@"ApplyMessageListCellIdentifier"];
    _tableView.tableFooterView = [UIView new];
}

- (void)initDataSource {
    _modelList = [NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NIMSystemNotification *noti in _notifications) {
            IMNotificationModel *model = [[IMNotificationModel alloc] initWithSystemNotification:noti];
            [_modelList addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplyMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyMessageListCellIdentifier" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    IMNotificationModel *model = _modelList[indexPath.row];
    
    //展示之后通知设为已读
    [[NIMSDK sharedSDK].systemNotificationManager markNotificationsAsRead:model.notification];
    [cell updateCellWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IMNotificationModel *model = _modelList[indexPath.row];
    if ((model.notification.type == NIMSystemNotificationTypeTeamInvite) || (model.notification.type == NIMSystemNotificationTypeTeamApplyReject)) {
        TeamSimpleInfoViewController *teamInfo = [[TeamSimpleInfoViewController alloc] init];
        teamInfo.model = model;
        [self.navigationController pushViewController:teamInfo animated:YES];
    }else if ((model.notification.type == NIMSystemNotificationTypeTeamApply) || (model.notification.type == NIMSystemNotificationTypeTeamIviteReject)) {
        FrindAddDetailViewController *friendDetail = [[FrindAddDetailViewController alloc] init];
        friendDetail.model = model;
        [self.navigationController pushViewController:friendDetail animated:YES];
    }
    
}

//删除通知
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        IMNotificationModel *model = _modelList[indexPath.row];
        NSLog(@"%ld", indexPath.row);
        NSLog(@"%ld", _modelList.count);
        [_modelList removeObjectAtIndex:indexPath.row];
        [_tableView deleteRow:indexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationFade];
        [[NIMSDK sharedSDK].systemNotificationManager deleteNotification:model.notification];
    }
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
