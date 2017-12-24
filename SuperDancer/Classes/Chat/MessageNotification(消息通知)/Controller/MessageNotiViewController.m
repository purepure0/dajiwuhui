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
#import "InviteMesageViewController.h"
@interface MessageNotiViewController ()<UITableViewDelegate, UITableViewDataSource, NIMSystemNotificationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *messageData;
@property (nonatomic, strong)NSMutableArray *notifications;
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
    
    _notifications = [NSMutableArray new];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    NSArray * notifications = [[NIMSDK sharedSDK].systemNotificationManager fetchSystemNotifications:nil limit:20];
    if (notifications.count != 0) {
        [_notifications addObjectsFromArray:notifications];
    }
    NSLog(@"%@", _notifications);
    for (NIMSystemNotification *systemNoti in _notifications) {
        id obj = systemNoti.attachment;
        if ([obj isKindOfClass:[NIMUserAddAttachment class]]) {
            NIMUserOperation operation = [(NIMUserAddAttachment *)obj operationType];
            switch (operation) {
                case NIMUserOperationAdd:
                    NSLog(@"直接加好友");
                    break;
                case NIMUserOperationRequest:
                    NSLog(@"请求加好友");
                    break;
                case NIMUserOperationVerify:
                    NSLog(@"确认加好友");
                    break;
                case NIMUserOperationReject:
                    NSLog(@"拒绝加好友");
                    break;
                default:
                    break;
            }
        }
        NSLog(@"%@--%@--%@", systemNoti.sourceID, systemNoti.targetID, systemNoti.notifyExt);
    }
}



- (void)onReceiveSystemNotification:(NIMSystemNotification *)notification {
    PPLog(@"%ld", notification.type);
    
    id obj = notification.attachment;
    if ([obj isKindOfClass:[NIMUserAddAttachment class]]) {
        NIMUserOperation operation = [(NIMUserAddAttachment *)obj operationType];
        switch (operation) {
            case NIMUserOperationAdd:
                NSLog(@"直接加好友");
                break;
            case NIMUserOperationRequest:
                NSLog(@"请求加好友");
                break;
            case NIMUserOperationVerify:
                NSLog(@"确认加好友");
                break;
            case NIMUserOperationReject:
                NSLog(@"拒绝加好友");
                break;
            default:
                break;
        }
    }
    
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
        [self.navigationController pushViewController:applyMessage animated:YES];
    }else {
        InviteMesageViewController *inviteMessage = [[InviteMesageViewController alloc] init];
        [self.navigationController pushViewController:inviteMessage animated:YES];
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
