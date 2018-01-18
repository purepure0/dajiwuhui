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
@interface SessionListViewController ()<NIMTeamManagerDelegate>
@property (nonatomic,strong) UIImageView *emptyTipImgView;
@end

@implementation SessionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会话列表";
    self.tableView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - 49);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[NIMSDK sharedSDK].teamManager addDelegate:self];
    self.tableView.backgroundColor = kBackgroundColor;
    self.view.backgroundColor = kBackgroundColor;
    
    self.emptyTipImgView = [[UIImageView alloc] init];
    self.emptyTipImgView.image = IMAGE_NAMED(@"nodata");
    [self.view addSubview:self.emptyTipImgView];
    self.emptyTipImgView.hidden = self.recentSessions.count;
    self.emptyTipImgView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    .heightIs(120)
    .widthIs(109);
}


- (void)refresh {
    [super refresh];
    self.emptyTipImgView.hidden = self.recentSessions.count;    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//- (void)onTeamRemoved:(NIMTeam *)team {
//    PPLog(@"onTeamRemoved = %@",team.teamName);
//
//}
//
//- (void)onTeamMemberChanged:(NIMTeam *)team {
//    PPLog(@"onTeamMemberChanged = %@",team.teamName);
//}

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
