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
@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource>
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
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"FriendListCell" bundle:nil] forCellReuseIdentifier:@"FriendListCellIdentifier"];
    
}

- (void)updateFriendList {
    _friendList = [[NIMSDK sharedSDK].userManager myFriends];
    [_tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    PPLog(@"%@", _friendList);
}

- (void)updateTeamList {
    _teamList = [[[NIMSDK sharedSDK] teamManager] allMyTeams];
    [_tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
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
