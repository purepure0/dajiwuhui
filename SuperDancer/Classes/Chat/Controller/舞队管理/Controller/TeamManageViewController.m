//
//  TeamManageViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/22.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "TeamManageViewController.h"
#import "ModifyTeamLocalityViewController.h"
#import "ModifyLeaderNameViewController.h"

@interface TeamManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonnull, strong) NSArray *data;
@end

@implementation TeamManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"舞队管理";
    _data = @[
  @[@{@"title":@"领队名称",@"text":@"舞者名称111111111"},@{@"title":@"成立时间",@"text":@"2017-10-10"},@{@"title":@"所在地区",@"text":@"山东菏泽牡丹区"},@{@"title":@"允许成员邀请队员",@"text":@""}],
  @[@{@"title":@"",@"text":@""}]];
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
    cell.textLabel.text = self.data[indexPath.section][indexPath.row][@"title"];
    cell.detailTextLabel.text = self.data[indexPath.section][indexPath.row][@"text"];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.font = SYSTEM_FONT(16);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!indexPath.section) {
        if (!indexPath.row || indexPath.row == 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 3) {
            UISwitch *s = [[UISwitch alloc] init];
            s.on = YES;
            s.onTintColor = kBaseColor;
            cell.accessoryView = s;
        }
    }
    
    if (indexPath.section) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = @"舞队介绍";
        [cell.contentView addSubview:textLabel];
        
        UILabel *detailTextLabel = [[UILabel alloc] init];
        detailTextLabel.text = @"111山东菏泽牡丹区山东菏泽牡丹区山东菏泽牡丹区山东菏泽牡丹区,山东菏泽牡丹区,山东菏泽牡丹区,山东菏泽牡丹区***222山东菏泽牡丹区山东菏泽牡丹区山东菏泽牡丹区山东菏泽牡丹区,山东菏泽牡丹区,山东菏泽牡丹区,山东菏泽牡丹区666";
        detailTextLabel.textColor = [UIColor grayColor];
        detailTextLabel.font = [UIFont systemFontOfSize:16];
        detailTextLabel.textAlignment = NSTextAlignmentLeft;
        detailTextLabel.numberOfLines = 0;
        [cell.contentView addSubview:detailTextLabel];
        
        textLabel.sd_layout
        .leftSpaceToView(cell.contentView, 15)
        .topSpaceToView(cell.contentView, 10)
        .rightSpaceToView(cell.contentView, 15)
        .heightIs(24);
        
        detailTextLabel.sd_layout
        .leftEqualToView(textLabel)
        .topSpaceToView(textLabel, 5)
        .rightEqualToView(textLabel)
        .bottomSpaceToView(cell.contentView, 5);
        [detailTextLabel setMaxNumberOfLinesToShow:3];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        if (indexPath.row == 2) {// 所在地区
            ModifyTeamLocalityViewController *loc = [[ModifyTeamLocalityViewController alloc] init];
            [self.navigationController pushViewController:loc animated:YES];
        } else if (!indexPath.row) {// 领队名称
            ModifyLeaderNameViewController *leaderName = [[ModifyLeaderNameViewController alloc] init];
            [self.navigationController pushViewController:leaderName animated:YES];
        }
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
