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
#import "TeamNotiListViewController.h"
#import "FriendNotiListViewController.h"
#import "IMSystemNotificationClassifier.h"
@interface MessageNotiViewController ()<UITableViewDelegate, UITableViewDataSource, NIMSystemNotificationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *messageData;
@property (nonatomic, strong)NSMutableArray *notifications;

@property (nonatomic, strong)NSArray *teamNotifications;
@property (nonatomic, strong)NSArray *friendNotifications;
@property (nonatomic, assign)NSInteger teamUnreadCount;
@property (nonatomic, assign)NSInteger friendUnreadCount;
@end

@implementation MessageNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息通知";
    _messageData = @[
                     @{@"title": @"系统公告", @"img": @"xx_ico_inform", @"unreadCount": @"0"},
                     @{@"title": @"舞队通知", @"img": @"xx_ico_apply"},
                     @{@"title": @"好友通知", @"img": @"xx_ico_invite"}
                     ];
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"MessageNotiCell" bundle:nil] forCellReuseIdentifier:@"MessageNotiCellIdentifier"];
    
    
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[@"81516"] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        NSLog(@"user:%@", users);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchNotidications];
}

- (void)fetchNotidications {
    _notifications = [NSMutableArray new];
    NSArray * notifications = [[NIMSDK sharedSDK].systemNotificationManager fetchSystemNotifications:nil limit:20];
    if (notifications.count != 0) {
        [_notifications addObjectsFromArray:notifications];
    }
    
    _teamNotifications = [IMSystemNotificationClassifier typeTeam:_notifications];
    _friendNotifications = [IMSystemNotificationClassifier typeFriend:_notifications];
    
    [_tableView reloadData];
}


- (void)onReceiveSystemNotification:(NIMSystemNotification *)notification {
    PPLog(@"%ld", notification.type);
    [self fetchNotidications];
   
}

- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount {
    PPLog(@"%ld", unreadCount);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageNotiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageNotiCellIdentifier" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _messageData[indexPath.row];
    if (indexPath.row == 0) {
        [cell updateCellWithData:dic];
    }else if (indexPath.row ==1) {
        [cell updateCellWithData:dic andNotifications:_teamNotifications];
    }else {
        [cell updateCellWithData:dic andNotifications:_friendNotifications];
    }
    
    
    
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
        TeamNotiListViewController *teamNotiListVC = [[TeamNotiListViewController alloc] init];
        teamNotiListVC.notifications = _teamNotifications;
        [self.navigationController pushViewController:teamNotiListVC animated:YES];
    }else {
        FriendNotiListViewController *friendNotiListVC = [[FriendNotiListViewController alloc] init];
        friendNotiListVC.notifications = _friendNotifications;
        [self.navigationController pushViewController:friendNotiListVC animated:YES];
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
