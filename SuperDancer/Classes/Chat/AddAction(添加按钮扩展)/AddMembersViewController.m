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
@end

@implementation AddMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加成员";
    if (_teamID == nil && _team != nil) {
        _teamID = _team.teamId;
    }
    _friendList = [NSMutableArray new];
    if (_selectedMembers.count == 0) {
        _selectedMembers = [NSMutableArray new];
        [self setRightItemTitle:nil titleColor:nil action:nil];
    }else {
        [self setRightItemTitle:@"确定" titleColor:[UIColor blackColor] action:@selector(complete:)];
    }
    
    
    [self initDataSource];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"AddTeamMemberCell" bundle:nil] forCellReuseIdentifier:@"AddTeamMemberCellIdentifier"];
    
}

- (void)initDataSource {
    _friendList = (NSMutableArray *)[[NIMSDK sharedSDK].userManager myFriends];
    PPLog(@"%@", _friendList);
    if (_isCreating) {
        
    }else {
        for (NIMUser *user in _friendList) {
            if ([_teamMemberUserIDs indexOfObject:user.userId] != NSNotFound) {
                [_friendList removeObject:user];
            }
        }
    }
    PPLog(@"%@", _friendList);
    if (_friendList.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无可添加的好友" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
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
    
    if (_isCreating) {
        NSMutableArray *userIds = [NSMutableArray new];
        for (NIMUser *user in _selectedMembers) {
            [userIds addObject:user.userId];
        }
        if ([userIds indexOfObject:user.userId] == NSNotFound) {
            [cell setIsSelected:NO];
        }else {
            [cell setIsSelected:YES];
        }
    }else {
        if ([_selectedMembers indexOfObject:user.userId] == NSNotFound) {
            [cell setIsSelected:NO];
        }else {
            [cell setIsSelected:YES];
        }
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
    
    if (_isCreating) {
        NSMutableArray *userIds = [NSMutableArray new];
        for (NIMUser *user in _selectedMembers) {
            [userIds addObject:user.userId];
        }
        for (NIMUser *user in _friendList) {
            if ([user.userId isEqualToString:userId]) {
                if ([userIds indexOfObject:user.userId] == NSNotFound) {
                    [_selectedMembers addObject:user];
                }else {
                    [_selectedMembers removeObject:user];
                }
            }
        }
    }else {
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
    
    
    
    
}

- (void)complete:(UIButton *)btn {
    NSLog(@"%@", _selectedMembers);
    if (_isCreating) {
        if (_finished) {
            _finished();
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        [[NIMSDK sharedSDK].teamManager addUsers:_selectedMembers toTeam:_teamID postscript:@"邀请" completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
            if (error) {
                [self toast:error.description];
            }else {
                [self toast:@"邀请发送成功"];
            }
        }];
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
