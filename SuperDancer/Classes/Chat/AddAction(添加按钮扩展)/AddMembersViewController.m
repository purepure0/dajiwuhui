//
//  AddMembersViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/19.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "AddMembersViewController.h"
#import "FriendListCell.h"
@interface AddMembersViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *friendList;
@end

@implementation AddMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加成员";
    _friendList = [NSArray new];
    [self initDataSource];
     [_tableView registerNib:[UINib nibWithNibName:@"FriendListCell" bundle:nil] forCellReuseIdentifier:@"FriendListCellIdentifier"];
}

- (void)initDataSource {
    _friendList = [[NIMSDK sharedSDK].userManager myFriends];
    NSLog(@"%@", _friendList);
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
