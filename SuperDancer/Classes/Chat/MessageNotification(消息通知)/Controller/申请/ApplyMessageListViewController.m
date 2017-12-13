//
//  ApplyMessageListViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ApplyMessageListViewController.h"
#import "ApplyMessageListCell.h"
#import "ApplyMessageDetailViewController.h"

@interface ApplyMessageListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *applyList;
@end

@implementation ApplyMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"申请消息";
    _applyList = @[
                   @{@"name": @"舞者名称1", @"icon": @"pic1", @"content": @"申请加入 舞队名称1", @"note":@"我是舞者张某某", @"apply": @"0"},
                   @{@"name": @"舞者名称2", @"icon": @"pic1", @"content": @"申请加入 舞队名称2", @"note":@"我是舞者张某某", @"apply": @"1"},
                   @{@"name": @"舞者名称1", @"icon": @"pic1", @"content": @"申请加入 舞队名称3", @"note":@"我是舞者张某某", @"apply": @"2"}];
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
    [cell updateCellWithData:_applyList[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplyMessageDetailViewController *detail = [[ApplyMessageDetailViewController alloc] init];
    
    [self.navigationController pushViewController:detail animated:YES];
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
