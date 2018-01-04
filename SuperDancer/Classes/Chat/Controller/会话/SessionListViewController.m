//
//  SessionListViewController.m
//  SuperDancer
//
//  Created by yu on 2018/1/2.
//  Copyright © 2018年 yu. All rights reserved.
//

#import "SessionListViewController.h"
#import "TeamSessionViewController.h"
#import "FriendChatViewController.h"
@interface SessionListViewController ()

@end

@implementation SessionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会话列表";
    self.tableView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - 49);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSession:) name:@"kDeleteSessionNotification" object:nil];
    
}

- (void)removeSession:(NSNotification *)noti {
    PPLog(@"noti:%@", noti.userInfo);
    PPLog(@"%@--%@", [self.recentSessions class], self.recentSessions);
    NSString *sessionId = noti.userInfo[@"teamID"];
    NIMRecentSession *delSession = nil;
    for (NIMRecentSession *recentSession in self.recentSessions) {
        if ([recentSession.session.sessionId isEqualToString:sessionId]) {
            delSession = recentSession;
        }
    }
    if (delSession != nil) {
        [[NIMSDK sharedSDK].conversationManager deleteRecentSession:delSession];
        [self refresh];
    }
}




- (void)refresh {
    [super refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onSelectedRecent:(NIMRecentSession *)recentSession atIndexPath:(NSIndexPath *)indexPath{
    if (recentSession.session.sessionType == NIMSessionTypeTeam) {
        TeamSessionViewController *teamSession = [[TeamSessionViewController alloc] initWithSession:recentSession.session];
        teamSession.team = [[NIMSDK sharedSDK].teamManager teamById:recentSession.session.sessionId];
        teamSession.teamID = recentSession.session.sessionId;
        [self.navigationController pushViewController:teamSession animated:YES];
    }else if (recentSession.session.sessionType == NIMSessionTypeP2P) {
        FriendChatViewController *friendChat = [[FriendChatViewController alloc] initWithSession:recentSession.session];
        friendChat.user = [[NIMSDK sharedSDK].userManager userInfo:recentSession.session.sessionId];
        [self.navigationController pushViewController:friendChat animated:YES];
    }
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
