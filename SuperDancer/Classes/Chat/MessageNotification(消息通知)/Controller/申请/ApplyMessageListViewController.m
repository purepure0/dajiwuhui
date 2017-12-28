//
//  ApplyMessageListViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "ApplyMessageListViewController.h"
#import "ApplyMessageListCell.h"

#import "IMNotificationModel.h"
@interface ApplyMessageListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *modelList;

@end

@implementation ApplyMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"好友通知";
//    _applyList = @[
//                   @{@"name": @"舞者名称1", @"icon": @"pic1", @"content": @"申请加入 舞队名称1", @"note":@"我是舞者张某某", @"apply": @"0"},
//                   @{@"name": @"舞者名称2", @"icon": @"pic1", @"content": @"申请加入 舞队名称2", @"note":@"我是舞者张某某", @"apply": @"1"},
//                   @{@"name": @"舞者名称1", @"icon": @"pic1", @"content": @"申请加入 舞队名称3", @"note":@"我是舞者张某某", @"apply": @"2"}];
    [self initDataSource];
    [_tableView registerNib:[UINib nibWithNibName:@"ApplyMessageListCell" bundle:nil] forCellReuseIdentifier:@"ApplyMessageListCellIdentifier"];
    
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
//    ApplyMessageDetailViewController *detail = [[ApplyMessageDetailViewController alloc] init];
//    
//    [self.navigationController pushViewController:detail animated:YES];
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
