//
//  PublicNoticeListViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "PublicNoticeListViewController.h"
#import "PublicNoticeListCell.h"
#import "PublicNoticeDetailViewController.h"
@interface PublicNoticeListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *publicNoticeList;
@end

@implementation PublicNoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息详情";
    _publicNoticeList = @[
                          @{@"title": @"系统公告", @"content": @"平台于2017年10月10日正式上…", @"date": @"2017-10-10"},
                          @{@"title": @"系统公告", @"content": @"平台于2017年10月10日正式上…", @"date": @"2017-10-10"},
                          @{@"title": @"系统公告", @"content": @"平台于2017年10月10日正式上…", @"date": @"2017-10-10"}
                          ];
    [_tableView registerNib:[UINib nibWithNibName:@"PublicNoticeListCell" bundle:nil] forCellReuseIdentifier:@"PublicNoticeListCellIdentifier"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PublicNoticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublicNoticeListCellIdentifier" forIndexPath:indexPath];
    
    [cell updateCellWithData:_publicNoticeList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PublicNoticeDetailViewController *detail = [[PublicNoticeDetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
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
