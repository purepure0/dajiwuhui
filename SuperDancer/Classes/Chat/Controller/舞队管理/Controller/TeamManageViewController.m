//
//  TeamManageViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/22.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamManageViewController.h"
#import "ModifyTeamLocalityViewController.h"
#import "ModifyTeamNicknameViewController.h"
#import "ModifyTeamIntroduceViewController.h"
#import "ModifyTeamNameViewController.h"
#import "Utility.h"

@interface TeamManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, nonnull, strong) NSArray *titles;

@property (nonatomic, strong) NSDictionary *teamInfo;

@property (nonatomic, strong) UISwitch *inviteModeSwitch;

@property (nonatomic, strong) UILabel *introLabel;

@property (nonatomic, copy) NSString *locality;
@property (nonatomic, copy) NSString *intro;

@end

@implementation TeamManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"舞队管理";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchTeamInfo];
}

- (void)fetchTeamInfo {
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:self.team.teamId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
        self.team = team;
        PPLog(@"clientCustomInfo == %@",team.clientCustomInfo);
        if (team.clientCustomInfo.length) {
            NSArray *data = [NSJSONSerialization JSONObjectWithData:[team.clientCustomInfo dataUsingEncoding:NSUTF8StringEncoding] options:0 error:0];
            NSMutableArray *dataArray = [NSMutableArray arrayWithArray:data];
            self.teamInfo = dataArray.lastObject;
        }
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        return 105;
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.font = SYSTEM_FONT(16);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    
    if (!indexPath.section) {
        if (indexPath.row == 2 || !indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 3) {
            cell.accessoryView = self.inviteModeSwitch;
        }
    } else {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"舞队介绍";
        titleLabel.textColor = [UIColor darkTextColor];
        [cell.contentView addSubview:titleLabel];
        
        UILabel *introLabel = [[UILabel alloc] init];
        self.introLabel = introLabel;
        introLabel.textColor = [UIColor grayColor];
        introLabel.font = [UIFont systemFontOfSize:16];
        introLabel.textAlignment = NSTextAlignmentLeft;
        introLabel.numberOfLines = 0;
        [cell.contentView addSubview:introLabel];
        
        titleLabel.sd_layout
        .leftSpaceToView(cell.contentView, 15)
        .topSpaceToView(cell.contentView, 10)
        .rightSpaceToView(cell.contentView, 15)
        .heightIs(24);
        
        introLabel.sd_layout
        .leftEqualToView(titleLabel)
        .topSpaceToView(titleLabel, 5)
        .rightEqualToView(titleLabel)
        .bottomSpaceToView(cell.contentView, 5);
        [introLabel setMaxNumberOfLinesToShow:3];
    }
    
    // 更新数据
    if (!indexPath.section) {
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = self.team.teamName;
                break;
            case 1:
            {
                NSString *createTime = [Utility NSDateToString:NSStringFormat(@"%f",self.team.createTime)];
                cell.detailTextLabel.text = createTime;
            }
                break;
            case 2:
            {
                NSString *locality = [self.teamInfo[@"locality"] stringByReplacingOccurrencesOfString:@"," withString:@""];
                PPLog(@"%@",locality);
                
                if (!locality.length || locality == nil) {
                    locality = NSStringFormat(@"%@%@%@",self.users.provinceLocation,self.users.cityLocation,self.users.districtLocation);
                }
                cell.detailTextLabel.text = locality;
                self.locality = locality;
            }
                break;
            case 3:
                self.inviteModeSwitch.on = self.team.inviteMode ? YES:NO;
                break;
            default:
                break;
        }
    } else {
        NSString *intro = self.team.intro;
        if (!intro.length) {
            intro = @"未设置群公告~";
        }
        self.introLabel.text = intro;
        self.intro = intro;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        if (indexPath.row == 2) {// 所在地区
            ModifyTeamLocalityViewController *teamLocality = [[ModifyTeamLocalityViewController alloc] init];
            teamLocality.team = self.team;
            teamLocality.locality = self.locality;
            [self.navigationController pushViewController:teamLocality animated:YES];
        } else if (!indexPath.row) {// 领队名称
            ModifyTeamNameViewController *tn = [[ModifyTeamNameViewController alloc] init];
            tn.team = self.team;
            [self.navigationController pushViewController:tn animated:YES];
        }
    } else { // 群介绍
        ModifyTeamIntroduceViewController *teamIntro = [[ModifyTeamIntroduceViewController alloc] init];
        teamIntro.intro = self.intro;
        teamIntro.team = self.team;
        [self.navigationController pushViewController:teamIntro animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@[@"舞队名称",@"成立时间",@"所在地区",@"允许成员邀请队员"],@[@""]];
    }
    return _titles;
}

- (UISwitch *)inviteModeSwitch {
    if (!_inviteModeSwitch) {
        _inviteModeSwitch = [[UISwitch alloc] init];
        _inviteModeSwitch.onTintColor = kBaseColor;
        [_inviteModeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteModeSwitch;
}

- (void)switchAction:(UISwitch *)s{
    if (s.on) {
        [[NIMSDK sharedSDK].teamManager updateTeamInviteMode:NIMTeamInviteModeAll teamId:self.team.teamId completion:^(NSError * _Nullable error) {
            if (!error) {
                [self toast:@"开启允许成员邀请成员"];
            } else {
                [self toast:@"设置邀请模式失败"];
            }
        }];
    } else {
        [[NIMSDK sharedSDK].teamManager updateTeamInviteMode:NIMTeamInviteModeManager teamId:self.team.teamId completion:^(NSError * _Nullable error) {
            if (!error) {
                [self toast:@"关闭允许成员邀请成员"];
            } else {
                [self toast:@"设置邀请模式失败"];
            }
        }];
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
