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
#import "AddFriendViewController.h"
@interface FriendListViewController ()<UITableViewDelegate, UITableViewDataSource, NIMUserManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *friendList;
@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"好友";
    [self setRightImageNamed:@"wd_nav_btn_add" action:@selector(addFriend)];
    [self getFriendList];
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"FriendListCell" bundle:nil] forCellReuseIdentifier:@"FriendListCellIdentifier"];
}

- (void)getFriendList {
    _friendList = (NSMutableArray *)[[NIMSDK sharedSDK].userManager myFriends];
    NSLog(@"好友列表：%@", _friendList);
    
}

- (void)addFriend {
    NSLog(@"加好友");
    AddFriendViewController *addFri = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:addFri animated:YES];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NIMUser *user = _friendList[indexPath.row];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:user.userInfo.avatarUrl] placeholder:[UIImage imageNamed:@"pic1"]];
    NSLog(@"%@--%@", user.userInfo.avatarUrl, user.userInfo.thumbAvatarUrl);
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



//删除好友
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NIMUser *user = _friendList[indexPath.row];
        [[NIMSDK sharedSDK].userManager deleteFriend:user.userId completion:^(NSError * _Nullable error) {
            if (!error) {
                [_friendList removeObjectAtIndex:indexPath.row];
                [_tableView deleteRow:indexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationFade];
                [self toast:@"删除成功"];
            }else {
                [self toast:@"删除失败"];
            }
        }];
        
    }
}

- (void)onFriendChanged:(NIMUser *)user {
    NSLog(@"%@", user);
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
