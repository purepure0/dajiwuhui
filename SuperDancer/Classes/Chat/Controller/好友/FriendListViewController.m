//
//  FriendListViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/23.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendListCell.h"
#import "FriendChatViewController.h"
@interface FriendListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *friendList;
@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"好友";
    [self setRightImageNamed:@"wd_nav_btn_add" action:@selector(addFriend)];
    [self getFriendList];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"FriendListCell" bundle:nil] forCellReuseIdentifier:@"FriendListCellIdentifier"];
}

- (void)getFriendList {
    _friendList = [[NIMSDK sharedSDK].userManager myFriends];
    NSLog(@"好友列表：%@", _friendList);
    
}

- (void)addFriend {
    NSLog(@"加好友");
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = @"81692";
    request.operation = NIMUserOperationAdd;
    request.message = @"添加好友";
    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
        NSLog(@"error:%@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NIMUser *user = _friendList[indexPath.row];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:user.userInfo.avatarUrl] placeholder:[UIImage imageNamed:@"pic1"]];
    cell.nicknameLabel.text = user.userInfo.nickName;
    cell.detailLabel.text = user.userInfo.sign;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NIMUser *user = _friendList[indexPath.row];
    NIMSession *session = [NIMSession session:user.userId type:NIMSessionTypeP2P];
    FriendChatViewController *fChat = [[FriendChatViewController alloc] initWithSession:session];
    fChat.user = user;
    [self.navigationController pushViewController:fChat animated:YES];
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
