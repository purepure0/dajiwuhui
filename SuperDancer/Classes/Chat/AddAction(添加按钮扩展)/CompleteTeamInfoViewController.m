//
//  CompleteTeamInfoViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/17.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "CompleteTeamInfoViewController.h"
#import "DisForTeamEditViewController.h"
#import "CompleteTeamInfoCell.h"

@interface CompleteTeamInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong)NSMutableArray *members; //成员
@property (nonatomic, strong)NSString *teamIntro; //舞队介绍
@property (nonatomic, strong)NSArray *area;
@property (nonatomic, assign)BOOL allowMemberInvite; //允许成员邀请队员


@end

@implementation CompleteTeamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"完善资料";
    _members = [NSMutableArray arrayWithObject:[SDUser sharedUser].userId];
    _allowMemberInvite = NO;
    _teamIntro = @"未填写";
    [self setRightItemTitle:@"完成" action:@selector(finishAction)];

}


- (NSArray *)data {
    if (_data == nil) {
        _data = @[
  @[@{}],
  @[@{},@{}],
  @[@{@"title": @"领队名称", @"content": [SDUser sharedUser].nickName},
    @{@"title": @"成立时间", @"content": [self createTime]},
    @{@"title": @"所在地区", @"content": @"未设置"},
    @{@"title": @"允许成员邀请队员", @"content": @""}],
  @[@{@"title": @"舞队介绍", @"content": @""}]];
    }
    return _data;
}

- (void)finishAction
{
    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
    option.name = self.teamName;
    option.type = NIMTeamTypeAdvanced;
    option.avatarUrl = self.avatarURL;
    option.joinMode = NIMTeamJoinModeNeedAuth;
    option.inviteMode = NIMTeamInviteModeManager;
    option.beInviteMode = NIMTeamBeInviteModeNeedAuth;
    NSArray *users = [NSArray arrayWithObject:[SDUser sharedUser].userId];
    [[[NIMSDK sharedSDK] teamManager] createTeam:option users:users completion:^(NSError * _Nullable error, NSString * _Nullable teamId, NSArray<NSString *> * _Nullable failedUserIds) {
        if (error == nil) {
            NSLog(@"%@--%@", teamId, failedUserIds);
        }else {
            [self toast:@"创建失败"];
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 160;
    } else if (indexPath.section == 1 || indexPath.section == 2) {

        if (indexPath.section == 1 && indexPath.row == 1) {
            return 70;
        }
        
        return 50;
    } else {
        return 90;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CompleteTeamInfoCellIdentifier0"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CompleteTeamInfoCell" owner:self options:nil][0];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SystemCellIdentifier0"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SystemCellIdentifier0"];
            }
            cell.textLabel.text = @"舞队成员";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld人", _members.count];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CompleteTeamInfoCell2"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"CompleteTeamInfoCell" owner:self options:nil][2];
            }
        }
    }
    else if (indexPath.section == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SystemCellIdentifier1"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SystemCellIdentifier1"];
        }
        
        if (indexPath.row <= 2) {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            UISwitch *s = [[UISwitch alloc] init];
            s.on = _allowMemberInvite;
            s.onTintColor = kBaseColor;
            [s addTarget:self action:@selector(swChangedvalue:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = s;
        }
        
        cell.textLabel.text = self.data[indexPath.section][indexPath.row][@"title"];
        cell.detailTextLabel.text = self.data[indexPath.section][indexPath.row][@"content"];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CompleteTeamInfoCellIdentifier1"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CompleteTeamInfoCell" owner:self options:nil][1];
        }

        ((CompleteTeamInfoCell *)cell).introduceLabel.text = _teamIntro;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        DisForTeamEditViewController *DDTVC = [[DisForTeamEditViewController alloc]init];
        [self.navigationController pushViewController:DDTVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSString *)createTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSDate *date = [NSDate date];
    return [dateFormatter stringFromDate:date];
}

- (void)swChangedvalue:(UISwitch *)sw {
    _allowMemberInvite = sw.isOn;
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
