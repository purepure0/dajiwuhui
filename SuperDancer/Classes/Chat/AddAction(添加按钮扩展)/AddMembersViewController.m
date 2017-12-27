//
//  AddMembersViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/19.
//  Copyright © 2017年 yu. All rights reserved.
//

#import "AddMembersViewController.h"
#import "AddTeamMemberCell.h"
@interface AddMembersViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *friendList;
@property (nonatomic, strong)NSMutableArray *selectedMembers;
@end

@implementation AddMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加成员";
    _friendList = [NSMutableArray new];
    _selectedMembers = [NSMutableArray new];
    
    [self initDataSource];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"AddTeamMemberCell" bundle:nil] forCellReuseIdentifier:@"AddTeamMemberCellIdentifier"];
    
}

- (void)initDataSource {
    _friendList = (NSMutableArray *)[[NIMSDK sharedSDK].userManager myFriends];
    for (NIMUser *user in _friendList) {
        if ([_teamMemberUserIDs indexOfObject:user.userId] != NSNotFound) {
            [_friendList removeObject:user];
        }
    }
    NSLog(@"%@", _friendList);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddTeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddTeamMemberCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NIMUser *user = _friendList[indexPath.row];
    
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:user.userInfo.avatarUrl] placeholder:[UIImage imageNamed:@"myaccount"]];
    cell.nicknameLabel.text = user.userInfo.nickName;
    cell.userID = user.userId;
    
    if ([_selectedMembers indexOfObject:user.userId] == NSNotFound) {
        [cell setIsSelected:NO];
    }else {
        [cell setIsSelected:YES];
    }
    __weak typeof(self) weakSelf = self;
    cell.selectedBlock = ^(NSString *userId) {
        [weakSelf addMemberWithUserId:userId];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)addMemberWithUserId:(NSString *)userId {
    if ([_selectedMembers indexOfObject:userId] == NSNotFound) {
        [_selectedMembers addObject:userId];
    }else {
        [_selectedMembers removeObject:userId];
    }
    
    if (_selectedMembers.count != 0) {
        [self setRightItemTitle:@"确定" titleColor:[UIColor blackColor] action:@selector(complete:)];
    }else {
        [self setRightItemTitle:nil titleColor:nil action:nil];
    }
}

- (void)complete:(UIButton *)btn {
    NSLog(@"%@", _selectedMembers);
    [[NIMSDK sharedSDK].teamManager addUsers:_selectedMembers toTeam:_team.teamId postscript:@"邀请" completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
        if (error) {
            [self toast:error.description];
        }else {
            [self toast:@"邀请发送成功"];
        }
    }];
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
