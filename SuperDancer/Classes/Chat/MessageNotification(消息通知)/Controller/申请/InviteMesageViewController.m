//
//  InviteMesageViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/15.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "InviteMesageViewController.h"
#import "ApplyMessageListCell.h"
#import "TeamJoinViewController.h"
@interface InviteMesageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *inviteList;
@end

@implementation InviteMesageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"申请消息";
    _inviteList = @[
                   @{@"name": @"舞者名称1", @"icon": @"pic1", @"content": @"邀请您加入 舞队名称1", @"note":@"我是舞者张某某", @"apply": @"0"},
                   @{@"name": @"舞者名称2", @"icon": @"pic1", @"content": @"邀请您加入 舞队名称2", @"note":@"我是舞者张某某", @"apply": @"1"},
                   @{@"name": @"舞者名称1", @"icon": @"pic1", @"content": @"邀请您加入 舞队名称3", @"note":@"我是舞者张某某", @"apply": @"2"}];
    [_tableView registerNib:[UINib nibWithNibName:@"ApplyMessageListCell" bundle:nil] forCellReuseIdentifier:@"ApplyMessageListCellIdentifier"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplyMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyMessageListCellIdentifier" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellWithData:_inviteList[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamJoinViewController *teamJoin = nil;
    if (indexPath.row == 0) {
        teamJoin = [[TeamJoinViewController alloc] initWithJoinState:JoinStateWillJoin];
    }else if (indexPath.row == 1) {
        teamJoin = [[TeamJoinViewController alloc] initWithJoinState:JoinStateJoined];
    }else {
        teamJoin = [[TeamJoinViewController alloc] initWithJoinState:JoinStateRefused];
    }
    [self.navigationController pushViewController:teamJoin animated:YES];
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
