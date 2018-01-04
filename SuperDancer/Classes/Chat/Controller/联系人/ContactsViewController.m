//
//  ContactsViewController.m
//  SuperDancer
//
//  Created by yu on 2018/1/2.
//  Copyright © 2018年 yu. All rights reserved.
//

#import "ContactsViewController.h"
#import "FriendChatViewController.h"
#import "TeamSessionViewController.h"
#import "ContactListCell.h"
#import "ContactHeaderView.h"
@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource, NIMUserManagerDelegate, NIMTeamManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *friendList;
@property (nonatomic, strong)NSArray *teamList;
@property (nonatomic, assign)BOOL showAllFriends;
@property (nonatomic, assign)BOOL showAllTeams;
@property (nonatomic, strong)ContactHeaderView *friendListHeader;
@property (nonatomic, strong)ContactHeaderView *teamListHeader;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    @weakify(self);
    _friendListHeader = [[ContactHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 44) andTitle:@"好友"];
    _friendListHeader.showBlock = ^(BOOL isShow) {
        _showAllFriends = isShow;
        @strongify(self);
        [self updateFriendList];
    };
    _teamListHeader = [[ContactHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 44) andTitle:@"舞队"];
    _teamListHeader.showBlock = ^(BOOL isShow) {
        _showAllTeams = isShow;
        @strongify(self);
        [self updateTeamList];
    };
    
    [self updateFriendList];
    [self updateTeamList];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 10)];
    view.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = view;
    [_tableView registerNib:[UINib nibWithNibName:@"FriendListCell" bundle:nil] forCellReuseIdentifier:@"FriendListCellIdentifier"];
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    [[NIMSDK sharedSDK].teamManager addDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataSource) name:NOTIFICATION_USER_HAS_LOGIN object:nil];
}


- (void)dealloc {
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
    [[NIMSDK sharedSDK].teamManager removeDelegate:self];
}

- (void)updateDataSource {
    [self showLoading];
    [self updateFriendList];
    [self updateTeamList];
    [self hideLoading];
}

- (void)updateFriendList {
    _friendList = [[NIMSDK sharedSDK].userManager myFriends];
    [_tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    PPLog(@"%@", _friendList);
}

- (void)updateTeamList {
    _teamList = [[[NIMSDK sharedSDK] teamManager] allMyTeams];
    [_tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
    PPLog(@"%@", _teamList);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_showAllFriends) {
            return _friendList.count;
        }else {
            return 0;
        }
    }else {
        if (_showAllTeams) {
            return _teamList.count;
        }else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactListCell *cell = [[ContactListCell alloc] initCellWithTableView:tableView indexPath:indexPath];
    if (indexPath.section == 0) {
        NIMUser *user = _friendList[indexPath.row];
        NSString *info = user.userInfo.sign ? :@"暂无个人简介~";
        NSString *name = user.userInfo.nickName;
        NSString *imageUrl = user.userInfo.avatarUrl;
        [cell updateCellWithName:name info:info imageUrl:imageUrl];
    }else {
        NIMTeam *team = _teamList[indexPath.row];
        NSString *info = @"所在地区：未设置";
        if (team.clientCustomInfo != nil) {
            NSLog(@"%@", team.clientCustomInfo);
            NSArray *data = [NSJSONSerialization JSONObjectWithData:[team.clientCustomInfo dataUsingEncoding:NSUTF8StringEncoding] options:0 error:0];
            if (data != nil) {
                NSDictionary *teamInfo = [NSMutableArray arrayWithArray:data].lastObject;
                NSString *area = [teamInfo[@"locality"] stringByReplacingOccurrencesOfString:@"," withString:@""];
                info = [NSString stringWithFormat:@"所在地区：%@", area];
            }
        }
        
        NSString *name = team.teamName;
        NSString *imageUrl = team.avatarUrl;
        PPLog(@"%@%@%@", info, name, imageUrl);
        [cell updateCellWithName:name info:info imageUrl:imageUrl];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        _friendListHeader.titleLabel.text = [NSString stringWithFormat:@"好友(%ld)", _friendList.count];
        return _friendListHeader;
    }else {
        _teamListHeader.titleLabel.text = [NSString stringWithFormat:@"舞队(%ld)", _teamList.count];
        return _teamListHeader;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NIMUser *user = _friendList[indexPath.row];
        NIMSession *session = [NIMSession session:user.userId type:NIMSessionTypeP2P];
        FriendChatViewController *fChat = [[FriendChatViewController alloc] initWithSession:session];
        fChat.user = user;
        [self.navigationController pushViewController:fChat animated:YES];
    }else {
        NIMTeam *team = _teamList[indexPath.row];
        NIMSession *session = [NIMSession session:team.teamId type:NIMSessionTypeTeam];
        TeamSessionViewController *vc = [[TeamSessionViewController alloc] initWithSession:session];
        vc.team = team;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//好友相关代理
/**
 *  好友状态发生变化 (在线)
 *  @param user 用户对象
 */
- (void)onFriendChanged:(NIMUser *)user {
    [self updateFriendList];
}

/**
 *  黑名单列表发生变化 (在线)
 */
- (void)onBlackListChanged {
    [self updateFriendList];
}

/**
 *  静音列表发生变化 (在线)
 */
- (void)onMuteListChanged {
    [self updateFriendList];
}

/**
 *  用户个人信息发生变化 (在线)
 *
 *  @param user 用户对象
 *  @discussion 出于性能和上层 APP 处理难易度的考虑，本地调用批量接口获取用户信息时不触发当前回调。
 */
- (void)onUserInfoChanged:(NIMUser *)user {
    [self updateFriendList];
}


//群组相关代理
/**
 *  群组增加回调
 *  @param team 添加的群组
 */
- (void)onTeamAdded:(NIMTeam *)team {
    [self updateTeamList];
}

/**
 *  群组更新回调
 *  @param team 更新的群组
 */
- (void)onTeamUpdated:(NIMTeam *)team {
    [self updateTeamList];
}

/**
 *  群组移除回调
 *  @param team 被移除的群组
 */
- (void)onTeamRemoved:(NIMTeam *)team {
    [self updateTeamList];
}

/**
 *  群组成员变动回调,包括数量增减以及成员属性变动
 *  @param team 变动的群组
 */
- (void)onTeamMemberChanged:(NIMTeam *)team {
    [self updateTeamList];
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
