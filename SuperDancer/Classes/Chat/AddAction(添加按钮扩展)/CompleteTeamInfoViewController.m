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

@end

@implementation CompleteTeamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"完善资料";
    [self setRightItemTitle:@"完成" action:@selector(finishAction)];
    
    
}

- (NSArray *)data {
    if (_data == nil) {
        _data = @[
  @[@{}],
  @[@{},@{}],
  @[@{@"title": @"领队名称", @"content": @"舞者名称11"},
    @{@"title": @"成立时间", @"content": @"2017-10-10"},
    @{@"title": @"所在地区", @"content": @"山东省菏泽市牡丹区"},
    @{@"title": @"允许成员邀请队员", @"content": @""}],
  @[@{@"title": @"舞队介绍", @"content": @"舞队坐落于山东省菏泽市牡丹区，舞队成员有10名"}]];
    }
    return _data;
}

- (void)finishAction
{
    
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
            cell.detailTextLabel.text = @"1人";
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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            UISwitch *s = [[UISwitch alloc] init];
            s.on = YES;
            s.onTintColor = kBaseColor;
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

        ((CompleteTeamInfoCell *)cell).introduceLabel.text = @"嚼啊嚼啊纠结啊嚼啊嚼阿姐阿姐啊纠结啊嚼啊嚼阿姐啊嚼啊嚼阿姐啊纠结啊阿姐啊嚼啊嚼阿姐啊姐姐啊啊纠结啊嚼啊嚼嚼啊嚼啊姐姐阿姐啊嚼啊嚼阿姐啊纠结啊嚼啊嚼阿姐啊嚼啊嚼123";
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
    if (section == 0) {
        return 0.01;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
