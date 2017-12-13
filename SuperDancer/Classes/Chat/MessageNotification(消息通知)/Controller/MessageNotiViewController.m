//
//  MessageNotiViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/12.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "MessageNotiViewController.h"
#import "MessageNotiCell.h"
#import "PublicNoticeListViewController.h"
#import "ApplyMessageListViewController.h"
@interface MessageNotiViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *messageData;
@end

@implementation MessageNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息通知";
    _messageData = @[
                     @{@"title": @"系统公告", @"img": @"xx_ico_inform", @"lastMessage": @"平台于2017年10月10日正式上…", @"date": @"2017-10-10", @"unreadCount": @"1"},
                     @{@"title": @"申请消息", @"img": @"xx_ico_apply", @"lastMessage": @"舞者张某某申请加入 舞队名称1", @"date": @"2017-10-10", @"unreadCount": @"0"},
                     @{@"title": @"邀请消息", @"img": @"xx_ico_invite", @"lastMessage": @"舞者张某某邀请您加入 舞队名称2", @"date": @"2017-10-10", @"unreadCount": @"3"}
                     ];
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"MessageNotiCell" bundle:nil] forCellReuseIdentifier:@"MessageNotiCellIdentifier"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageNotiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageNotiCellIdentifier" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _messageData[indexPath.row];
    [cell updateCellWithData:dic];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PublicNoticeListViewController *publicNoticeList = [[PublicNoticeListViewController alloc] init];
        [self.navigationController pushViewController:publicNoticeList animated:YES];
        
    }else if (indexPath.row == 1) {
        ApplyMessageListViewController *applyMessage = [[ApplyMessageListViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:applyMessage animated:YES];
        self.hidesBottomBarWhenPushed = NO;
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
